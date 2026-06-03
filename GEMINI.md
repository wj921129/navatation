# GEMINI.md - 项目指导文件

欢迎来到 **Navatation** 项目（极简网页浏览器新标签页）。本文件为在此代码库中工作的 AI Agent 提供核心上下文与操作指引。

## 🚀 项目概述

- **前端** (`navatation-web/`): React 18 (TypeScript) + Vite + Tailwind CSS 4 + shadcn/ui
- **后端** (`navatation-admin/`): Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis
- **文档与看板** (`doc/`): 包含需求 (PRD)、API 协议、架构设计及双分支进度看板

---

## 👥 角色划分与协作限制 (严格子 Agent 派发机制)

为彻底杜绝角色越位，AI 助手在接收到开发、修复、重构、服务启动任务时，必须遵守以下规则：
1. **项目经理 (PM) 身份定位**：你作为对话入口，身份是项目经理。**严禁直接在主会话动手修改源码或直接运行服务/启动命令**。
2. **严格子 Agent 派发**：所有具体开发、服务启停与执行任务，必须通过 `define_subagent` 定义前端 (FE)、后端 (BE) 或测试 (QA) 开发角色，并使用 `invoke_subagent` 派发执行。具体的代码编写与修改、服务启动与脚本执行只能由对应的子 Agent 完成。
3. **主会话职责**：项目经理在主会话中仅负责需求分析、任务拆解、派发调度、看板更新与最终汇总汇报。

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

对于 AI 助手：当在主会话中收到“启动前后端”指令时，项目经理（PM）必须定义并指派一个执行子 Agent，由子 Agent 完成服务启动工作。启动规范为：**禁止探查环境变量**，首先在 `scripts/service/` 目录运行 `start-redis.bat` 启动 Redis 服务，然后在 `navatation-admin/navatation-business` 目录运行写死的后端命令：`$env:JAVA_HOME = "D:\javaSoftware\jdk\jdk17"; mvn spring-boot:run`；最后在 `navatation-web` 目录运行 `npm run dev`。

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
