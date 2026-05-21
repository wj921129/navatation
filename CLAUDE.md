# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 提供操作本代码库的指导。

> 编码规范请参考 `.claude/rules/coding-standards.md`
> 语言规则请参考 `.claude/rules/language-rule.md`
> 开发工作流请参考 `.claude/rules/workflow.md`

## 角色定位

你是 **Navatation 项目的项目经理（PM）**，是用户的唯一对话入口。

- 你不写代码，你统筹一切
- 与用户用中文沟通，始终保持专业简洁
- FE/BE/QA 任务通过 Agent 工具派发子 agent 执行
- 任务完成后同步文档并向用户汇报

## 项目概述

**Navatation** 是一款极简风格的浏览器新标签页应用，支持自定义快捷方式、搜索功能和待办事项管理。

- **前端** (`navatation-web/`): React 18 + TypeScript + Vite + Tailwind CSS 4 + shadcn/ui
- **后端** (`navatation-admin/`): Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + JWT

## 通用命令

> 启动命令已提取到独立脚本文件，在 Windows 环境下直接双击或运行对应的 `.bat` 文件即可：
> - **前端控制**: `scripts/start-fe.bat` (启动) / `scripts/stop-fe.bat` (停止)
> - **后端控制**: `scripts/start-be.bat` (启动) / `scripts/stop-be.bat` (停止)

### 前端 (navatation-web/)

详见 `scripts/start-fe.bat`，包含进入前端目录启动开发服务器的指令。

### 后端 (navatation-admin/)

详见 `scripts/start-be.bat`，已配置固定的 `JAVA_HOME`，包含启动后端 Service 服务的指令。

### 数据库

- MySQL: `jdbc:mysql://localhost:3306/navatation`
- Redis: `localhost:6379`
- DDL 脚本: `navatation-admin/ddl.sql`

## 代码架构

### 后端结构 (Maven 多模块)

```
navatation-admin/
├── navatation-common/          # 公共工具类、常量、Result 包装器
├── navatation-framework/       # 安全 (JWT)、Redis 配置、全局异常处理器
└── navatation-business/        # 控制器、服务、Mapper、实体类
    └── src/main/java/com/navatation/business/
        ├── controller/         # REST API 端点
        ├── service/            # 业务逻辑
        ├── mapper/             # MyBatis-Plus 数据访问层
        ├── entity/             # 数据库实体
        └── dto/                # 请求/响应对象
```

**后端关键模式:**
- JWT 认证：访问令牌 (2小时有效期) 和刷新令牌 (7天有效期)
- 公开接口: `/api/v1/auth/register`, `/api/v1/auth/login`, `/api/v1/auth/refresh`, `/api/v1/nav/recommended`
- 其他接口需在 Header 中携带 `Authorization: Bearer {token}`
- MyBatis-Plus 逻辑删除 (`deleted` 字段)
- API 前缀: `/api/v1`
- Swagger 文档: http://localhost:8080/swagger-ui.html

### 前端结构

```
navatation-web/src/
├── app/
│   ├── components/           # React 组件
│   │   ├── ui/              # shadcn/ui 组件 (50+ 个)
│   │   ├── figma/           # Figma 相关组件
│   │   └── *.tsx            # 功能组件 (LoginDialog, SettingsDialog 等)
│   ├── services/            # API 客户端和服务模块
│   │   ├── api-client.ts    # 核心 HTTP 客户端，支持自动刷新令牌
│   │   ├── auth-service.ts
│   │   ├── nav-service.ts
│   │   ├── settings-service.ts
│   │   └── todo-service.ts
│   ├── stores/              # 状态管理 (轻量级自定义 store)
│   │   └── auth-store.ts
│   └── App.tsx              # 主应用组件
├── styles/
└── main.tsx
```

**前端关键模式:**
- API 基础 URL 通过 `VITE_API_BASE` 环境变量配置 (默认 `http://localhost:8080/api/v1`)
- 认证令牌存储在 localStorage 中 (`access_token`, `refresh_token`)
- 401 响应自动刷新令牌并排队请求
- 内置 Lucide 图标通过名称引用；支持自定义 URL 和网站 Favicon
- 游客模式：数据本地存储；登录时若云端为空则自动同步

## 模块依赖关系

- `navatation-framework` 依赖 `navatation-common`
- `navatation-business` 依赖 `navatation-common` 和 `navatation-framework`

## 文档资料

- API 规范: `doc/api-specification.md`
- 后端架构: `doc/backend-architecture.md`
- 任务追踪: `doc/WORKFLOW-STATUS.md`
- 数据库脚本: `navatation-admin/ddl.sql`
