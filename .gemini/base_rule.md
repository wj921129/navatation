---
trigger: always_on
---
# 🏗️ 项目级核心编码规范 (Project Coding Standards)

<PROJECT_CONTEXT>
本文件是 Navatation 项目的**编码规范唯一权威**。所有编码约束、红线与模式示例均集中在此。
*(注：项目导航及工作流参见根目录 `GEMINI.md`；全局 AI 行为约束参见 `~/.gemini/GEMINI.md`)*
</PROJECT_CONTEXT>

## 1. ⚔️ 编码通用红线 (Common Strict Rules)
- **模块化控制**：单个文件业务代码禁止超过 500 行，若超限必须强制拆分。新建文件必须依据业务边界放置于正确的包结构或目录树下。
- **精简控制流 (CRITICAL)**：强制使用卫语句 (Guard Clauses) 提前 `return`，坚决消除嵌套的 `if-else`。任何控制流嵌套（如 `if`/`for`/`while`/`map`）**严禁超过 3 层**！控制语句无论是否只有单行代码，必须强制使用大括号 `{}` 括起。
- **命名纪律**：类/组件使用大驼峰 (`PascalCase`)，方法/变量使用小驼峰 (`camelCase`)，常量强制使用大写蛇形 (`UPPER_SNAKE_CASE`)。后端数据对象必须携带严格的功能后缀（`DTO`, `VO`, `Entity` 等）。
- **消灭魔法值**：代码中绝对不允许出现魔法数字或莫名其妙的魔法字符串。所有状态标识、配置选项必须抽取为常量类或枚举。

### 💡 示例：卫语句 vs 深层嵌套

✅ **正确**（提前 return，扁平化控制流）
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

❌ **错误**（嵌套超过 3 层，违反卫语句原则）
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

---

## 2. 🖥️ 前端编码规范 (FE Strict Rules)
*(技术栈详见根目录 GEMINI.md)*

### 架构红线
- **[绝对红线]** **严禁写任何自定义 CSS 或行内样式 (inline styles)**。必须且只能使用 Tailwind 提供的 utility classes，使用 `cn()` 进行样式合并。需要新组件时，优先使用 shadcn/ui 体系，严禁生造冗余轮子。
- **[绝对红线]** **绝对不允许使用 `any` 或 `@ts-ignore`**。如果出现类型错误，必须深挖根因、正确定义 interface/type 来解决。

### 防御性编程
- **极度容错**：在处理对象和异步数据时，必须使用可选链 (`?.`) 与空值合并 (`??`)。所有异步调用强制使用 `async/await` 结合 `try-catch`，绝对禁止发生 Promise 未捕获异常导致的崩溃。
- **用户体验闭环**：所有网络请求必须统一通过 `api-client.ts` 封装。所有异常或错误必须被捕获，并转化为对用户友好的 UI 提示（Toast/Message 等），禁止将底层系统异常或代码报错直接暴露给用户。所有异步请求必须包含完善的 Loading 态和 Empty 态处理。

### 前端安全红线
- **(CRITICAL)** 严禁使用 `dangerouslySetInnerHTML`、`eval()` 或 `document.write()`。如需渲染富文本，必须通过 DOMPurify 等库进行消毒。
- **(CRITICAL)** 严禁在前端代码中硬编码 API 密钥、Token 或密码。必须使用 `.env` 环境变量 + `VITE_` 前缀。
- URL 参数和用户输入在拼接进 DOM 或 API 请求前，必须进行转义或验证。

### 💡 示例：组件定义

✅ **正确**（使用 Tailwind + cn + 显式类型）
```tsx
interface UserCardProps {
  user: User;
  onSelect: (id: string) => void;
}

export function UserCard({ user, onSelect }: UserCardProps) {
  return (
    <Card className={cn("p-4 hover:shadow-md transition-shadow")}>
      <CardTitle>{user.name}</CardTitle>
      <Button onClick={() => onSelect(user.id)}>选择</Button>
    </Card>
  );
}
```

❌ **错误**（违反 3 条红线）
```tsx
// ❌ 使用了 any 类型
// ❌ 使用了行内样式
// ❌ 使用了自定义 CSS class
export function UserCard({ user, onSelect }: any) {
  return (
    <div style={{ padding: '16px' }} className="custom-card">
      <span>{user.name}</span>
    </div>
  );
}
```

---

## 3. ⚙️ 后端编码规范 (BE Strict Rules)
*(技术栈详见根目录 GEMINI.md)*

### 架构红线
- **[绝对红线]** 所有的业务逻辑必须严格封装在 `Service` 层。`Controller` 层仅限用于路由分发和基础参数校验，严禁在 `Controller` 中直接写核心业务代码或越级调用 Mapper。
- **[绝对红线]** 所有的 API 响应必须统一包装为 `Result<T>` 对象，严禁直接向前端返回裸数据或内部异常栈。

### 性能红线
- **数据库红线 (CRITICAL)**：**绝对禁止**在 `for`/`while` 循环内部执行 SQL 查询或调用外部网络接口。所有的关联或批量数据必须在循环外使用 `IN` 语句等形式一次性查出，并在内存中进行分组和组装。

### 安全红线
- **SQL 注入防护**：所有 MyBatis 的 XML 语句或注解参数必须使用 `#{}`，严防 SQL 注入。
- **密码安全**：所有密码传输必须遵从 `rsa-login-encryption-design.md`。
- **非空判定**：任何非空判定必须使用通用工具类（如 `StringUtils.isNotBlank`, `CollectionUtils.isNotEmpty` 等），避免手写漏洞。

### 日志规范
- 仅允许打印 `ERROR` 和 `INFO` 级别日志。必须使用 `{}` 占位符打印日志，坚决禁止使用 `+` 拼接字符串。严禁捕获异常后留下空的 `catch` 块，至少需要打印详细错误并向上抛出。

### 依赖管理
- 禁止使用通配符导入（如 `import java.util.*;`）。业务方法内部禁止直接硬编码全限定类名，必须在文件头部显式 `import`。所有的数据流、连接对象等必须使用 `try-with-resources` 语法进行自动化安全关闭。

### 💡 示例：Controller-Service 分层

✅ **正确**（Controller 仅路由 + 参数校验）
```java
@PostMapping("/users")
public Result<UserVO> createUser(@Valid @RequestBody CreateUserDTO dto) {
    return Result.success(userService.createUser(dto));
}
```

❌ **错误**（Controller 越权写业务逻辑）
```java
// ❌ 在 Controller 中直接写业务逻辑
// ❌ 直接调用 Mapper，越过 Service 层
// ❌ 返回裸数据，未使用 Result<T> 包装
@PostMapping("/users")
public User createUser(@RequestBody Map<String, Object> params) {
    User user = new User();
    user.setName((String) params.get("name"));
    return userMapper.insert(user);
}
```

### 💡 示例：循环内禁止 SQL

✅ **正确**（批量查询 + 内存分组）
```java
List<Long> userIds = orders.stream().map(Order::getUserId).toList();
Map<Long, User> userMap = userService.listByIds(userIds)
    .stream().collect(Collectors.toMap(User::getId, Function.identity()));
orders.forEach(order -> order.setUserName(
    userMap.get(order.getUserId()).getName()));
```

❌ **错误**（N+1 问题）
```java
for (Order order : orders) {
    // ❌ 循环内执行 SQL 查询
    User user = userMapper.selectById(order.getUserId());
    order.setUserName(user.getName());
}
```

---

## 4. 🔒 通用安全红线 (Security Hard Rails)
- **(CRITICAL)** 严禁在代码中硬编码任何密钥、Token、密码。前端使用 `.env` + `VITE_` 前缀，后端使用配置中心或环境变量。
- **敏感操作审批**：涉及删除数据、修改用户权限、操作 `.env` 文件等敏感操作，必须先向老板确认。
- API 接口必须实施认证与授权校验，严禁裸露无鉴权端点。

---

## 5. ⚠️ 错误处理架构 (Error Handling Architecture)
- **前端**：网络请求统一通过 `api-client.ts` 的响应拦截器处理。业务错误（后端返回 code != 200）使用 `toast.error(msg)` 展示，非业务异常（网络超时等）使用通用兜底提示。
- **后端**：使用全局异常处理器 `@RestControllerAdvice`。业务异常使用自定义 `BusinessException(code, msg)`，所有异常最终包装为 `Result<T>` 返回。严禁使用 `e.printStackTrace()`，必须使用 `log.error("描述", e)` 记录完整堆栈。

---

## 6. 🧪 测试规范 (Testing Standards)
- **前端**：使用 Vitest + React Testing Library。新增核心组件必须附带基础渲染测试。
- **后端**：使用 JUnit 5 + Mockito。Service 层核心方法必须有单元测试覆盖。
- **测试命令**：
  - 前端: `npm run test` (Cwd: `navatation-web/`)
  - 后端: `mvn test` (Cwd: `navatation-admin/`)
- **TDD 流程**：编写核心新功能时，优先编写测试用例，再实现业务代码。