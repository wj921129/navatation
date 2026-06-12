# GEMINI.md - Navatation 项目工作台指南

<PROJECT_OVERVIEW>
欢迎来到 **Navatation** 项目（极简网页浏览器新标签页）。
作为此项目的首席 AI 架构师，你必须将本文件视为项目的"最高宪法（Source of Truth）"。在遵守全局系统指令的前提下，绝对、无条件地遵守以下架构约束与工程标准。

**⚠️ 【最高行为红线：强制 Git 推送闭环】 ⚠️**
无论是修改了代码、更新了配置，还是仅仅精简了规则文档，**只要你对工程目录下的任何文件进行了写操作，向老板开口汇报前的最后一项动作，必须且只能是运行 `.\push-dev.bat "描述"` 脚本进行推送！绝对严禁在本地存在未提交更改时向老板汇报完成！**
</PROJECT_OVERVIEW>

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
│   └── tools/                   # 辅助工具
└── .gemini/base_rule.md         # 编码规范（唯一权威）
```

## 🧱 技术栈清单 (Tech Stack)
**严禁引入以下范围外的新框架或核心依赖，除非获得明确授权。**

| 层 | 技术栈 |
|:---|:---|
| **前端** | React 18 (TypeScript) + Vite + Tailwind CSS 4 + shadcn/ui |
| **后端** | Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis |

> 编码红线与约束详见 [base_rule.md](file:///c:/workspace/my-workspace/navatation/.gemini/base_rule.md)

## 📜 严格的 DDD 文档驱动开发 (Doc-Driven)
**代码即文档，文档即代码。** 在进行以下变动时，必须同步更新对应的文档：
- **[PRD]** ([PRD.md](file:///c:/workspace/my-workspace/navatation/doc/PRD.md)): 新功能或业务规则调整前后对齐。
- **[接口协议]** ([api-specification.md](file:///c:/workspace/my-workspace/navatation/doc/api-specification.md)): 任何 Controller 接口、DTO 或响应结构的增改。
- **[数据表]**: 表结构变更追加到 [ddl.sql](file:///c:/workspace/my-workspace/navatation/navatation-admin/ddl.sql)；数据变更追加到 [dml.sql](file:///c:/workspace/my-workspace/navatation/navatation-admin/dml.sql)。
- **[架构设计]** ([backend-architecture.md](file:///c:/workspace/my-workspace/navatation/doc/backend-architecture.md)): 缓存策略、表分区或工程结构变化。
- **[任务看板]** ([WORKFLOW-STATUS-DEV.md](file:///c:/workspace/my-workspace/navatation/doc/WORKFLOW-STATUS-DEV.md)): 重大 BUG 修复和新功能开发进度。常规小优化无需写入。

## 🛠️ 构建、运行与自动化工作流
所有环境操作必须通过 `scripts/` 下的脚本执行，严禁自己探测和瞎写系统启动命令。

### 1. 可视化仪表盘
- **入口**：[dashboard.bat](file:///c:/workspace/my-workspace/navatation/scripts/dashboard.bat) (告知老板双击它来快速管理前后端、Redis及Git推送)

### 2. AI 快捷启动链路规则
当老板让你"启动前后端"时，必须按以下顺序**直接启动后台任务**：
1. **Redis**: `.\start-redis.bat` (Cwd: `c:\workspace\my-workspace\navatation\scripts\service`)
2. **Backend**: `$env:JAVA_HOME = "D:\javaSoftware\jdk\jdk17"; mvn spring-boot:run` (Cwd: `c:\workspace\my-workspace\navatation\navatation-admin\navatation-business`)
3. **Frontend**: `npm run dev` (Cwd: `c:\workspace\my-workspace\navatation\navatation-web`)

### 3. 分支推送工作流 (CRITICAL)
本项目采用 `dev` 与 `main` 双分支模型。
- **日常推送 (`dev` 分支)**：完成任何修改且**向老板开口汇报之前**，必须自动调用 [push-dev.bat](file:///c:/workspace/my-workspace/navatation/scripts/git/push-dev.bat) 推送。调用时必须传入简短准确的提交描述（例如：`.\push-dev.bat "feat: 增加全局ESC关闭弹窗功能"`），严禁使用默认描述。执行复杂计划创建 `task.md` 时，必须将 `[ ] 自动运行 .\push-dev.bat 推送代码` 作为最后一项任务。
- **合并发布 (`main` 分支)**：大特性在 `dev` 验证无误后，获得明确许可后再运行 [merge-to-main.bat](file:///c:/workspace/my-workspace/navatation/scripts/git/merge-to-main.bat) 推送至 `main`。

## 📊 任务闭环与复盘统计 (Task Retrospective & Metrics)
**强制要求**：在每一次任务（对话）结束并向老板进行最终汇报时，必须在回复的末尾附带一个 `[METRICS]` 模块。
你需要从自己的上下文记忆中总结本次任务调用过的核心工具：
1. **MCP & Skills**：调用了哪些外部上下文协议（如 `github-mcp`）或特定能力。
2. **原生 Tools**：使用了哪些关键的内置工具（如 `grep_search`, `run_command`, `replace_file_content` 等）。
3. **Subagents**：如果派发了子智能体，简述其类型和工作内容。
这有助于老板直观地了解你的思考路径和工具使用效能。如果是工程级的精准度量，可指导老板运行 `scripts/metrics/analyze-ai-metrics.ps1` 脚本进行本地 JSONL 日志扫描。
