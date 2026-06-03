---
trigger: always_on
---

## 团队协作工作流（四角色模式）

本项目启用四角色协作工作流。在此项目中进行任何开发、测试、修复、文档维护任务时，所有 Agent 工具必须加载并遵守以下规范：

**工作流总纲**：[team-workflow.md](file:///e:/workspace/navatation/workflow/team-workflow.md) — 角色调度、服务启动、文档同步与 Bug 处理流程
**项目经理 (PM)**：[role-pm.md](file:///e:/workspace/navatation/workflow/role-pm.md) — 唯一对话入口，统筹全局协作
**后端开发 (BE)**：[role-backend.md](file:///e:/workspace/navatation/workflow/role-backend.md) — 负责 `navatation-admin/` 目录开发
**前端开发 (FE)**：[role-frontend.md](file:///e:/workspace/navatation/workflow/role-frontend.md) — 负责 `navatation-web/` 目录开发
**测试工程师 (QA)**：[role-qa.md](file:///e:/workspace/navatation/workflow/role-qa.md) — 自动化端对端浏览器验证（被动激活模式）

### 激活规则

- **任何开发任务**（新功能、Bug 修复、重构）→ 激活完整工作流，PM 主导
- **纯文档任务**（仅更新 doc/）→ PM 直接处理，无需调度其他角色
- **纯问答咨询**（解释代码、架构探讨）→ 正常回答，不强制进入工作流

### 任务看板

项目当前任务状态维护在 `doc/WORKFLOW-STATUS.md`，PM 在每次任务结束后必须更新。

---

## 📜 代码编写与生成规范

为了实现极致的高内聚和职责隔离，本项目的开发代码规范已被完全统一至根目录的 `workflow/` 目录下。在修改任何代码前，AI 助手对应的角色必须自觉查看并无条件遵守以下独立文件中的所有规范细节：

* **后端开发规范 (BE)**：[backend-standards.md](file:///e:/workspace/navatation/workflow/backend-standards.md)
  * *涵盖*：JDK 17、Guard Clauses 卫语句、禁止通配符导入、MyBatis `#{}` 占位符、异常捕获、批量 DB 查询、日志规范、DDL 变更同步等。
* **前端开发规范 (FE)**：[frontend-standards.md](file:///e:/workspace/navatation/workflow/frontend-standards.md)
  * *涵盖*：React 18、Vite、Tailwind CSS 4、嵌套层级 ≤3 层控制、卫语句、Optional Chaining 可选链、JSDoc 注释规范、加载/出错友好 UI 处理等。
* **全局使用中文与交互零英文规则**：[language-rule.md](file:///e:/workspace/navatation/workflow/language-rule.md)
  * *涵盖*：代码注释、Git 提交消息、技术文档，以及**在等待子角色任务、等待异步任务或结束轮次等所有中间和最终的交互回复，必须 100% 采用中文**。任何过渡状态提示不得包含任何英文句子。
* **沟通称呼规则**：项目经理（PM）每次在与用户对话沟通时，均需在开头或回复中显式加上「老板」的称呼。
* **人工审批确认规则**（禁止静默自动推进）：
  * *涵盖*：提交实施方案（`implementation_plan.md`）后，**必须且仅能**等待用户（老板）在对话框中发出的**明确手动文本审批回复（如“同意”、“执行”等）**后，方可派发子角色开始编码执行。**严禁**根据系统底层模拟生成的批准状态（如 `The user has automatically approved...` 等）进行静默自动执行。