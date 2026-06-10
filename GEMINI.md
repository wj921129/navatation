# GEMINI.md - 项目指导文件

欢迎来到 **Navatation** 项目（极简网页浏览器新标签页）。本文件为在此代码库中工作的 AI Agent 提供核心上下文与操作指引。

## 🚀 项目概述

- **前端** (`navatation-web/`): React 18 (TypeScript) + Vite + Tailwind CSS 4 + shadcn/ui
- **后端** (`navatation-admin/`): Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis
- **文档与看板** (`doc/`): 包含需求 (PRD)、API 协议、架构设计及双分支进度看板

---

## 🚀 核心工作流 (多智能体协作架构)

为最大化开发效能并充分发挥先进 AI 的能力，本项目推崇**高效智能体协作模式**。主控 AI（即你）需发挥统筹规划与核心开发的 Superpowers，同时合理利用子 Agent 协助完成任务：

1. **主控与协作并重**：你在当前主会话中统筹负责需求分析、前后端核心代码编写等关键任务，但对于后台资料搜集、大规模代码库检索、局部独立任务或测试等，**应合理派发子 Agent (Subagents)** 协助并行处理，以提升整体研发效能。
2. **全局上下文感知**：遇到复杂问题时，直接跨越技术栈边界（如同时阅读前端组件和后端实体），优先提供最小可行修复或最优架构，直击问题核心。
3. **极简操作路径**：在确保效率的前提下，直接动用可用工具完成代码修改或环境构建；复杂任务灵活委派子 Agent。
4. **子会话超时与防卡死规范**：在调用 `invoke_subagent` 派发子智能体任务时，必须同时使用 `schedule` 工具注册超时定时器（单次建议 60-120 秒，上限 180 秒）。如遇超时或检测到卡死，必须通过 `manage_subagents` 的 `kill` 指令强制终止该子会话，主会话直接接管任务或向老板汇报，严禁子会话无限制挂起影响当前会话的响应进度。

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

对于 AI 助手：当在主会话中收到“启动前后端”指令时，你可以直接在主会话中运行服务启动工作。启动规范为：**禁止探查环境变量**，首先在 `scripts/service/` 目录运行 `start-redis.bat` 启动 Redis 服务，然后在 `navatation-admin/navatation-business` 目录运行写死的后端命令：`$env:JAVA_HOME = "D:\javaSoftware\jdk\jdk17"; mvn spring-boot:run`；最后在 `navatation-web` 目录运行 `npm run dev`。

### 2. Git 版本管理相关 (`scripts/git/`)
- **一键推送所有仓库代码（推送 git）**：[push-all.bat](file:///E:/workspace/navatation/scripts/git/push-all.bat) *(切勿主动执行，仅在用户发出指令时调用)*
- **分支开发规范（Git dev/main 双分支工作流）**：
  - **开发提交脚本**：[push-dev.bat](file:///e:/workspace/navatation/scripts/git/push-dev.bat) *(日常开发每次对话修改完，AI 必须自动运行将三仓更改推送至 dev 分支)*
  - **合并主线脚本**：[merge-to-main.bat](file:///e:/workspace/navatation/scripts/git/merge-to-main.bat) *(大规模改动通过验证后，AI 助手必须主动提示用户，并在获得确认后运行)*

- **前端开发地址**：`http://localhost:5173`
- **后端开发地址**：`http://localhost:8080` | Swagger: `http://localhost:8080/swagger-ui.html`

---

## 📜 开发规范 (高内聚职责隔离)

本项目的编码规范已全部浓缩聚合。在开始任何代码编写或修改前，AI 助手必须自觉查阅并严格遵守全栈极简开发规范：

- **全栈极简开发规范**：[base_rule.md](file:///e:/workspace/navatation/.gemini/base_rule.md)（涵盖前后端开发红线、卫语句、中文限制等所有约定）

### 📂 核心文档维护规范 (DDD 文档驱动开发)
AI 助手在每次代码改动前后，必须严格遵循以下文档同步维护要求：

- **需求与产品对照**：[PRD.md](file:///e:/workspace/navatation/doc/PRD.md) *(开发前对齐需求范围；新增功能、修改优先级必须同步更新此文档)*
- **架构设计与底层**：[backend-architecture.md](file:///e:/workspace/navatation/doc/backend-architecture.md) *(涉及缓存策略、模块结构或建表 UUID 规则等核心架构变动时，必须同步更新)*
- **接口协议定义**：[api-specification.md](file:///e:/workspace/navatation/doc/api-specification.md) *(后端 Controller、DTO 或响应结果有变动时必须 100% 同步更新)*
- **数据库建表与数据初始化脚本**：[ddl.sql](file:///e:/workspace/navatation/navatation-admin/ddl.sql) *(任何表结构、字段类型、索引的变动必须同步至该脚本)* 及 [dml.sql](file:///e:/workspace/navatation/navatation-admin/dml.sql) *(任何初始数据、预置数据的变动必须同步至该脚本)*
- **日常开发追踪 (dev)**：[WORKFLOW-STATUS-DEV.md](file:///e:/workspace/navatation/doc/WORKFLOW-STATUS-DEV.md) *(核心！仅当**修复重大 BUG** 和 **开发新功能** 时，AI 才需要在文档中追加任务日志并更新进度状态，随后再执行 push-dev 推送。普通的日常修改和代码小优化无需写入此文档，以防文件内容过载)*
- **主线版本追踪 (main)**：[WORKFLOW-STATUS.md](file:///e:/workspace/navatation/doc/WORKFLOW-STATUS.md) *(只有当大规模改动验证完成，并在用户确认合并至 main 分支后，才将 dev 看板的阶段性成果同步到此文档)*
