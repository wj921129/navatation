# GEMINI.md - Navatation 项目工作台指南

<PROJECT_OVERVIEW>
欢迎来到 **Navatation** 项目（极简网页浏览器新标签页）。
作为此项目的首席 AI 架构师，你必须将本文件视为项目的"最高宪法（Source of Truth）"。在遵守全局系统指令的前提下，绝对、无条件地遵守以下架构约束与工程标准。

**⚠️ 本项目遵循用户级 Pipeline（PHASE 0-4）+ 项目级 PHASE 5 的完整对话工作流引擎。所有工程目录写操作完成后，必须执行 PHASE 5 Git 推送闭环，详见本文件末尾。 ⚠️**
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
└── .agents/base_rule.md         # 编码规范（唯一权威）
```

## 🧱 技术栈清单 (Tech Stack)
**严禁引入以下范围外的新框架或核心依赖，除非获得明确授权。**

| 层 | 技术栈 |
|:---|:---|
| **前端** | React 18 (TypeScript) + Vite + Tailwind CSS 4 + shadcn/ui |
| **后端** | Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis |

> 编码红线与约束详见 [base_rule.md](file:///c:/workspace/my-workspace/navatation/.agents/base_rule.md)

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

## 📊 PHASE 5: Git 推送 + METRICS 复盘 (Pipeline 收尾)

> **Pipeline 衔接**：此为用户级 Pipeline（PHASE 0-4）的项目级收尾阶段。当 PHASE 4 验证通过后，必须立即进入本阶段。

### 5.1 Git 推送闭环
**⚠️ 【最高行为红线】 ⚠️**
只要对工程目录下的任何文件进行了写操作，**向老板开口汇报前的最后一项动作**，必须且只能是运行 `.\push-dev.bat "描述"` 脚本进行推送。绝对严禁在本地存在未提交更改时向老板汇报完成。

### 5.2 METRICS 复盘输出
**⚠️ 【CRITICAL 强制输出红线】 ⚠️**
在**每一次对话、任务或修复的最后一次文字汇报中**，必须且只能在回复消息体的**最末尾**附带一个标准的 `[METRICS]` 统计模块。此为强制规则，**不论任务大小皆不可省略**！

你需要从自身的上下文记忆中提取并按以下格式原样输出清单：
1. **Plugins / MCP & Skills**：明确列出本次对话中调用的外部插件、MCP 服务名或特定规范库。
2. **原生 Tools**：使用了哪些关键底层工具（如 `run_command`, `replace_file_content` 等）。
3. **Subagents**：如果派发了后台子智能体，请简述。若无则填"未派发"。

*注：此约束旨在保证 AI 操作的 100% 透明度。为了辅助度量，老板可随时运行 `scripts/metrics/analyze-ai-metrics.ps1` 进行 JSONL 日志深层扫除统计。*
