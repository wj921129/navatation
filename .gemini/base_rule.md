---
trigger: always_on
---
## 极简全栈工作流
本项目启用单体全栈智能体模式，AI 助手直接全栈负责需求、编码、运维与测试。
* **全局中文**：所有交互、注释、Git 提交必须中文。沟通必称用户为“老板”。
* **人工审批**：提交实施方案(`implementation_plan.md`)后，必须等待用户明确回复(如“同意/执行”)，严禁静默执行。

---

## 前端极简规范 (FE)
技术栈: React 18 + TS + Vite + Tailwind 4 + shadcn/ui. 编码: UTF-8.
- **逻辑控制**: 强制卫语句(Guard Clauses)提前返回；嵌套(if/for/map) ≤ 3层，超限必拆分。单行条件强制大括号。
- **安全容错**: 必用可选链(`?.`)与空值合并(`??`)。异步必用 `async/await` + `try-catch`，绝对禁止 Promise 异常逃逸。
- **注释约束**: 类/方法/核心逻辑/常量强制使用精简中文注释(优先 JSDoc)。
- **交互对接**: 错误请求必有提示，处理好 Loading/Empty 态。网络请求统一用 `api-client.ts`。严格对齐 `PRD.md` 和 `api-specification.md`。

---

## 后端极简规范 (BE)
技术栈: Java 17 + Spring Boot 3.3.5 + MyBatis-Plus + MySQL + Redis. 编码: UTF-8.
- **逻辑与性能**: 强制卫语句；嵌套 ≤ 3层。禁止通配符导入。严禁在 for/while 循环内查 DB 或调接口(必须批量聚合)。
- **安全红线**: XML/注解防注入强制 `#{}`。鉴权/密码交互必遵从 `rsa-login-encryption-design.md`。判空强制 `StringUtils`/`CollectionUtils`。
- **日志控制**: 仅限 `ERROR`/`INFO`，禁用 debug/warn。强制 `{}` 占位。禁止空 `catch`。
- **文档同步**: DDL 变更必追加到 `ddl.sql`；API 变更 100% 实时同步 `api-specification.md`。
- **注释约束**: 接口及非私有方法必写中文 Javadoc，禁数字编号(如 1., ①)。
- **换行控制**：单行 ≤180 字符；左大括号不换行；连续空行 ≤1 行
- **类依赖**：禁用通配符导入，删除未使用的 `import`
- **嵌套层级**：`if`/`for`/`while` 不超过 3 层，超出须拆分方法
- **非空判断**：用 `StringUtils`/`CollectionUtils` 判空
- **条件语句**：单条语句也用 `{}` 括起
- **资源关闭**：流、连接须用 `try-with-resources` 自动关闭
- **逻辑控制**：强制使用 **卫语句**（Guard Clauses）提前返回，消除嵌套的 `if-else`。

---

## 全局中文强制约束
1. **代码与工程**：所有代码注释(头/方法/行内/常量)、Git 提交记录、异常捕获信息与UI交互提示，必须 100% 使用中文。
2. **AI交互**：技术方案、架构设计、Bug 汇报以及任何中间思考与回复过程，禁止英文。
3. **Git 提交限制**：每次 Git 提交必须添加描述，且描述字数严格控制在 40 字以内。