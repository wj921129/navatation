# AGENTS.md

This file provides guidance to Qoder (qoder.com) when working with code in this repository.

## Project Overview

**Navatation** 是一款极简风格的浏览器新标签页应用，支持自定义快捷方式、搜索功能和待办事项管理。

## Tech Stack

| Layer | Stack |
|:------|:------|
| **Frontend** | React 18 (TypeScript) + Vite 6 + Tailwind CSS 4 + shadcn/ui |
| **Backend** | Spring Boot 3.3.5 + Java 17 + MyBatis-Plus 3.5.7 + MySQL 8 + Redis + JWT (jjwt 0.12.6) |

## Build & Run Commands

### Frontend (`navatation-web/`)
```bash
npm run dev          # 开发服务器 (Vite)
npm run build        # 生产构建
npm run test         # 运行测试 (Vitest)
```

### Backend (`navatation-admin/navatation-business/`)
```bash
# 需要设置 JAVA_HOME 为 JDK 17
$env:JAVA_HOME = "D:\javaSoftware\jdk\jdk17"
mvn spring-boot:run  # 启动后端服务
mvn test             # 运行单元测试 (在 navatation-admin/ 目录下)
```

### Service Scripts (`scripts/service/`)
- `start-redis.bat` - 启动 Redis
- `start-be.bat` / `stop-be.bat` - 启动/停止后端
- `start-fe.bat` / `stop-fe.bat` - 启动/停止前端
- `start-all.bat` / `stop-all.bat` - 一键启动/停止所有服务

### Git Workflow (`scripts/git/`)
- `push-dev.bat "提交描述"` - 推送到 dev 分支
- `push-all.bat "提交描述"` - 推送所有分支
- `merge-to-main.bat` - 合并 dev 到 main

### 启动顺序
1. Redis → 2. Backend → 3. Frontend

## Code Architecture

### Backend (Maven Multi-Module)
```
navatation-admin/
├── navatation-common/       # 公共模块：工具类、常量、Result<T> 包装器、异常定义
├── navatation-framework/    # 框架模块：JWT 安全、Redis 配置、全局异常处理器、拦截器
└── navatation-business/     # 业务模块：Controller → Service → Mapper → Entity/DTO/VO
```

**Module Dependencies:**
- `navatation-framework` → depends on → `navatation-common`
- `navatation-business` → depends on → `navatation-common` + `navatation-framework`

**Key Patterns:**
- API 统一前缀: `/api/v1`
- JWT 双令牌: Access Token (2h) + Refresh Token (7d)
- 公开端点: `/api/v1/auth/register`, `/api/v1/auth/login`, `/api/v1/auth/refresh`, `/api/v1/nav/recommended`
- 其余端点需 Header: `Authorization: Bearer {token}`
- 所有响应包装为 `Result<T>`
- MyBatis-Plus 逻辑删除 (`deleted` 字段)
- 全局异常处理器 `@RestControllerAdvice` + 自定义 `BusinessException`

### Frontend Structure
```
navatation-web/src/
├── app/
│   ├── components/      # shadcn/ui 组件
│   ├── hooks/           # 自定义 Hooks
│   ├── services/        # API 调用层 (api-client.ts 统一封装)
│   ├── stores/          # 状态管理
│   └── constants/       # 常量定义
├── config/              # 项目配置
└── styles/              # 样式资源
```

**Key Patterns:**
- API Base URL 通过 `VITE_API_BASE` 环境变量配置
- 认证令牌存储在 localStorage
- 401 响应自动刷新令牌并排队重试
- 游客模式：数据本地存储；登录后若云端为空则自动同步
- 样式只使用 Tailwind utility classes + `cn()` 合并，禁止自定义 CSS 和 inline styles
- 密码传输使用 RSA 加密（参见 `doc/rsa-login-encryption-design.md`）

## Database
- MySQL: `jdbc:mysql://localhost:3306/navatation`
- Redis: `localhost:6379`
- DDL 变更记录: `navatation-admin/ddl.sql`
- DML 数据变更: `navatation-admin/dml.sql`

## Coding Standards

编码规范的唯一权威来源为 [`.gemini/base_rule.md`](./.gemini/base_rule.md)，涵盖：
- 通用红线（文件行数、嵌套深度、命名纪律）
- 前端规范（禁止 any/自定义 CSS/inline styles）
- 后端规范（分层架构、N+1 防护、日志规范）
- 安全红线与错误处理架构
- 测试规范

## Doc-Driven Development

代码变更时需同步更新对应文档:
- `doc/PRD.md` - 新功能/业务规则
- `doc/api-specification.md` - 接口/DTO/响应结构变更
- `doc/backend-architecture.md` - 架构/缓存/工程结构变化
- `navatation-admin/ddl.sql` / `dml.sql` - 数据库变更

## Git 提交规则

**任何代码修改完成后，必须提交到 dev 分支。**

1. 使用 `scripts/git/push-dev.bat "提交描述"` 提交并推送到 dev 分支
2. 提交说明必须清晰描述本次修改的内容和目的，禁止使用默认信息
3. 如有文档相关变更，需同步更新对应文档（参见 Doc-Driven Development）
