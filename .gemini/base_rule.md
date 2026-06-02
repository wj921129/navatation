---
trigger: always_on
---

## 团队协作工作流（四角色模式）

本项目启用四角色协作工作流。在此项目中进行任何开发、测试、修复、文档维护任务时，必须加载并遵守以下规范：

**工作流总纲**：`.gemini/workflow/team-workflow.md` — 角色调度、文档同步、Bug 处理流程
**项目经理（PM）**：`.gemini/workflow/role-pm.md` — 唯一对话入口，统筹全局
**前端开发（FE）**：`.gemini/workflow/role-frontend.md` — 负责 `navatation-web/`
**后端开发（BE）**：`.gemini/workflow/role-backend.md` — 负责 `navatation-admin/`
**测试工程师（QA）**：`.gemini/workflow/role-qa.md` — 浏览器端对端测试（被动调度，仅在用户指令下激活）

### 激活规则

- **任何开发任务**（新功能、Bug 修复、重构）→ 激活完整工作流，PM 主导
- **纯文档任务**（仅更新 doc/）→ PM 直接处理，无需调度其他角色
- **纯问答咨询**（解释代码、架构探讨）→ 正常回答，不强制进入工作流

### 任务看板

项目当前任务状态维护在 `doc/WORKFLOW-STATUS.md`，PM 在每次任务结束后必须更新。

---

## 📜 代码编写与生成规范

为了实现极致的高内聚和职责隔离，本项目的开发代码规范已被完全拆分为独立文件。在修改任何代码前，AI 助手对应的角色必须自觉查看并无条件遵守以下独立文件中的所有规范细节：

* **后端开发规范 (BE)**：[backend-standards.md](file:///e:/workspace/navatation/.gemini/rules/backend-standards.md)
  * *涵盖*：JDK 17、Guard Clauses 卫语句、禁止通配符导入、MyBatis `#{}` 占位符、异常捕获、批量 DB 查询、日志规范、DDL 变更同步等。
* **前端开发规范 (FE)**：[frontend-standards.md](file:///e:/workspace/navatation/.gemini/rules/frontend-standards.md)
  * *涵盖*：React 18、Vite、Tailwind CSS 4、嵌套层级 ≤3 层控制、卫语句、Optional Chaining 可选链、JSDoc 注释规范、加载/出错友好 UI 处理等。