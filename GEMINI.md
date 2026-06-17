# GEMINI.md - Navatation 项目工作台指南

<PROJECT_OVERVIEW>
欢迎来到 **Navatation** 项目（极简网页浏览器新标签页）。
作为此项目的首席 AI 架构师，你必须将本文件视为项目的"最高宪法（Source of Truth）"。在遵守全局系统指令的前提下，绝对、无条件地遵守以下架构约束与工程标准。

**⚠️ 本项目遵循严密的代码提交与复盘流程。所有工程目录写操作完成后，必须执行 Git 推送与度量复盘收尾闭环，详见 [WORKFLOW.md](file:///E:/workspace/navatation/.agents/rules/WORKFLOW.md)。 ⚠️**
</PROJECT_OVERVIEW>

## ⚡ AI 极速启动服务指令 (Fast Launch Guide)
当老板下达“启动前后端”、“启动服务”或类似指令时，AI **必须在 0 文件检索的前提下**立即、直接依次执行以下后台异步命令（Cwd 路径为项目根目录的相对路径）：
1. **Redis**:
   - **相对路径 (Cwd)**: `scripts/service`
   - **Command**: `.\start-redis.bat`
2. **Backend**:
   - **相对路径 (Cwd)**: `navatation-admin/navatation-business`
   - **Command**: `$env:JAVA_HOME = "D:\javaSoftware\jdk\jdk17"; mvn spring-boot:run`
3. **Frontend**:
   - **相对路径 (Cwd)**: `navatation-web`
   - **Command**: `npm run dev`
*(此备忘录优先级最高，用于避免读取子规范文件或脚本内容以缩短启动前置开销)*

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
│   └── rsa-login-encryption-design.md  # RSA 加密设计
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

## 🛠️ AI 提速与项目结构索引 (Codegraph Indexing)
为了降低 AI 交互的 Token 消耗并大幅提升大型重构与代码查询的效率，本项目集成了 **codegraph** 智能图谱分析。
- **初始化脚本**：运行 [init-codegraph.bat](file:///C:/workspace/my-workspace/navatation/scripts/tools/init-codegraph.bat) 脚本进行项目的 AST 索引定制化配置。
- **启动脚本**：运行 [start-codegraph.bat](file:///C:/workspace/my-workspace/navatation/scripts/tools/start-codegraph.bat) 脚本即可。
- **配置与机制**：项目在全局 MCP (`mcp_config.json`) 中注册了 codegraph。它基于 Tree-sitter 在本地为 `navatation-web` 与 `navatation-admin` 构建 AST 知识图谱，使 AI 助手能通过 Model Context Protocol (MCP) 实时、按需查询符号依赖（如 callers/callees/定义），无需频繁读取源文件，极大节省 Token 开销。


