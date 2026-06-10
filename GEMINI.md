# GEMINI.md - Navatation 项目工作台指南

<PROJECT_OVERVIEW>
欢迎来到 **Navatation** 项目。这是一个极简网页浏览器新标签页。
作为此项目的 AI 助手，请在确保遵守全局 `GEMINI.md` 及项目 `.gemini/base_rule.md` 的所有强制约束的前提下，根据本文件提供的指南来操作项目的日常工作流。
</PROJECT_OVERVIEW>

## 🚀 核心架构与模块分布
- **前端项目** (`navatation-web/`): 基于 React 18 (TypeScript) + Vite + Tailwind CSS 4 + shadcn/ui。
- **后端项目** (`navatation-admin/`): 基于 Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis。
- **项目文库** (`doc/`): 包含需求文档 (PRD)、API 协议、架构设计文档。

## 🛠️ 构建与运行 (Windows 专属控制面板)
项目脚本已在 `scripts/` 目录下提供了一键可视化仪表盘和独立的启动脚本，**所有的环境操作必须通过调用这些写好的脚本执行，严禁自己探测和配置环境。**

### 1. 统一可视化仪表盘 (极力推荐)
- **入口**：[dashboard.bat](file:///e:/workspace/navatation/scripts/dashboard.bat)
- **说明**：此脚本提供了图形化的交互菜单，你可以告知用户双击它来快速管理前端、后端、Redis 以及 Git 推送。

### 2. 快捷启动链路规则
当你收到“启动前后端”类似指令时，你应当且必须直接在后台任务中按顺序调用以下命令：
1. **启动 Redis**: `.\start-redis.bat` (Cwd 必须是 `e:\workspace\navatation\scripts\service`)
2. **启动后端服务**: `$env:JAVA_HOME = "D:\javaSoftware\jdk\jdk17"; mvn spring-boot:run` (Cwd 必须是 `e:\workspace\navatation\navatation-admin\navatation-business`)
3. **启动前端服务**: `npm run dev` (Cwd 必须是 `e:\workspace\navatation\navatation-web`)

### 3. Git 自动化与分支工作流
本项目采用严格的 `dev` 与 `main` 双分支模型：
- **开发暂存与同步**：日常开发中每次完成一个闭环的修改后，AI 助手**必须自动使用后台任务运行** [push-dev.bat](file:///e:/workspace/navatation/scripts/git/push-dev.bat) 脚本，将所有修改即刻推送至 `dev` 分支。
- **合并主线**：当某个大特性或大规模改动在 `dev` 分支验证完成后，AI 助手必须主动提醒用户，获得明确许可后运行 [merge-to-main.bat](file:///e:/workspace/navatation/scripts/git/merge-to-main.bat) 脚本合并并推送至 `main` 分支。

## 📜 严格的 DDD 文档驱动开发
你在每一次代码增删改查前后，都必须同步更新以下对应的系统文档，确保文档与代码 **100% 绝对一致**：
- [PRD.md](file:///e:/workspace/navatation/doc/PRD.md): 只要涉及新功能开发或业务规则调整，开发前必须对齐，开发后必须更新。
- [backend-architecture.md](file:///e:/workspace/navatation/doc/backend-architecture.md): 一旦发生缓存策略调整、建表 UUID 规则、表分区或工程结构变化，必须同步记录。
- [api-specification.md](file:///e:/workspace/navatation/doc/api-specification.md): 后端暴露的任何 Controller、DTO 和响应结构的增改，必须实时反映到此接口协议文档！
- **建表及预置数据管理**: 表结构变更必须追加到 [ddl.sql](file:///e:/workspace/navatation/navatation-admin/ddl.sql)；初始化数据的变更必须追加到 [dml.sql](file:///e:/workspace/navatation/navatation-admin/dml.sql)。
- [WORKFLOW-STATUS-DEV.md](file:///e:/workspace/navatation/doc/WORKFLOW-STATUS-DEV.md): 仅针对重大 BUG 修复和新功能开发，你需要更新任务进度看板。日常的小优化或常规调整无需写入，以避免文档极度臃肿。
