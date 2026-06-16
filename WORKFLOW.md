# WORKFLOW.md - Navatation 项目工作流规范

> **本文件是 [GEMINI.md](file:///E:/workspace/navatation/GEMINI.md) 的子规范，聚焦于工作流、构建运行与 Pipeline 闭环。**

## 📜 严格的 DDD 文档驱动开发 (Doc-Driven)
**代码即文档，文档即代码。** 在进行以下变动时，必须同步更新对应的文档：
- **[PRD]** ([PRD.md](file:///E:/workspace/navatation/doc/PRD.md)): 新功能或业务规则调整前后对齐。
- **[接口协议]** ([api-specification.md](file:///E:/workspace/navatation/doc/api-specification.md)): 任何 Controller 接口、DTO 或响应结构的增改。
- **[数据表]**: 表结构变更追加到 [ddl.sql](file:///E:/workspace/navatation/navatation-admin/ddl.sql)；数据变更追加到 [dml.sql](file:///E:/workspace/navatation/navatation-admin/dml.sql)。
- **[架构设计]** ([backend-architecture.md](file:///E:/workspace/navatation/doc/backend-architecture.md)): 缓存策略、表分区或工程结构变化。
- **[任务看板]** ([WORKFLOW-STATUS-DEV.md](file:///E:/workspace/navatation/doc/WORKFLOW-STATUS-DEV.md)): 重大 BUG 修复和新功能开发进度。常规小优化无需写入。

## 🛠️ 构建、运行与自动化工作流
所有环境操作必须通过 `scripts/` 下的脚本执行，严禁自己探测和瞎写系统启动命令。

### 1. 可视化仪表盘
- **入口**：[dashboard.bat](file:///E:/workspace/navatation/scripts/dashboard.bat) (告知老板双击它来快速管理前后端、Redis及Git推送)

### 2. AI 快捷启动链路规则
当老板让你"启动前后端"时，必须按以下顺序**直接启动后台任务**：
1. **Redis**: `.\start-redis.bat` (Cwd: `E:\workspace\navatation\scripts\service`)
2. **Backend**: `$env:JAVA_HOME = "D:\javaSoftware\jdk\jdk17"; mvn spring-boot:run` (Cwd: `E:\workspace\navatation\navatation-admin\navatation-business`)
3. **Frontend**: `npm run dev` (Cwd: `E:\workspace\navatation\navatation-web`)

### 3. 分支推送工作流 (CRITICAL)
本项目采用 `dev` 与 `main` 双分支模型。
- **日常推送 (`dev` 分支)**：完成任何修改且**向老板开口汇报之前**，必须自动调用 [push-dev.bat](file:///E:/workspace/navatation/scripts/git/push-dev.bat) 推送。调用时必须传入简短准确的提交描述（例如：`.\push-dev.bat "feat: 增加全局ESC关闭弹窗功能"`），严禁使用默认描述。执行复杂计划创建 `task.md` 时，必须将 `[ ] 自动运行 .\push-dev.bat 推送代码` 作为最后一项任务。
- **合并发布 (`main` 分支)**：大特性在 `dev` 验证无误后，获得明确许可后再运行 [merge-to-main.bat](file:///E:/workspace/navatation/scripts/git/merge-to-main.bat) 推送至 `main`。

## 📊 PHASE 5: Git 推送 + METRICS 复盘 (Pipeline 收尾)

> **Pipeline 衔接**：此为用户级 Pipeline（PHASE 0-4）的项目级收尾阶段。当 PHASE 4 验证通过后，必须立即进入本阶段。

### 5.1 Git 推送闭环
**⚠️ 【最高行为红线】 ⚠️**
只要对工程目录下的任何文件进行了写操作，**向老板开口汇报前的最后一项动作**，必须且只能是运行 `.\push-dev.bat "描述"` 脚本进行推送。绝对严禁在本地存在未提交更改时向老板汇报完成。

### 5.2 METRICS 复盘输出
**⚠️ 【CRITICAL 强制输出红线】 ⚠️**
在**每一次对话、任务或修复的最后一次文字汇报中**，必须且只能在回复消息体的**最末尾**附带一个标准的 `[METRICS]` 统计模块。此为强制规则，**不论任务大小皆不可省略**！

你需要从自身的上下文记忆中提取并按以下格式原样输出清单：
1. **Plugins / MCP & Skills**：明确列出本次对话中调用的外部插件、MCP 服务名或特定规范库。
2. **原生 Tools**：使用了哪些关键底层工具（如 `run_command`, `replace_file_content` 等）。
3. **Subagents**：如果派发了后台子智能体，请简述。若无则填"未派发"。

*注：此约束旨在保证 AI 操作的 100% 透明度。为了辅助度量，老板可随时运行 `scripts/metrics/analyze-ai-metrics.ps1` 进行 JSONL 日志深层扫除统计。*

---

## 🤖 agy (Antigravity) CLI 特有配置与工作流

为了在 `agy` 环境下获得最流畅的自动化体验，当前项目已完成以下平台级集成：

### 1. 服务生命周期自动管理
项目在 `.agents/settings.json` 中配置了 `SessionStart` 和 `SessionEnd` 钩子，具备以下行为：
- **启动 agy 时**：自动在后台运行 `scripts/service/start-all.bat` 以有序拉起 Redis → 后端 Spring Boot → 前端 React 开发服务器，无需手动启动。
- **关闭 agy 时**：自动触发 `scripts/service/stop-all.bat` 清理进程，关闭前后端及 Redis 进程，释放系统端口。

### 2. 自动命令执行策略
- **`autoExecutionPolicy`** 设为 `always`（由 `.agents/settings.json` 控制），对安全命令范围内的指令允许自动执行而不频繁打扰用户。
- **允许的安全命令白名单**：`npm`, `npx`, `mvn`, `git`, `java`, `cmd.exe`, `powershell`。

### 3. 实时代码评审
在 `agy` 的 TUI 环境下工作时，AI 助手在每次交付代码时，必须首先保证代码的类型安全性与构建正确性，并在开口汇报前完成 `.\push-dev.bat` 的代码同步。
