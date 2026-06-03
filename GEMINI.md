# GEMINI.md - 项目指导文件

欢迎来到 **Navatation** 项目（极简网页浏览器新标签页）。本文件为在此代码库中工作的 AI Agent 提供核心上下文与操作指引。

## 🚀 项目概述

- **前端** (`navatation-web/`): React 18 (TypeScript) + Vite + Tailwind CSS 4 + shadcn/ui
- **后端** (`navatation-admin/`): Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis
- **文档与看板** (`doc/`): 包含需求 (PRD)、API 协议、架构设计及双分支进度看板

---

## 👥 角色划分与协作限制 (优化版职责隔离机制)

为优化开发效率并确保核心源码与规范的安全，AI 助手需遵守以下职责边界：
1. **项目经理 (PM) 职责**：项目经理在主会话中可直接负责并执行除**修改代码**和**更新 API 文档**之外的所有任务。这包括：启动/停止/重启服务、运行测试、执行 Git 仓库推送或合并分支脚本，以及其他命令行辅助操作。
2. **特定任务子 Agent 派发**：仅当任务涉及**源码编写/修改**、**API 协议更新 (`doc/api-specification.md`)** 等核心开发与规范变动时，项目经理才必须通过 `define_subagent` 定义前端 (FE) 或后端 (BE) 角色，并使用 `invoke_subagent` 派发执行。
3. **主会话权限**：项目经理可在主会话中直接运行日常运维脚本、启动命令或 Git 指令，无需因脚本执行或服务启停派发子 Agent。

---

## 🛠️ 构建与运行 (Windows 极简控制面板)

项目脚本已在 `scripts/` 目录下提供了一键可视化仪表盘，并按功能分类整理为 **启动服务相关 (`scripts/service/`)** 与 **Git 版本管理相关 (`scripts/git/`)**：

### 0. 🛠️ 统一可视化控制台仪表盘 (极力推荐)
- **仪表盘入口**：[dashboard.bat](file:///e:/workspace/navatation/scripts/dashboard.bat)
- **使用说明**：直接双击或运行该脚本，即可在命令行图形化交互菜单中，一键选择启动/重启/停止前端、后端、Redis 缓存服务，或者进行所有子仓库代码的一键 Git 提交与推送。

### 1. 启动与停止服务相关 (`scripts/service/`)
为解决 Windows 环境兼容性，已提供写死 JDK 路径的批处理脚本：
- **开启后端服务 (写死 JAVA_HOME)**：`scripts/service/start-be.bat`
- **关闭后端服务**：`scripts/service/stop-be.bat`
- **开启前端服务**：`scripts/service/start-fe.bat`
- **关闭前端服务**：`scripts/service/stop-fe.bat`
- **开启 Redis 缓存 (启动目录 D:\javaSoftware\Redis)**：`scripts/service/start-redis.bat`
- **关闭 Redis 缓存**：`scripts/service/stop-redis.bat`

对于 AI 助手：当在主会话中收到“启动前后端”指令时，项目经理（PM）可以直接在主会话中运行服务启动工作。启动规范为：**禁止探查环境变量**，首先在 `scripts/service/` 目录运行 `start-redis.bat` 启动 Redis 服务，然后在 `navatation-admin/navatation-business` 目录运行写死的后端命令：`$env:JAVA_HOME = "D:\javaSoftware\jdk\jdk17"; mvn spring-boot:run`；最后在 `navatation-web` 目录运行 `npm run dev`。

### 2. Git 版本管理相关 (`scripts/git/`)
- **一键推送所有仓库代码（推送 git）**：[push-all.bat](file:///E:/workspace/navatation/scripts/git/push-all.bat) *(切勿主动执行，仅在用户发出指令时调用)*
- **分支开发规范（Git dev/main 双分支工作流）**：
  - **开发提交脚本**：[push-dev.bat](file:///e:/workspace/navatation/scripts/git/push-dev.bat) *(日常开发每次对话修改完，AI 必须自动运行将三仓更改推送至 dev 分支)*
  - **合并主线脚本**：[merge-to-main.bat](file:///e:/workspace/navatation/scripts/git/merge-to-main.bat) *(大规模改动通过验证后，PM 必须主动提示用户，并在获得确认后运行)*

- **前端开发地址**：`http://localhost:5173`
- **后端开发地址**：`http://localhost:8080` | Swagger: `http://localhost:8080/swagger-ui.html`

---

## 📜 开发规范 (高内聚职责隔离)

本项目的编码规范已独立化、细粒度化拆分。在开始任何代码编写或修改前，前端与后端开发角色必须自觉查阅并严格遵守：

- **后端开发规范 (BE)**：[backend-standards.md](file:///e:/workspace/navatation/.gemini/rules/backend-standards.md)（Java 17、卫语句、禁止通配符导入、MyBatis `#{}`、日志规范、安全红线、DDL 同步等）
- **前端开发规范 (FE)**：[frontend-standards.md](file:///e:/workspace/navatation/.gemini/rules/frontend-standards.md)（React 18、嵌套层级限制、卫语句、可选链 `?.` 与空值合并 `??`、TSDoc 等）

### 📂 核心文档链接
- 需求对照：[PRD.md](file:///e:/workspace/navatation/doc/PRD.md)
- 接口定义：[api-specification.md](file:///e:/workspace/navatation/doc/api-specification.md) *(有变动必须 100% 同步更新)*
- 数据库脚本：[ddl.sql](file:///e:/workspace/navatation/navatation-admin/ddl.sql) *(表结构变动必填)*
- 看板追踪：[WORKFLOW-STATUS.md](file:///E:/workspace/navatation/doc/WORKFLOW-STATUS.md) *(PM 每次任务结束后必须更新)*
