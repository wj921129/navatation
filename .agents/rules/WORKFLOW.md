# WORKFLOW.md - Navatation 项目工作流规范

> **[AGENTS.md](file:///E:/workspace/navatation/AGENTS.md) 子规范：聚焦工作流、构建与闭环。**

## 📜 一、 DDD 文档驱动 (Doc-Driven)
**文档即代码，代码变动必同步文档：**
- **[PRD]**: 功能/业务调整更新 `doc/PRD.md`。
- **[设计]**: 规划/设计方案仅限输出至 `doc/specs/` 与 `doc/plans/`，严禁写入非标准路径。
- **[接口]**: 接口/DTO 增改同步至 `doc/api-specification.md`。
- **[数据]**: 表结构变更入 `ddl.sql`，数据变更入 `dml.sql`。
- **[架构]**: 缓存/架构变动同步至 `doc/backend-architecture.md`。
- **[看板]**: 重大特性或核心 BUG 进度更新至 `doc/WORKFLOW-STATUS-DEV.md`。

## 🛠️ 二、 构建与服务自动化
**环境与启动操作必须通过 `scripts/`，严禁手动猜测或自行拼凑命令。**

1. **Dashboard 面板**：引导老板使用 `dashboard.bat` 进行可视化服务管理。
2. **AI 启停托管**：
   - agy 模式下服务已自动拉起。
   - 若需手动干预，必须通过后台任务独立执行 `start-redis.bat`、`start-be.bat`、`start-fe.bat`。
   - **防重红线**：操作前必须自检端口占用，杜绝重复拉起导致崩溃。
3. **Codebase Memory 索引**：首次安装或重建请运行 `install-codebase-memory.bat`，之后通过后台自动维护。
4. **分支管理红线**：仅允许 `dev` 与 `main` 双分支模型。
   - **严禁**使用 `.worktrees/` 或创建其他开发分支，日常开发**仅限**在 `dev` 分支进行。
   - 特性验证通过后，运行 `merge-to-main.bat` 合并发布。

## 📊 三、 节点推送与收尾闭环

### 1. 及时节点提交 (防冲突)
**多端开发环境下，必须及时推送，杜绝代码堆积冲突：**
- **微节点推送**：独立小功能/Bug修复完成后，立即调用 `scripts\git\push-dev.bat` 推送代码，无需等待整个任务结束。
- **阶段性同步**：在等待老板反馈期间，必须主动将当前稳定的阶段性代码推送至远程 `dev` 分支。
- *注：中间推送无需调用收尾技能，执行 push 脚本即可。*

### 2. 最终收尾与复盘闭环
**⚠️ 【最高行为红线】 ⚠️**
1. **强制清理**：任务交付前，必须彻底删除（`rm` 或回滚）所有临时脚本、测试代码及日志，确保工程环境绝对纯净。
2. **强制闭环出口**：任务彻底完成后的**绝对最终动作**必须是调用 `custom-finish-development-task` 技能。
3. **静默推送与度量**：严禁携带未提交代码宣布“完成”。必须通过收尾技能执行最终 Git Push，并在回复末尾强制附带 `[METRICS]` 复盘模块。

