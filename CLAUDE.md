# CLAUDE.md

本文件为 Claude Code 提供操作本代码库的指导。

> 全栈极简开发规范与红线请参考 [base_rule.md](file:///e:/workspace/navatation/.gemini/base_rule.md)
> 项目整体构建与架构红线请参考 [GEMINI.md](file:///e:/workspace/navatation/GEMINI.md)

## 角色与原则

作为 Navatation 的智能开发助手，请遵循以下核心原则：
- **第一性原理**：深入探讨最本质的业务逻辑，不盲目套用惯性思维。
- **极简改动**：极力追求用最少的代码改动实现功能，严禁过度设计。
- **主动澄清**：面对含糊需求必须主动抛出核心问题沟通，绝不盲目猜测。

## 项目概述

**Navatation** 是一款极简风格的浏览器新标签页应用，支持自定义快捷方式、搜索功能和待办事项管理。
- **前端** (`navatation-web/`): React 18 + TypeScript + Vite + Tailwind CSS 4 + shadcn/ui
- **后端** (`navatation-admin/`): Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + JWT

## 通用命令

> 启动和控制命令已整合到独立的可视化控制台菜单脚本中，在 Windows 环境下极力推荐直接运行：
> - **一键可视化控制台仪表盘**: `scripts/dashboard.bat` 
> 
> 同时也保留了底层的分类控制脚本：
> - **服务控制 (`scripts/service/`)**: `start-fe.bat`, `start-be.bat`, `start-redis.bat` 等

### 📦 代码推送与一键同步
- **推送脚本**: `scripts\git\push-all.bat "提交信息"`（不带参数则进入交互输入模式）
- **触发规范**: 仅当用户发出“推送git”或“推送代码”等关键词时，方可调用该脚本。

### 数据库
- MySQL: `jdbc:mysql://localhost:3306/navatation`
- Redis: `localhost:6379`
- 数据库脚本: [ddl.sql](file:///e:/workspace/navatation/navatation-admin/ddl.sql) 及 [dml.sql](file:///e:/workspace/navatation/navatation-admin/dml.sql)

## 代码架构

### 后端结构 (Maven 多模块)

```
navatation-admin/
├── navatation-common/          # 公共工具类、常量、Result 包装器
├── navatation-framework/       # 安全 (JWT)、Redis 配置、全局异常处理器
└── navatation-business/        # 控制器、服务、Mapper、实体类
```

**后端关键模式:**
- JWT 认证：访问令牌 (2小时有效期) 和刷新令牌 (7天有效期)
- 公开接口: `/api/v1/auth/register`, `/api/v1/auth/login`, `/api/v1/auth/refresh`, `/api/v1/nav/recommended`
- 其他接口需在 Header 中携带 `Authorization: Bearer {token}`
- MyBatis-Plus 逻辑删除 (`deleted` 字段)
- API 前缀: `/api/v1`

### 前端结构

```
navatation-web/src/
├── app/
│   ├── components/           # React 组件
│   ├── services/            # API 客户端和服务模块
│   ├── stores/              # 状态管理
│   └── App.tsx              # 主应用组件
```

**前端关键模式:**
- API 基础 URL 通过 `VITE_API_BASE` 环境变量配置
- 认证令牌存储在 localStorage 中
- 401 响应自动刷新令牌并排队请求
- 游客模式：数据本地存储；登录时若云端为空则自动同步

## 模块依赖关系

- `navatation-framework` 依赖 `navatation-common`
- `navatation-business` 依赖 `navatation-common` 和 `navatation-framework`

## 文档资料

- API 规范: [api-specification.md](file:///e:/workspace/navatation/doc/api-specification.md)
- 后端架构: [backend-architecture.md](file:///e:/workspace/navatation/doc/backend-architecture.md)
- 任务追踪: [WORKFLOW-STATUS.md](file:///E:/workspace/navatation/doc/WORKFLOW-STATUS.md)
