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

### 前端启动
1. 进入前端目录: `cd navatation-web`
2. 安装依赖: `npm install`
3. 启动开发服务器: `npm run dev`
4. 访问地址: `http://localhost:5173`

### 后端启动
1. 进入后端业务模块目录: `cd navatation-admin/navatation-business`
2. 运行 Spring Boot 应用: `mvn spring-boot:run`
3. API 访问地址: `http://localhost:8080`
4. Swagger 文档地址: `http://localhost:8080/swagger-ui.html`

## 📂 目录结构

- `navatation-web/`: React 前端应用程序。
- `navatation-admin/`: Maven 多模块后端。
  - `navatation-common/`: 公共工具类和常量模块。
  - `navatation-framework/`: 核心配置模块（Security, JWT, Redis）。
  - `navatation-business/`: 业务逻辑模块，包含 Controller、Service 和 Mapper。
- `doc/`: 完整的项目文档（PRD、API 规范、架构设计等）。
- `.gemini/`: 工作空间特定的规则和多角色工作流配置。

## 🎭 自动化工作流与 Agent 协作

本项目采用 **PM (主 Agent) 驱动 + 子 Agent 协作** 的自动化执行模式，将传统的角色切换优化为任务委派：

### 核心角色与 Agent 映射
- **项目经理 (PM)**: **由主 Agent 承担**。作为唯一入口，负责统筹全局、拆解任务、调度子 Agent，并执行最终的文档同步和质量校验。
- **后端/前端开发 (BE/FE)**: **由 `codebase_investigator` 子 Agent 承担**。主 Agent 通过 `invoke_agent` 委派具体的代码实现任务。
- **批处理/重构任务**: **由 `generalist` 子 Agent 承担**。用于执行跨多个文件的批量修改或耗时较长的操作。
- **测试验证 (QA)**: **由 `browser_subagent` 承担**（用户指派时激活）。

### 自动化协作流程
1.  **需求拆解 (PM)**: 主 Agent 分析 `WORKFLOW-STATUS.md`，制定详细的执行计划。
2.  **任务委派 (PM -> Sub-Agent)**: 
    - 使用 `invoke_agent` 调用 `codebase_investigator`，并在提示词中明确开发环境（`navatation-admin/` 或 `navatation-web/`）及代码标准。
    - 主 Agent 负责并发或顺序管理多个子任务，以压缩会话历史。
3.  **结果集成 (PM)**: 主 Agent 接收子 Agent 的执行报告，确保代码变更符合“卫语句”等核心规范。
4.  **服务启动与验证**:
    - 主 Agent 直接执行 `run_shell_command` 启动前后端服务（BE: 8080, FE: 5173）。
    - 验证通过后，PM 提请用户手动确认。
5.  **收口同步 (PM)**: 更新看板、API 文档及数据库脚本。

### 委派指令规范
委派时必须包含以下上下文：
- **目标目录**: 明确是后端还是前端。
- **参考规范**: 引用 `GEMINI.md` 中的“通用编码准则”。
- **预期产出**: 详细描述需要修改的文件及功能点。

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
请参考 `doc/WORKFLOW-STATUS.md` 获取最新任务看板。目前的开发重点：
1. 待办事项 (Todo List) 模块实现。
2. 拖拽排序功能 (react-dnd)。
3. 主题切换功能 (浅色/深色/系统自适应)。
