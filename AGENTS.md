# AGENTS.md - Navatation 项目工作台指南

<PROJECT_OVERVIEW>
欢迎来到 **Navatation** 项目（极简网页浏览器新标签页）。
作为此项目的首席 AI 架构师，你必须将本文件视为项目的"最高宪法（Source of Truth）"与全局指引。本文件主要负责路由各子规范文档，在遵守全局系统指令的前提下，绝对、无条件地遵守以下架构约束与工程标准。

**🚫 检索红线 (Codebase Memory)：禁止盲目 grep 或跨文件读取！任何代码定位与架构探索必须绝对优先调用 `codebase-memory` 系列 MCP 工具！仅当无结果时方可降级！** *(注：MCP索引由后台实时维护)*

**⚠️ 任务收尾流程：所有工程目录写操作完成后，必须调用 `custom-finish-development-task` 技能执行收尾闭环。 ⚠️**
</PROJECT_OVERVIEW>

## 📚 子规范索引 (全局路由)

本文件是全局的指引，已将具体的规范拆分为以下子文档。**每个子规范与本文件具有同等约束力**，AI 助手必须在执行任务前完整阅读并遵守相应的路由文件：

| 子规范 | 文件 | 核心内容 |
|:---|:---|:---|
| **工作流规范** | [WORKFLOW.md](.agents/rules/WORKFLOW.md) | DDD 文档驱动、构建运行、分支推送、任务收尾 |
| **编码规范** | [CODING-STANDARDS.md](.agents/rules/CODING-STANDARDS.md) | 通用编码红线、前端规范、后端规范、安全红线、错误处理与测试 |
| **调试指南** | [DEBUGGING-GUIDE.md](.agents/rules/DEBUGGING-GUIDE.md) | 构建紧密的调试反馈循环、排查 Hard Bugs 的 10 种方式 |
| **环境配置** | [ENVIRONMENTS.md](.agents/rules/ENVIRONMENTS.md) | dev/prd 双环境配置对照表与行为准则 |
| **项目结构** | [PROJECT-STRUCTURE.md](.agents/rules/PROJECT-STRUCTURE.md) | 完整目录树与模块说明 |
| **产品文档** | [PRD.md](doc/PRD.md) | 产品需求、核心功能说明与业务逻辑 |
| **接口文档** | [api-specification.md](doc/api-specification.md) | 后端 API 接口规范、参数说明与状态码 |
| **前端架构** | [frontend-architecture.md](doc/frontend-architecture.md) | 前端技术架构、状态管理与组件设计 |
| **后端架构** | [backend-architecture.md](doc/backend-architecture.md) | 后端系统架构、数据流向与领域模型 |

> **⚠️ 重要提示**：上述子规范文件是本宪法的有机组成部分，具有与本文件相同的最高约束力。违反子规范等同于违反本文件。



## 🧱 技术栈清单 (Tech Stack)
**严禁引入以下范围外的新框架或核心依赖，除非获得明确授权。**

| 层 | 技术栈 |
|:---|:---|
| **前端** | React 18 (TypeScript) + Vite + Tailwind CSS 4 + shadcn/ui |
| **后端** | Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis |

