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
└── GEMINI.md                   # 项目大一统规范（最高宪法，包含核心编码规范）
```

## 🧱 技术栈清单 (Tech Stack)
**严禁引入以下范围外的新框架或核心依赖，除非获得明确授权。**

| 层 | 技术栈 |
|:---|:---|
| **前端** | React 18 (TypeScript) + Vite + Tailwind CSS 4 + shadcn/ui |
| **后端** | Spring Boot 3.3.5 + Java 17 + MyBatis-Plus + MySQL + Redis |

> 编码红线与约束详见本文件 [## 🗃️ 核心编码与安全规范](#%F0%9F%9%83%EF%B8%8F-%E6%A0%B8%E5%BF%83%E7%BC%96%E7%A0%81%E4%B8%8E%E5%AE%89%E5%85%A8%E8%A7%84%E8%8C%83-project-coding-standards)

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

---

## 🗃️ 核心编码与安全规范 (Project Coding Standards)

本章节是 Navatation 项目的**编码规范唯一权威定义**。所有开发人员及 AI 助手必须在此标准下工作。

### 1. ⚔️ 编码通用红线 (Common Strict Rules)
- **模块化控制**：单个文件业务代码禁止超过 500 行，若超限必须强制拆分。新建文件必须依据业务边界放置于正确的包结构或目录树下。
- **精简控制流 (CRITICAL)**：强制使用卫语句 (Guard Clauses) 提前 `return`，坚决消除嵌套的 `if-else`。任何控制流嵌套（如 `if`/`for`/`while`/`map`）**严禁超过 3 层**！控制语句无论是否只有单行代码，必须强制使用大括号 `{}` 括起。
- **命名纪律**：类/组件使用大驼峰 (`PascalCase`)，方法/变量使用小驼峰 (`camelCase`)，常量强制使用大写蛇形 (`UPPER_SNAKE_CASE`)。后端数据对象必须携带严格的功能后缀（`DTO`, `VO`, `Entity` 等）。
- **消灭魔法值**：代码中绝对不允许出现魔法数字或莫名其妙的魔法字符串。所有状态标识、配置选项必须抽取为常量类或枚举。

#### 💡 示例：卫语句 vs 深层嵌套
- **正确（提前 return，扁平化控制流）**：
  ```java
  public UserVO getUser(Long id) {
      if (id == null) {
          return null; 
      }
      User user = userMapper.selectById(id);
      if (user == null) {
          throw new BusinessException("用户不存在"); 
      }
      return convertToVO(user);
  }
  ```
- **错误（嵌套超过 3 层，违反卫语句原则）**：
  ```java
  public UserVO getUser(Long id) {
      if (id != null) {
          User user = userMapper.selectById(id);
          if (user != null) {
              if (user.getStatus() == 1) { // ❌ 第 3 层嵌套
                  return convertToVO(user);
              }
          }
      }
      return null;
  }
  ```

### 2. 🖥️ 前端编码规范 (FE Strict Rules)
- **[绝对红线] 严禁写任何自定义 CSS 或行内样式 (inline styles)**。必须且只能使用 Tailwind 提供的 utility classes，使用 `cn()` 进行样式合并。需要新组件时，优先使用 shadcn/ui 体系，严禁生造冗余轮子。
- **[绝对红线] 绝对不允许使用 `any` 或 `@ts-ignore`**。如果出现类型错误，必须深挖根因、正确定义 interface/type 来解决。
- **防御性编程**：
  - **极度容错**：在处理对象和异步数据时，必须使用可选链 (`?.`) 与空值合并 (`??`)。所有异步调用强制使用 `async/await` 结合 `try-catch`，绝对禁止发生 Promise 未捕获异常导致的崩溃。
  - **用户体验闭环**：所有网络请求必须统一通过 `api-client.ts` 封装。所有异常或错误必须被捕获，并转化为对用户友好的 UI 提示（Toast/Message 等），禁止将底层系统异常或代码报错直接暴露给用户。所有异步请求必须包含完善Loading态和Empty态处理。
- **前端安全红线 (CRITICAL)**：
  - 严禁使用 `dangerouslySetInnerHTML`、`eval()` 或 `document.write()`。如需渲染富文本，必须通过 DOMPurify 等库进行消毒。
  - 严禁在前端代码中硬编码 API 密钥、Token 或密码。必须使用 `.env` 环境变量 + `VITE_` 前缀。
  - URL 参数和用户输入在拼接进 DOM 或 API 请求前，必须进行转义或验证。

### 3. ⚙️ 后端编码规范 (BE Strict Rules)
- **架构红线**：
  - **[绝对红线]** 所有的业务逻辑必须严格封装在 `Service` 层。`Controller` 层仅限用于路由分发和基础参数校验，严禁在 `Controller` 中直接写核心业务代码或越级调用 Mapper。
  - **[绝对红线]** 所有的 API 响应必须统一包装为 `Result<T>` 对象，严禁直接向前端返回裸数据或内部异常栈。
- **性能与安全红线 (CRITICAL)**：
  - **数据库红线**：**绝对禁止**在 `for`/`while` 循环内部执行 SQL 查询或调用外部网络接口。所有的关联或批量数据必须在循环外使用 `IN` 语句等形式一次性查出，并在内存中进行分组和组装。
  - **SQL 注入防护**：所有 MyBatis 的 XML 语句或注解参数必须使用 `#{}`，严防 SQL 注入。
  - **密码安全**：所有密码传输必须遵从 `rsa-login-encryption-design.md`。
  - **非空判定**：任何非空判定必须使用通用工具类（如 `StringUtils.isNotBlank`, `CollectionUtils.isNotEmpty` 等），避免手写逻辑产生的漏洞。
- **日志与依赖规范**：
  - 仅允许打印 `ERROR` 和 `INFO` 级别日志。必须使用 `{}` 占位符打印日志，坚决禁止使用 `+` 拼接字符串。严禁捕获异常后留下空的 `catch` 块，至少需要打印详细错误并向上抛出。
  - 禁止使用通配符导入（如 `import java.util.*;`）。业务方法内部禁止直接硬编码全限定类名，必须在文件头部显式 `import`。所有的数据流、连接对象等必须使用 `try-with-resources` 语法进行自动化安全关闭。

### 4. 🔒 通用安全红线 (Security Hard Rails)
- **(CRITICAL)** 严禁在代码中硬编码任何密钥、Token、密码。前端使用 `.env` + `VITE_` 前缀，后端使用配置中心或系统环境变量。
- **敏感操作审批**：涉及删除数据、修改用户权限、操作 `.env` 配置文件等敏感操作，必须先向老板确认。
- **接口安全**：API 接口必须实施认证与授权校验，严禁裸露无鉴权端点。

### 5. ⚠️ 错误处理与测试规范 (Error & Testing)
- **错误处理架构**：
  - **前端**：网络请求统一通过 `api-client.ts` 的响应拦截器处理。业务错误（后端返回 code != 200）使用 `toast.error(msg)` 展示，非业务异常（网络超时等）使用通用兜底提示。
  - **后端**：使用全局异常处理器 `@RestControllerAdvice`。业务异常使用自定义 `BusinessException(code, msg)`，所有异常最终包装为 `Result<T>` 返回。严禁使用 `e.printStackTrace()`，必须使用 `log.error("描述", e)` 记录完整堆栈。
- **测试规范**：
  - 前端：使用 Vitest + React Testing Library。新增核心组件必须附带基础渲染测试。运行命令: `npm run test` (Cwd: `navatation-web/`)。
  - 后端：使用 JUnit 5 + Mockito。Service 层核心方法必须有单元测试覆盖。运行命令: `mvn test` (Cwd: `navatation-admin/`)。
  - **TDD 流程**：编写核心新功能时，优先编写测试用例，再实现业务代码。

---

## 🤖 agy (Antigravity) CLI 特有配置与工作流

为了在 `agy` 环境下获得最流畅的自动化体验，当前项目已完成以下平台级集成：

### 1. 服务生命周期自动管理
项目在 `.agents/settings.json` 中配置了 `SessionStart` 和 `SessionEnd` 钩子，具备以下行为：
- **启动 agy 时**：自动在后台运行 `scripts/start-be.bat` 和 `scripts/start-fe.bat` 以拉起后端 Spring Boot 及前端 React 开发服务器，无需手动启动。
- **关闭 agy 时**：自动触发清理进程，关闭 Redis 及前后端进程，释放系统端口。

### 2. 自动命令执行策略
- **`autoExecutionPolicy`** 设为 `always`（由 `.agents/settings.json` 控制），对安全命令范围内的指令允许自动执行而不频繁打扰用户。
- **允许的安全命令白名单**：`npm`, `npx`, `mvn`, `git`, `cmd.exe`, `powershell.exe`。

### 3. 实时代码评审
在 `agy` 的 TUI 环境下工作时，AI 助手在每次交付代码时，必须首先保证代码的类型安全性与构建正确性，并在开口汇报前完成 `.\push-dev.bat` 的代码同步。
