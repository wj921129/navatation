# GEMINI.md - 项目指导文件

欢迎来到 **Navatation** 项目（极简网页浏览器新标签页）。本文件为在此代码库中工作的 AI Agent 提供基础上下文和指令。

## 🚀 项目概述

**Navatation** 是一款追求极简、高效的浏览器新标签页应用。它作为一个可定制的起始页，集成了核心搜索框、常用网址快捷方式、个性化设置以及待办事项功能。

### 核心技术栈

- **前端 (`navatation-web/`)**:
  - **框架**: React 18 (TypeScript)
  - **构建工具**: Vite
  - **样式**: Tailwind CSS 4, shadcn/ui, Radix UI
  - **动画**: Framer Motion (motion)
  - **状态管理**: 自定义轻量级 Store (`auth-store.ts`)
  - **图标**: Lucide React

- **后端 (`navatation-admin/`)**:
  - **语言**: Java 17
  - **框架**: Spring Boot 3.3.5
  - **ORM**: MyBatis-Plus
  - **安全**: JWT (jjwt), BCrypt
  - **数据库**: MySQL, Redis
  - **文档**: SpringDoc OpenAPI (Swagger)

## 🛠️ 构建与运行

### 🚀 Windows 一键启动与停止（免去环境变量探查，分类存放）
项目脚本已在 `scripts/` 目录下按功能分类整理为 **启动服务相关 (`scripts/service/`)** 与 **Git 版本管理相关 (`scripts/git/`)**：

#### 1. 启动与停止服务相关 (`scripts/service/`)
为解决 Windows 环境兼容性，已提供写死 JDK 路径的批处理脚本：
- **开启后端服务 (写死 JAVA_HOME)**：`scripts/service/start-be.bat`
- **关闭后端服务**：`scripts/service/stop-be.bat`
- **开启前端服务**：`scripts/service/start-fe.bat`
- **关闭前端服务**：`scripts/service/stop-fe.bat`
- **开启 Redis 缓存 (启动目录 D:\javaSoftware\Redis)**：`scripts/service/start-redis.bat`
- **关闭 Redis 缓存**：`scripts/service/stop-redis.bat`

对于 AI 助手：当收到“启动前后端”指令时，**禁止探查环境变量**，直接在 `navatation-admin/navatation-business` 目录运行写死的后端命令：`$env:JAVA_HOME = "D:\javaSoftware\jdk\jdk17"; mvn spring-boot:run`；在 `navatation-web` 目录运行 `npm run dev`。

#### 2. Git 版本管理相关 (`scripts/git/`)

### 📦 一键推送所有仓库代码（推送 git）
- **脚本位置**：[push-all.bat](file:///E:/workspace/navatation/scripts/git/push-all.bat)
- **运行命令**：在主仓库根目录下，AI 可直接建议或执行：`scripts\git\push-all.bat "您的提交信息"`（不带参数则提示手动输入）
- **触发规范**：**切勿主动执行**。只有当用户明确发出 **“推送git”** 或 **“推送代码”** 时，AI 方可执行。

### 🌿 开发分支与提交规范（Git dev/main 双分支工作流）
- **dev 开发分支规范**：
  - 项目所有子仓库均基于 `dev` 分支进行日常开发与增量提交。
  - 以后每次对话修改完代码，AI 均必须**自动执行** `scripts\git\push-dev.bat "本次修改的注释"` 将前端、后端、主仓的所有更改一键提交并推送至各自远端的 `dev` 分支，以维持开发状态同步。
  - 自动开发提交脚本：[push-dev.bat](file:///E:/workspace/navatation/scripts/git/push-dev.bat)。
- **合并至 main 分支规范**：
  - **合并脚本位置**：[merge-to-main.bat](file:///E:/workspace/navatation/scripts/git/merge-to-main.bat)。
  - **触发条件**：日常小修改直接推送到 `dev` 分支。**当对一个功能有大规模改动或者新增了新功能时**，AI 必须在对话最后**主动提示用户**本次改动范围较大，询问是否合并到 `main` 分支。
  - **执行流**：在获得用户**明确同意/确认**之后，AI 方可执行 `scripts\git\merge-to-main.bat` 脚本将三仓 `dev` 代码合并至 `main` 分支并完成远端推送。


- **前端访问地址**：`http://localhost:5173`
- **后端访问地址**：`http://localhost:8080` | Swagger: `http://localhost:8080/swagger-ui.html`

## 📂 目录结构

- `navatation-web/`: React 前端应用程序。
- `navatation-admin/`: Maven 多模块后端。
  - `navatation-common/`: 公共工具类和常量模块。
  - `navatation-framework/`: 核心配置模块（Security, JWT, Redis）。
  - `navatation-business/`: 业务逻辑模块，包含 Controller、Service 和 Mapper。
- `doc/`: 完整的项目文档（PRD、API 规范、架构设计等）。
- `.gemini/`: 工作空间特定的规则和多角色工作流配置。

## 🎭 自动化工作流

本项目采用主 Agent 驱动模式，主 Agent 作为 PM 统筹全局、拆解任务、编写代码，并执行最终的文档同步和质量校验：
1. **需求拆解**：分析 [WORKFLOW-STATUS.md](file:///E:/workspace/navatation/doc/WORKFLOW-STATUS.md) 制定计划，并通知用户。
2. **代码实现与服务验证**：按需启动前后端服务进行验证，并通过后提请用户手动确认。
3. **收口同步**：在任务结束后，必须同步更新看板、API 文档以及数据库脚本。

## 📜 开发规范

### 通用编码准则
- **语言**: 所有沟通、计划和注释**必须使用中文**。
- **逻辑控制**: 强制使用 **卫语句 (Guard Clauses)** 提前返回，以减少嵌套深度。
- **Java 规范**: 
  - 使用 JDK 17, UTF-8 编码。
  - 禁止通配符导入。
  - 嵌套层级最大为 3 层。
  - 使用 `StringUtils`/`CollectionUtils` 进行非空判断。
- **前端规范**:
  - 嵌套层级最大为 3 层（超出须拆分为子组件）。
  - 推荐使用可选链 (`?.`) 和空值合并运算符 (`??`)。
  - 异步操作使用 `async/await` 配合 `try-catch`。

### 文档同步
- **API 变更**: 必须 100% 同步更新至 `doc/api-specification.md`。
- **数据库变更**: 必须同步更新至 `navatation-admin/ddl.sql`。
- **任务追踪**: PM 在每次任务结束后必须更新 `doc/WORKFLOW-STATUS.md`。

## 🎯 当前焦点
请参考 [WORKFLOW-STATUS.md](file:///E:/workspace/navatation/doc/WORKFLOW-STATUS.md) 获取最新任务看板。目前的开发迭代工作已全部完成，后续修改和代码推送请遵循相关规范。
