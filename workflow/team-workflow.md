# 团队协作工作流 总纲

本工作流为在此项目中的所有 AI Agent (如 Claude, Gemini) 及多 Agent 协作提供统筹指导。

## 1. 团队角色与分工

| 角色 | 代号 | 职责范围 | 工作目录 |
| :--- | :--- | :--- | :--- |
| **项目经理** | **PM** | 需求分析、任务拆解、角色调度、文档同步与看板更新 | `doc/` |
| **后端开发** | **BE** | API 开发、MyBatis-Plus 数据访问层、业务逻辑、数据库同步 | `navatation-admin/` |
| **前端开发** | **FE** | React 页面组件实现、样式与交互、网络请求 | `navatation-web/` |
| **测试工程师** | **QA** | 自动化端对端浏览器测试（非默认交付环节，仅在用户指派时激活） | `browser_subagent` / 浏览器 |
| **用户** | **USER** | 默认的功能手动验证者与交付确认决策人 | 前端界面 / 浏览器 |

---

## 2. 工作流核心步骤

当接收到用户提出的需求时，工作流按下述步骤严格执行：

### 阶段一：需求分析与方案设计（PM 主导，编码前）
1. **查阅进度**：查阅 [WORKFLOW-STATUS.md](file:///e:/workspace/navatation/doc/WORKFLOW-STATUS.md) 了解项目进度。
2. **分析需求**：结合 [PRD.md](file:///e:/workspace/navatation/doc/PRD.md) 对齐需求点，确保不遗漏关键功能。
3. **主动澄清**：对细节不明朗或自相矛盾的需求，**必须主动向用户提问澄清（单次提问最多 2 个核心问题）**，杜绝猜测。
4. **设计方案**：贯彻**第一性原理**（深入底层业务逻辑）与**极简改动原则**（用最少代码和最小改动实现功能，避免过度设计）。
5. **拆解任务**：将任务拆解为可独立运行、可测试的 BE/FE 子任务，分析依赖关系。

### 阶段二：并行/串行调度执行（PM 派发子 Agent 编码）
- **无依赖关系任务**：必须同时派发多个子 Agent 并行执行，提升响应速度。
- **有依赖关系任务**：按依赖顺序派发（例如后端接口先开发完成就绪，前端再进行联调开发）。

### 阶段三：服务启动与验证（开发角色执行）
代码变更完成后，各开发角色必须自行启动/重启对应服务，确认就绪后再交付：
- **后端启动**：工作目录 `navatation-admin/navatation-business/`，运行 `mvn spring-boot:run`（确认输出 `Started NavatationApplication`）。
- **前端启动**：工作目录 `navatation-web/`，运行 `npm run dev`（确认输出 localhost 开发访问地址）。
- **提请验证**：前后端服务就绪后，PM **默认直接提请用户进行手动验证**。
- **被动测试**：**仅当用户明确指示时**（如：“让测试测一下登录流程”），PM 才能派发 QA 子 Agent，使用 `browser_subagent` (Playwright) 执行自动化端对端验证。

### 阶段四：文档与看板闭环（PM 监督与执行，编码后）
每次任务结束后，PM 必须确保完成下列文档与规范同步检查：
- **API 变更**：后端开发必须 **100% 同步更新** [api-specification.md](file:///e:/workspace/navatation/doc/api-specification.md)。
- **数据库变更**：后端开发必须 **100% 闭环追加** 变更 SQL 至 [ddl.sql](file:///e:/workspace/navatation/navatation-admin/ddl.sql)。
- **架构与需求变更**：有架构升级更新 [backend-architecture.md](file:///e:/workspace/navatation/doc/backend-architecture.md)，有需求变更更新 [PRD.md](file:///e:/workspace/navatation/doc/PRD.md)。
- **看板更新**：PM 将本次开发细节、状态（开发中/已完成）和版本进度写入 [WORKFLOW-STATUS.md](file:///e:/workspace/navatation/doc/WORKFLOW-STATUS.md)。
- **推送代码**：仅在用户明确发出推送代码或推送 git 指令时，方可调用推送脚本推进代码推送。

---

## 3. 角色切换声明格式

为保持对话上下文清晰，切换角色前必须输出标准声明块（使用 Markdown 引用块）：

```markdown
---
> 🎭 **[角色名称]** | [简述当前任务目标与执行的操作]
---
```

* 示例：
```markdown
---
> 🎭 **项目经理** | 分析需求完成，派发子任务并切换至后端开发
---
```

---

## 4. Bug 处理流程

```
用户手动验证 / QA 报告 Bug
     │
     ▼
输出 Bug 描述 + 复现步骤 + 实际/期望结果
     │
     ▼
PM 研判 Bug 归属（前端/后端/联调）
     │
     ├──▶ 前端 Bug ──────▶ 切换【前端开发】定位并修复
     └──▶ 后端 Bug ──────▶ 切换【后端开发】定位并修复
                            （若涉及联调，后端先修复，前端再接入联调）
     ▼
修复完成并重启服务，PM 再次提请用户手动验证（或依用户指示调度 QA）
     │
     ▼
验证通过 ──────▶ PM 同步所有文档，向用户最终汇报
```
