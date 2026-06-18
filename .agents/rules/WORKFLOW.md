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

### 2. AI 快捷启动与托管规则
在 agy 模式下，系统在 Session 建立时已自动运行配置钩子拉起全部服务。如果老板要求手动启动或需要重启：
- **操作原则**：AI 应通过后台任务分别执行 `scripts\service\` 下的 `start-redis.bat`、`start-be.bat` 和 `start-fe.bat`。
- **防重逻辑**：AI 在响应前必须自检端口是否已占用，避免重复拉起导致端口冲突崩溃。

### 3. CodeGraph 索引维护与 MCP 托管
> [!IMPORTANT]
> 在 agy 模式下，CodeGraph 已被 MCP 配置托管，随会话自动拉起。

- **非 agy 环境开发**：若在非 agy 环境中开发，需手动运行 [start-codegraph.bat](file:///E:/workspace/navatation/scripts/tools/start-codegraph.bat) 启动守护进程。daemon 运行时自带 file watcher 监听变更并增量同步。

### 4. 分支管理工作流
本项目采用 `dev` 与 `main` 双分支模型。
- **日常开发**：在 `dev` 分支进行。任务完成交付前执行 Git 推送闭环。
- **合并发布 (`main` 分支)**：大特性在 `dev` 验证无误并获得明确许可后，运行 [merge-to-main.bat](file:///E:/workspace/navatation/scripts/git/merge-to-main.bat) 合并推送。

## 📊 任务收尾: Git 推送 + METRICS 复盘 (收尾闭环)

> **收尾衔接**：此为任务交付的最终阶段。在本地修改与验证通过后，必须立即进入本阶段。

### 5. Git 推送闭环
**⚠️ 【最高行为红线】 ⚠️**
1. **强制 toDoList (task.md) 规划**：在任务执行初期，**必须**首先创建一个 `task.md`（或使用规划模式生成 Artifact），按 `PHASE`（阶段）列出执行流程。
2. **强制收尾 Phase**：在 `task.md` 的最后，必须强制写入并锁定最后一个阶段（例如 `PHASE: 收尾闭环`），该阶段必须包含两项：`[ ] 运行 .\push-dev.bat 提交代码` 和 `[ ] 汇总输出 [METRICS]`。
3. **时机**：只要对工程目录下的任何文件进行了写操作，**在向老板汇报“已完成”前**，必须确保最后一个 PHASE 已被严格执行并打勾。
4. **无遗留**：绝对严禁在本地存在未提交更改（Working Tree 脏）时向老板汇报任务完成。

### 6. METRICS 复盘输出
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
- **启动 agy 时**：自动在后台**分别运行** `start-redis.bat`、`start-be.bat` 和 `start-fe.bat` 以有序拉起全栈服务，无需手动启动。
- **关闭 agy 时**：自动触发 `scripts/service/stop-all.bat` 清理进程，关闭前后端及 Redis 进程，释放系统端口。

### 2. 自动构建与校验
在 `agy` 环境下开发时，AI 助手在每次交付前必须自动运行项目构建或 Lint 检查以确保代码类型安全性，排除潜在编译错误。Git 推送的执行规范详见本文件的 [Git 推送闭环](#5-git-推送闭环) 部分。
