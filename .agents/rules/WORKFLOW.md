# WORKFLOW.md - Navatation 项目工作流规范

> **本文件是 [GEMINI.md](file:///E:/workspace/navatation/GEMINI.md) 的子规范，聚焦于工作流、构建运行与 Pipeline 闭环。**

## 📜 严格的 DDD 文档驱动开发 (Doc-Driven)
**代码即文档，文档即代码。** 在进行以下变动时，必须同步更新对应的文档：
- **[PRD]** ([PRD.md](file:///E:/workspace/navatation/doc/PRD.md)): 新功能或业务规则调整前后对齐。
- **[设计与规划]**: 所有任务规划、设计方案必须且只能输出到 `doc/specs/` 和 `doc/plans/` 目录中，严禁写入任何第三方或非标准路径。
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
**绝对红线**：绝对禁止使用 `.worktrees/` 目录或创建功能开发分支，所有开发行为必须严格且仅在 `dev` 分支进行。本项目仅允许 `dev` 与 `main` 双分支模型。
- **日常开发**：在 `dev` 分支进行。任务完成交付前执行 Git 推送闭环。
- **合并发布 (`main` 分支)**：大特性在 `dev` 验证无误并获得明确许可后，运行 [merge-to-main.bat](file:///E:/workspace/navatation/scripts/git/merge-to-main.bat) 合并推送。

## 📊 任务收尾: Git 推送 + METRICS 复盘 (收尾闭环)

> **收尾衔接**：此为任务交付的最终阶段。在本地修改与验证通过后，必须立即进入本阶段。

### 5. 任务收尾与复盘闭环
**⚠️ 【最高行为红线】 ⚠️**
1. **临时文件清理闭环**：在宣布任务完成或进入收尾前，必须严格检查并主动清理（如使用 `rm`、撤销测试端点）所有在调试或测试过程中创建的临时脚本、临时测试代码及调试日志，严禁将其遗留或提交进版本库，确保工程环境纯净。
2. **强制调用技能**：无论经过何种测试或验证流程，任务交付的**绝对最终出口**必须是调用 `custom-finish-development-task` 技能。
3. **静默推送与度量**：严禁在本地存在未提交代码时向老板宣布“已完成”。AI 在结束最后阶段时，应依赖 `custom-finish-development-task` 自动执行 Git 推送并在回复末尾强制附带 `[METRICS]` 复盘模块。具体格式与步骤由该技能接管，你只需无条件触发它。

