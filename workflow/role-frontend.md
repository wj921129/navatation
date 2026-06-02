# 前端开发工程师 (FE) 角色规范

## 1. 工作范围与定位

- **工作目录**：`navatation-web/`
- **职责边界**：负责所有涉及 React 页面组件、样式布局、交互动效、前端路由、本地数据缓存 (localStorage)、以及与后端 API (api-client.ts) 进行联调对接的开发工作。

---

## 2. 强制引用的规范文件

在对前端代码进行任何新建、修改或重构前，前端开发 Agent **必须自觉、完全查阅并无条件遵守**以下规范文件：
- **前端独立开发规范**：[frontend-standards.md](file:///e:/workspace/navatation/workflow/frontend-standards.md) (涵盖 React 嵌套控制、卫语句逻辑、安全可选链访问、Tailwind CSS 与 CSS 命名、加载中与错误友好交互状态等核心编码准则)
- **多 Agent 协作流总纲**：[team-workflow.md](file:///e:/workspace/navatation/workflow/team-workflow.md) (了解角色切换声明、服务启动机制、Bug 处理与交付流程)
- **全局语言规则**：[language-rule.md](file:///e:/workspace/navatation/workflow/language-rule.md) (全部代码注释、提交日志与文档说明强制使用中文)

---

## 3. 开发执行流程与闭环要求

1. **查阅接口与需求**：
   - 查阅 [api-specification.md](file:///e:/workspace/navatation/doc/api-specification.md) 对齐所需后端的 API 地址与传参报文。
   - 查阅 [PRD.md](file:///e:/workspace/navatation/doc/PRD.md) 对齐功能点的需求编号，秉持极简方案设计，不过度实现。
2. **代码编写与自检**：
   - 在 `navatation-web/src/app` 目录下定位相关页面或 UI 组件。
   - 实现交互逻辑时，严格遵照“卫语句”和“嵌套层级不超过 3 层”的强制规范，超出部分主动拆分为独立子函数或子组件。
3. **接口调用与容错**：
   - 统一使用项目封装好的 [api-client.ts](file:///e:/workspace/navatation/navatation-web/src/app/services/api-client.ts)，确保网络异常或接口 401 失败时能够被 Promise 异常捕获机制 (try-catch) 妥善处理。
   - 必须实现优雅的加载状态（Loading）和数据为空（Empty）的友好交互界面。
4. **服务自启与运行确认**：
   - 前端开发完成后，**必须确保前端 dev server 正确启动**：
     - 工作目录：`navatation-web/`
     - 启动命令：`npm run dev`
     - 确认控制台输出：本地开发访问地址（通常为 `http://localhost:5173`）
5. **结构化向 PM 汇报**：
   - 功能开发完成且确认运行无误后，向 PM 报告改动文件、实现方案要点以及需要的重点验证交互路径。
