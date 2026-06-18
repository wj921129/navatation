# 📊 Code 图谱 MCP 服务对比分析报告

针对开源项目 **DeusData/codebase-memory-mcp**，我们将其与当前 Navatation 项目中已安装并运行的 **@colbymchenry/codegraph** 进行了多维度的深度对比。

以下是详细对比结果：

## 1. 核心维度对比一览表

| 维度 | @colbymchenry/codegraph (当前已安装) | DeusData/codebase-memory-mcp (目标评估) |
| :--- | :--- | :--- |
| **开发语言** | TypeScript / JavaScript | Rust / Go (编译型) |
| **部署形式** | npm 包 / 需要 Node.js 运行时支持 | 独立静态二进制文件 (Single static binary, 零依赖) |
| **存储后端** | 本地 SQLite 数据库 (结合 FTS5 全文索引) | 内存优先的持久化知识图谱数据库 (RAM-first Graph) |
| **语言支持** | 20+ 种主流语言 | 158 种语言 (通过内置 Tree-sitter parser) |
| **文件监控** | 原生 OS 文件事件监听，支持增量热自动同步 | 极速全量索引 + 内存高速图构建 (Linux 内核秒级索引) |
| **MCP 工具数量**| ~5 个核心工具 (查找定义、追踪引用、影响范围等) | **14 个高级分析工具** |
| **特色功能** | 基础 AST 树依赖、SQLite 全文检索、极简配置 | Cypher 图查询、死代码检测、跨服务 HTTP 调用链路分析、3D 图谱可视化 UI、架构决策记录 (ADR) 管理 |

---

## 2. 核心区别与技术细节

### 🛠️ 分发与依赖 (Deployment & Runtime)
- **@colbymchenry/codegraph**：
  - 目前集成在我们的脚本 [start-codegraph.bat](file:///C:/workspace/my-workspace/navatation/scripts/tools/start-codegraph.bat) 中，通过 `npx -y @colbymchenry/codegraph` 启动。它严重依赖本地的 **Node.js** 运行时。
- **DeusData/codebase-memory-mcp**：
  - 采用单一静态二进制文件分发，**零依赖**。这意味着在没有 Node.js 或 npm 环境的主机上，或者在轻量级无头环境中也能无缝运行。

### 🌐 语言支持的广度 (Language Breadth)
- **@colbymchenry/codegraph**：
  - 侧重于常见的 **20+ 种** 现代主流语言（如 TS/JS、Python、Go、Rust、Java、C# 等）。对于一般的 Web 与 Admin 项目（例如我们的前端 React 与后端 Spring Boot 架构）已经足够。
- **DeusData/codebase-memory-mcp**：
  - 支持高达 **158 种** 编程语言，这得益于其将大量的 Tree-sitter 语法文件直接打包编译进二进制。适合处理包含小众语言、多语言混合的超大型异构项目。

### 🧠 图谱分析深度与高级功能 (Intelligence & Advanced Tools)
**codebase-memory-mcp** 提供了相比之下更为硬核的静态代码分析工具包，它的 14 个 MCP 工具包含了普通图谱不具备的高级工程分析能力：
1. **死代码检测 (Dead Code Detection)**：自动找出项目中未被调用的僵尸代码，非常适合重构清理。
2. **跨服务 HTTP 链接分析 (Cross-service HTTP Link Analysis)**：能够检测跨项目的 HTTP 请求与对应的 Controller 路由。如果用于分析我们 `navatation-web`（前端）和 `navatation-admin`（后端）之间的接口调用关系，会非常有帮助。
3. **Cypher 查询支持**：内置支持类似图形数据库（如 Neo4j）的 Cypher 风格查询，AI 或开发者可以编写复杂的声明式图查询来剖析代码结构。
4. **3D 可视化图谱 UI**：提供可选的 3D 可视化界面，比传统的符号列表更直观。
5. **架构决策记录 (ADR) 联动**：辅助管理设计决策链路。

而 **@colbymchenry/codegraph** 则更加偏向于**极简实用的上下文导航**（通过 SQLite FTS5 实现高效的文本搜索以及常规的 AST 符号依赖关系上下游查找）。

---

## 3. 架构师建议

1. **当前项目评估**：我们目前的前后端项目 `navatation` 技术栈为 **React 18 (TS) + Spring Boot (Java)**。当前已安装的 `@colbymchenry/codegraph` 已经能够完美覆盖这两种语言的 AST 符号解析和上下游依赖查找需求。
2. **是否需要切换**：
   - **如果老板希望获得“跨服务接口调用追踪”、“自动化死代码扫描”或“三维代码可视化”等更高级的分析功能**，那么非常建议我们将图谱 MCP 升级/替换为 `DeusData/codebase-memory-mcp`。
   - **如果仅用于常规辅助 AI 编码（如查找方法定义、寻找被谁调用）**，现有的 `@colbymchenry/codegraph` 在性能与同步便利性上已经非常优秀，无需盲目折腾。
