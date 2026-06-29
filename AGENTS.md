# AGENTS.md - Navatation 项目工作台指南

<PROJECT_OVERVIEW>
欢迎来到 **Navatation** 项目（极简网页浏览器新标签页）。
作为此项目的首席 AI 架构师，你必须将本文件视为项目的"最高宪法（Source of Truth）"。在遵守全局系统指令的前提下，绝对、无条件地遵守以下架构约束与工程标准。

**⚠️ 任务收尾流程：所有工程目录写操作完成后，必须调用 `custom-finish-development-task` 技能执行收尾闭环。 ⚠️**
</PROJECT_OVERVIEW>

## 🤖 AI 核心操作行为红线 (AI Behavioral Constraints)
1. **Superpowers 强制前置**：在执行任何修改代码的任务前，**必须先调用**相关 Superpowers 技能（如 `systematic-debugging`、`using-superpowers` 等）。此步骤不可跳过，严禁凭直觉直接写代码。
2. **后台定时器规范**：在使用 `schedule` 等工具设置后台定时器的取消条件（TimerCondition）时，**必须使用包含完整 UUID 的全局 Task ID**（例如 `7b7f79f6-.../task-X`），严禁使用缩写，以确保任务能够被系统精确回收。

## ⚡ AI 极速启动与服务管理指南 (Fast Launch Guide)
当老板下达“启动服务”、“启动前后端”或类似指令时，AI 必须遵循以下原则以防启动冲突：
1. **防重检查**：当前项目已配置 agy `SessionStart` 自动生命周期托管，服务在 agy 启动时已由后台自动拉起。若已在运行，直接向老板汇报“服务已自动拉起并就绪”。
2. **手动拉起/重启**：若服务未拉起或老板要求手动启动/重启，**必须调用 `custom-launch-services` 技能**来安全、可靠地在后台拉起所有服务，严禁手动猜测或自行分发脚本。



## 🧱 技术栈清单 (Tech Stack)
**严禁引入以下范围外的新框架或核心依赖，除非获得明确授权。**

| 层 | 技术栈 |
|:---|:---|
| **前端** | React 18 (TypeScript) + Vite + Tailwind CSS 4 + shadcn/ui |
| **后端** | Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis |

## 📚 子规范索引

本文件已拆分为以下子规范，**每个子规范与本文件具有同等约束力**，AI 助手必须在执行任务前完整阅读并遵守：

| 子规范 | 文件 | 核心内容 |
|:---|:---|:---|
| **工作流规范** | [WORKFLOW.md](.agents/rules/WORKFLOW.md) | DDD 文档驱动、构建运行、分支推送、任务收尾 |
| **编码规范** | [CODING-STANDARDS.md](.agents/rules/CODING-STANDARDS.md) | 通用编码红线、前端规范、后端规范、安全红线、错误处理与测试 |
| **调试指南** | [DEBUGGING-GUIDE.md](.agents/rules/DEBUGGING-GUIDE.md) | 构建紧密的调试反馈循环、排查 Hard Bugs 的 10 种方式 |
| **环境配置** | [ENVIRONMENTS.md](.agents/rules/ENVIRONMENTS.md) | dev/prd 双环境配置对照表与行为准则 |
| **项目结构** | [PROJECT-STRUCTURE.md](.agents/rules/PROJECT-STRUCTURE.md) | 完整目录树与模块说明 |

> **⚠️ 重要提示**：上述子规范文件是本宪法的有机组成部分，具有与本文件相同的最高约束力。违反子规范等同于违反本文件。



## 🛠️ 代码检索红线 (Codebase Memory Indexing)
> **⚠️ 核心探索约束**：在定位代码、理解架构或查找上下文时，**必须首先调用** `codebase-memory` 系列 MCP 工具（如 `search_graph`、`trace_call_path`、`get_architecture`、`search_code` 等）。**只有当** codebase-memory 返回结果不足以定位目标时，才允许降级使用 `grep` 或跨文件读取。

*注：`codebase-memory-mcp` 为静态二进制程序，已在 MCP 配置中注册，agy 会话启动时自动拉起。项目索引通过后台 watcher 自动增量维护，无需手动干预。首次安装或重建索引请运行 `scripts/tools/install-codebase-memory.bat`。*

