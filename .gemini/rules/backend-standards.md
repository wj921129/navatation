# 后端开发规范 (Backend Development Standards)

本项目后端采用 Java 17 + Spring Boot 3.3.5 开发，所有后端相关代码编写与修改必须无条件遵守以下规范。

## 1. 基础约束
- **JDK 版本**：JDK 17
- **字符编码**：UTF-8 无 BOM
- **语言规范**：代码注释、异常描述、设计思路强制使用**中文**。

## 2. 编码风格与设计
- **逻辑控制**：强制使用 **卫语句 (Guard Clauses)** 提前返回，消除嵌套的 `if-else`，减少代码嵌套深度。
- **嵌套层级**：`if`/`for`/`while` 的嵌套层级最大不能超过 **3 层**，超出必须拆分为子方法。
- **类依赖**：禁止使用通配符导入（如 `import java.util.*;`），且必须删除所有未使用的 `import`。
- **条件语句**：单条语句的条件控制也必须使用 `{}` 括起，禁止省略大括号。
- **资源关闭**：所有的流（Stream）、连接（Connection）等资源必须使用 `try-with-resources` 自动关闭。
- **判空处理**：对字符串和集合的非空判断，必须使用 `StringUtils.isNotBlank()`/`StringUtils.isBlank()` 和 `CollectionUtils.isNotEmpty()`/`CollectionUtils.isEmpty()`，禁止 ad-hoc 的手动逻辑拼接。

## 3. 注释规范
- **类头注释**：每个新建的 Java 类头部必须加上精确、简洁的功能描述及作者、日期等元数据注释。
- **方法注释**：
  - 非 Controller 的 `public` 方法和静态方法：必须使用标准 Javadoc 注释，包含 `@param` 和 `@return` 等说明。
  - `private` 方法：使用 Javadoc 块注释，但不强制要求参数描述。
  - 接口（Interface）及其实现类（Impl）的方法：必须在接口方法上加上详尽的 Javadoc 注释。
- **行内注释**：关键业务逻辑和复杂分支控制处，必须辅以精准、简洁的行内注释。
- **特别要求**：所有注释描述应精炼直击核心，**禁止使用数字（如 1.、①）编号**。

## 4. 日志规范
- **日志框架**：统一使用 `LoggerFactory.getLogger` 创建 Logger。
- **日志级别**：只允许记录 `ERROR`（系统异常）和 `INFO`（关键业务节点/流程状态），**禁止使用** debug、warn 等其他日志级别。
- **格式化**：日志输出时必须使用 `{}` 占位符进行参数绑定，**严禁使用字符串拼接**。
- **异常捕获**：在 `catch` 块中必须记录 ERROR 日志或向上抛出，**绝对禁止空 catch 块**。

## 5. 安全红线与 SQL 规范
- **防止 SQL 注入**：MyBatis XML/Annotation 中必须使用 `#{}` 进行占位绑定，**严禁使用 `${}` 拼接**用户输入。
- **数据库查询**：**禁止在循环（for/while）内执行 DB 查询或远程 HTTP 接口调用**。必须提前将所需数据批量查出并缓存在内存（Map）中进行组装。
- **安全检查**：对外部传入的敏感参数（如用户 ID、组织 ID 等）进行权限校验，防止越权。
- **用户登录安全**：若涉及用户注册、登录密码传输、RSA 密钥对生成或传输数据加密解密逻辑，必须无条件参考并严格遵循专项安全设计规范 [rsa-login-encryption-design.md](file:///e:/workspace/navatation/doc/rsa-login-encryption-design.md)。

## 6. 数据库 (DDL) 变更规范
- **任何数据库表结构变更，必须同步更新 [ddl.sql](file:///e:/workspace/navatation/navatation-admin/ddl.sql)。**
- **同步场景**：新建表、新增/修改/删除字段、新增/修改索引、修改字段约束等。
- **更新规则**：
  - 在 [ddl.sql](file:///e:/workspace/navatation/navatation-admin/ddl.sql) 文件末尾追加变更 SQL，用注释标注变更日期和功能用途。
  - 若修改已有表，追加 `ALTER TABLE` 语句，不要直接修改已有的 `CREATE TABLE`。
  - 确保 SQL 可重复执行（使用 `IF NOT EXISTS` / `IF EXISTS` 等逻辑）。

## 7. API 接口设计与文档同步
- **RESTful 设计**：严格遵循 RESTful 风格使用 `GET/POST/PUT/DELETE`。
- **响应体格式**：采用统一的响应包装器 `Result`，格式必须为：`{ "code": 200, "message": "success", "data": {} }`
- **文档同步**：任何 API 的新增、修改或废弃，必须 **100% 同步更新至 [api-specification.md](file:///e:/workspace/navatation/doc/api-specification.md)**，确保接口定义与实现完全一致。
