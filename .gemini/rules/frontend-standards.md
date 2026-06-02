# 前端开发规范 (Frontend Development Standards)

本项目前端采用 React 18 + TypeScript + Vite + Tailwind CSS 4 开发，所有前端相关代码编写与修改必须无条件遵守以下规范。

## 1. 基础约束
- **技术栈**：以 [package.json](file:///e:/workspace/navatation/navatation-web/package.json) 中的现有技术栈为准（React 18, Vite, Tailwind CSS 4）。
- **字符编码**：UTF-8 无 BOM
- **语言规范**：代码注释、交互提示、设计思路强制使用**中文**。

## 2. 编码风格与设计
- **逻辑控制**：强制使用 **卫语句 (Guard Clauses)** 提前返回，消除嵌套的 `if-else`，减少代码嵌套深度。
- **嵌套层级**：组件、函数及 JSX 逻辑中的 `if`/`for`/`while`/`map` 嵌套层级最大不能超过 **3 层**，超出必须拆分为子函数或独立的子组件。
- **依赖导入**：删除未使用的 `import`，确保导入列表精简整洁。
- **条件语句**：单条语句 of 条件控制也必须使用 `{}` 括起，禁止省略大括号（JSX 中的内联渲染条件判断除外）。
- **安全访问**：推荐使用可选链（Optional Chaining `?.`）与空值合并运算符（Nullish Coalescing `??`）进行安全的属性访问与容错处理。
- **组件设计**：坚持职责单一原则，每个组件只聚焦于一件事情。

## 3. 注释规范
- **方法与函数注释**：在每个方法或函数（包括 React 组件、自定义 Hook、核心 API 请求函数、辅助工具类等）上方，必须加上精准、简洁的功能描述注释（建议使用 JSDoc/TSDoc 风格 `/** ... */`）。
- **内部关键操作注释**：在方法或函数内部的关键操作（如核心 API 调用、复杂计算、状态更新、复杂分支判断、副作用 Effect 逻辑等）处，必须加上精准、简洁的行内中文注释。
- **常量注释**：所有 `const` 常量（包括配置常量、枚举值、魔法数字等）必须在其上方或行内加上简洁的中文描述注释，说明该常量的用途与取值含义。
- **注释要求**：所有注释必须**精准、简洁**，直击核心逻辑，避免冗长废话。

## 4. 异步操作与错误处理
- **异步处理**：所有的异步操作（网络请求等）必须使用 `async/await` 配合 `try-catch` 捕获异常，**绝对禁止直接让 Promise 错误逃逸**。
- **网络请求客户端**：统一使用项目封装好的 HTTP 客户端（如支持自动刷新 Token 的 [api-client.ts](file:///e:/workspace/navatation/navatation-web/src/app/services/api-client.ts)），遵循 [api-specification.md](file:///e:/workspace/navatation/doc/api-specification.md) 约定的接口报文进行调用。
- **友好交互**：当网络请求失败或业务处理出错时，必须给用户展示友好的错误提示，并妥善处理加载中状态（Loading）和空数据状态（Empty）。

## 5. UI 与样式规范
- **样式方案**：遵循项目既定的样式规范。Vanilla CSS 优先，使用 Tailwind CSS 4 作为辅助（除非有特殊要求）。
- **兼容性**：确保组件在最新版的 Chrome、Edge、Firefox 浏览器中均能完美兼容呈现。
- **响应式**：页面布局应实现响应式设计，优先实现桌面端（Desktop），移动端（Mobile）按 PRD 中的规定 and 优先级处理。

## 6. 需求对照与测试
- **需求核对**：承接任务时，首先查找 [PRD.md](file:///e:/workspace/navatation/doc/PRD.md) 中对应的功能需求编号（如 NAV-01、SE-02），严格按照需求描述实现，绝不过度实现（除非 PM 明确要求）。
- **自检清单**：组件交付前必须执行基础功能自检，包括输入验证、临界情况测试、交互流验证等。
