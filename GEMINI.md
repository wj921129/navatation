# GEMINI.md - Navatation 项目工作台指南

<PROJECT_OVERVIEW>
欢迎来到 **Navatation** 项目（极简网页浏览器新标签页）。
作为此项目的首席 AI 架构师，你必须将本文件视为项目的"最高宪法（Source of Truth）"。在遵守全局系统指令的前提下，绝对、无条件地遵守以下架构约束与工程标准。

**⚠️ 本项目遵循严密的代码提交与复盘流程。所有工程目录写操作完成后，必须执行 Git 推送与度量复盘收尾闭环，详见 [WORKFLOW.md](file:///E:/workspace/navatation/.agents/rules/WORKFLOW.md)。 ⚠️**
</PROJECT_OVERVIEW>

## ⚡ AI 极速启动与服务管理指南 (Fast Launch Guide)
当老板下达“启动服务”、“启动前后端”或类似指令时，AI 必须遵循以下原则以防启动冲突：
1. **防重检查**：当前项目已配置 agy `SessionStart` 自动生命周期托管，服务在 agy 启动时已由后台自动拉起。AI 应当先核对相关端口或服务状态（如 Redis 6379, 后端 8080, 前端 5173）。若已在运行，直接向老板汇报“服务已自动拉起并就绪”。
2. **手动拉起/重启**：若服务未拉起或老板明确要求手动启动/重启，**必须分别**在后台并行拉起各服务脚本，因为 `start-all.bat` 中的弹窗命令在无头环境中会执行失败且主进程退出会导致子进程死亡：
   - 使用 `run_command` 分发后台任务（Cwd: `.`)：
     1. `scripts\service\start-redis.bat`
     2. `scripts\service\start-be.bat`
     3. `scripts\service\start-fe.bat`


## 📁 项目结构地图
```
navatation/
├── navatation-web/              # 前端 React 项目
│   └── src/
│       ├── app/                 # 应用主体
│       │   ├── components/      # shadcn/ui 组件
│       │   ├── hooks/           # 自定义 Hooks
│       │   ├── services/        # API 调用层 (api-client.ts)
│       │   ├── stores/          # 状态管理
│       │   └── constants/       # 常量定义
│       ├── config/              # 项目配置
│       └── styles/              # 样式资源
├── navatation-admin/            # 后端 Spring Boot 项目
│   ├── navatation-business/     # 业务主模块（Controller/Service/Mapper/Entity/DTO）
│   ├── navatation-common/       # 公共模块（工具类/常量/异常定义）
│   ├── navatation-framework/    # 框架模块（配置/拦截器/安全）
│   ├── ddl.sql                  # 表结构变更记录
│   └── dml.sql                  # 数据变更记录
├── doc/                         # 项目文档
│   ├── PRD.md                   # 产品需求文档
│   ├── api-specification.md     # 接口协议
│   ├── backend-architecture.md  # 后端架构设计
│   ├── frontend-architecture.md # 前端架构设计
│   ├── WORKFLOW-STATUS-DEV.md   # 开发任务看板
│   ├── USER-GUIDE.md            # 用户手册 & 版本更新日志
│   ├── rsa-login-encryption-design.md  # RSA 加密设计
│   ├── favicon-local-storage-design.md  # favicon本地化存储设计
│   ├── plans/                   # 各项功能的实现计划
│   └── specs/                   # 各项功能的设计方案
├── scripts/                     # 自动化脚本
│   ├── dashboard.bat            # 可视化管理仪表盘
│   ├── git/                     # Git 推送/合并脚本
│   ├── service/                 # 服务启停脚本
│   ├── metrics/                 # AI 度量分析脚本
│   └── tools/                   # 辅助工具（包含 start-codegraph.bat 项目结构索引）
├── .agents/                     # AI 助手配置与规范
│   ├── rules/                   # 项目级规则规范
│   │   ├── WORKFLOW.md          # 工作流与 Pipeline 规范
│   │   └── CODING-STANDARDS.md  # 核心编码与安全规范
├── GEMINI.md                   # 项目总入口（最高宪法）
```

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
| **工作流规范** | [WORKFLOW.md](file:///E:/workspace/navatation/.agents/rules/WORKFLOW.md) | DDD 文档驱动、构建运行、分支推送、Git 推送与度量复盘收尾、agy CLI 配置 |
| **编码规范** | [CODING-STANDARDS.md](file:///E:/workspace/navatation/.agents/rules/CODING-STANDARDS.md) | 通用编码红线、前端规范、后端规范、安全红线、错误处理与测试 |

> **⚠️ 重要提示**：上述两个子规范文件是本宪法的有机组成部分，具有与本文件相同的最高约束力。违反子规范等同于违反本文件。

## 🛠️ 代码检索红线 (Codegraph Indexing)
> **⚠️ 核心探索约束**：在定位代码、理解架构或查找上下文时，只要项目存在 `.codegraph/` 目录，**必须优先调用 `codegraph` 系列 MCP 工具**（如 `codegraph_explore` 或其对应的 CLI），严禁在初期大量使用 `grep` 或盲目跨文件读取以节省 Token 开销。

*注：在 agy 环境下该服务已被自动托管拉起。非托管环境或需重新初始化时，请运行 `scripts/tools/` 目录下的相关脚本。详细调用参数请直接查阅 MCP 工具定义。*


