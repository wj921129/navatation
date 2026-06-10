---
trigger: always_on
---
# 🏗️ 项目级核心开发规范 (Project Development Rules)

<PROJECT_CONTEXT>
本项目要求极致的代码整洁度、严格的职责分离以及高可维护性。你作为项目的核心开发者，必须将以下技术红线视为不可逾越的标准。
*(注：全局规范及协作指令参见全局 `GEMINI.md`)*
</PROJECT_CONTEXT>

## 1. ⚔️ 编码通用红线 (Common Strict Rules)
- **模块化控制**：单个文件业务代码禁止超过 500 行，若超限必须强制拆分。新建文件必须依据业务边界放置于正确的包结构或目录树下。
- **精简控制流 (CRITICAL)**：强制使用卫语句 (Guard Clauses) 提前 `return`，坚决消除嵌套的 `if-else`。任何控制流嵌套（如 `if`/`for`/`while`/`map`）**严禁超过 3 层**！控制语句无论是否只有单行代码，必须强制使用大括号 `{}` 括起。
- **命名纪律**：类/组件使用大驼峰 (`PascalCase`)，方法/变量使用小驼峰 (`camelCase`)，常量强制使用大写蛇形 (`UPPER_SNAKE_CASE`)。后端数据对象必须携带严格的功能后缀（`DTO`, `VO`, `Entity` 等）。
- **消灭魔法值**：代码中绝对不允许出现魔法数字或莫名其妙的魔法字符串。所有状态标识、配置选项必须抽取为常量类或枚举。

## 2. 🖥️ 前端防御性编程 (FE Strict Rules)
*技术栈: React 18 + TS + Vite + Tailwind 4 + shadcn/ui*
- **极度容错**：在处理对象和异步数据时，必须使用可选链 (`?.`) 与空值合并 (`??`)。所有异步调用强制使用 `async/await` 结合 `try-catch`，绝对禁止发生 Promise 未捕获异常导致的奔溃。
- **用户体验闭环**：所有网络请求必须统一通过 `api-client.ts` 封装。所有异常或错误必须被捕获，并转化为对用户友好的 UI 提示（Toast/Message 等），禁止将底层系统异常或代码报错直接暴露给用户。所有异步请求必须包含完善的 Loading 态和 Empty 态处理。

## 3. ⚙️ 后端性能与安全 (BE Strict Rules)
*技术栈: Java 17 + Spring Boot 3.3.5 + MyBatis-Plus + MySQL + Redis*
- **数据库红线 (CRITICAL)**：**绝对禁止**在 `for`/`while` 循环内部执行 SQL 查询或调用外部网络接口。所有的关联或批量数据必须在循环外使用 `IN` 语句等形式一次性查出，并在内存中进行分组和组装。
- **安全拦截**：所有 MyBatis 的 XML 语句或注解参数必须使用 `#{}`，严防 SQL 注入。所有密码传输必须遵从 `rsa-login-encryption-design.md`。任何非空判定必须使用通用工具类（如 `StringUtils.isNotBlank`, `CollectionUtils.isNotEmpty` 等），避免手写漏洞。
- **精准日志**：仅允许打印 `ERROR` 和 `INFO` 级别日志。必须使用 `{}` 占位符打印日志，坚决禁止使用 `+` 拼接字符串。严禁捕获异常后留下空的 `catch` 块，至少需要打印详细错误并向上抛出。
- **绝对依赖管理**：禁止使用通配符导入（如 `import java.util.*;`）。业务方法内部禁止直接硬编码全限定类名，必须在文件头部显式 `import`。所有的数据流、连接对象等必须使用 `try-with-resources` 语法进行自动化安全关闭。