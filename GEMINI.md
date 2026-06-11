# GEMINI.md - Navatation 项目工作台指南

<PROJECT_OVERVIEW>
欢迎来到 **Navatation** 项目（极简网页浏览器新标签页）。
作为此项目的首席 AI 架构师，你必须将本文件视为项目的“最高宪法（Source of Truth）”。在遵守全局系统指令的前提下，绝对、无条件地遵守以下架构约束与工程标准。
</PROJECT_OVERVIEW>

## 🧱 技术栈与硬性约束 (Hard Rails)
**严禁引入以下范围外的新框架或核心依赖，除非获得明确授权。**

### 前端项目 (`navatation-web/`)
- **基础栈**：React 18 (TypeScript) + Vite。
- **UI & 样式**：Tailwind CSS 4 + shadcn/ui。
  - **[绝对红线]**：**严禁写任何自定义 CSS 或行内样式 (inline styles)**。必须且只能使用 Tailwind 提供的 utility classes，使用 `cn()` 进行样式合并。需要新组件时，优先使用 shadcn/ui 体系，严禁生造冗余轮子。
- **类型安全**：
  - **[绝对红线]**：**绝对不允许使用 `any` 或 `@ts-ignore`**。如果出现类型错误，必须深挖根因、正确定义 interface/type 来解决。

### 后端项目 (`navatation-admin/`)
- **基础栈**：Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis。
- **架构分层红线**：
  - **[绝对红线]**：所有的业务逻辑必须严格封装在 `Service` 层。`Controller` 层仅限用于路由分发和基础参数校验，严禁在 `Controller` 中直接写核心业务代码或越级调用 Mapper。
  - **[绝对红线]**：所有的 API 响应必须统一包装为 `Result<T>` 对象，严禁直接向前端返回裸数据或内部异常栈。

## 📜 严格的 DDD 文档驱动开发 (Doc-Driven)
**代码即文档，文档即代码。** 在进行以下变动时，必须同步更新对应的文档：
- **[PRD]** ([PRD.md](file:///e:/workspace/navatation/doc/PRD.md)): 新功能或业务规则调整前后对齐。
- **[接口协议]** ([api-specification.md](file:///e:/workspace/navatation/doc/api-specification.md)): 任何 Controller 接口、DTO 或响应结构的增改。
- **[数据表]**: 表结构变更追加到 [ddl.sql](file:///e:/workspace/navatation/navatation-admin/ddl.sql)；数据变更追加到 [dml.sql](file:///e:/workspace/navatation/navatation-admin/dml.sql)。
- **[架构设计]** ([backend-architecture.md](file:///e:/workspace/navatation/doc/backend-architecture.md)): 缓存策略、表分区或工程结构变化。
- **[任务看板]** ([WORKFLOW-STATUS-DEV.md](file:///e:/workspace/navatation/doc/WORKFLOW-STATUS-DEV.md)): 重大 BUG 修复和新功能开发进度。常规小优化无需写入。

## 🛠️ 构建、运行与自动化工作流
所有环境操作必须通过 `scripts/` 下的脚本执行，严禁自己探测和瞎写系统启动命令。

### 1. 可视化仪表盘
- **入口**：[dashboard.bat](file:///e:/workspace/navatation/scripts/dashboard.bat) (告知老板双击它来快速管理前后端、Redis及Git推送)

### 2. AI 快捷启动链路规则
当老板让你“启动前后端”时，必须按以下顺序**直接启动后台任务**：
1. **Redis**: `.\start-redis.bat` (Cwd: `e:\workspace\navatation\scripts\service`)
2. **Backend**: `$env:JAVA_HOME = "D:\javaSoftware\jdk\jdk17"; mvn spring-boot:run` (Cwd: `e:\workspace\navatation\navatation-admin\navatation-business`)
3. **Frontend**: `npm run dev` (Cwd: `e:\workspace\navatation\navatation-web`)

### 3. 严格的分支推送工作流 (CRITICAL)
本项目采用 `dev` 与 `main` 双分支模型，你必须严格遵循以下步骤：
- **任务清单约束**：执行复杂计划创建 `task.md` 时，必须将 `[ ] 自动运行 .\push-dev.bat 推送代码` 作为最后一项任务。
- **日常暂存 (`dev` 分支)**：在完成修改且**本地验证无误后、向老板汇报之前**，你**必须**自动运行 [push-dev.bat](file:///e:/workspace/navatation/scripts/git/push-dev.bat) 脚本，严禁在未推送的情况下提前汇报 `walkthrough`。
  - **强制要求**：调用该脚本时必须传入简短且准确的提交描述（例如：`.\push-dev.bat "feat: 增加全局ESC关闭弹窗功能"`），严禁使用默认描述。
- **合并发布 (`main` 分支)**：大特性在 `dev` 验证无误后，获得明确许可后再运行 [merge-to-main.bat](file:///e:/workspace/navatation/scripts/git/merge-to-main.bat) 推送至 `main`。
