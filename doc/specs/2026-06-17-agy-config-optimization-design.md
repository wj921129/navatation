# 设计方案：agy 配置硬编码与工作流规范冗余重构

> [!NOTE]
> 本文档定义了对项目中 `agy`（Antigravity）配置文件与核心工作流文档进行重构的具体技术方案，旨在解决硬编码、进程冲突风险、规则冗余等设计硬伤。

---

## 1. 📂 涉及改动的文件清单

1.  **配置文件**：
    *   [.agents/settings.json](file:///E:/workspace/navatation/.agents/settings.json) — 钩子绝对路径改相对路径。
2.  **规范文档**：
    *   [GEMINI.md](file:///E:/workspace/navatation/GEMINI.md) — 整合极速启动部分，理顺自动与手动界限。
    *   [.agents/rules/WORKFLOW.md](file:///E:/workspace/navatation/.agents/rules/WORKFLOW.md) — 统一收拢服务启动、CodeGraph MCP 托管描述，以及 Git 代码推送的红线规范。

---

## 2. 📝 具体修改设计 (Diff Draft)

### 2.1 修改 `.agents/settings.json`
将硬编码的绝对路径更改为基于项目根目录的相对路径，以确保项目在不同环境或机器克隆时的可移植性。

```diff
   "hooks": {
     "SessionStart": [
-      "cmd.exe /c E:\\workspace\\navatation\\scripts\\service\\start-all.bat"
+      "cmd.exe /c scripts\\service\\start-all.bat"
     ],
     "SessionEnd": [
-      "cmd.exe /c E:\\workspace\\navatation\\scripts\\service\\stop-all.bat"
+      "cmd.exe /c scripts\\service\\stop-all.bat"
     ]
   }
```

---

### 2.2 优化 `GEMINI.md` 的极速启动指南
理顺 `SessionStart` 钩子自动启动和 AI 手动干预的职责，使 AI 在面对“启动服务”需求时能够做出智能防重判断，并简化手动应急指令为一键式脚本。

```diff
-## ⚡ AI 极速启动服务指令 (Fast Launch Guide)
-当老板下达“启动前后端”、“启动服务”或类似指令时，AI **必须在 0 文件检索的前提下**立即、直接依次执行以下后台异步命令（Cwd 路径为项目根目录的相对路径）：
-1. **Redis**:
-   - **相对路径 (Cwd)**: `scripts/service`
-   - **Command**: `.\start-redis.bat`
-2. **Backend**:
-   - **相对路径 (Cwd)**: `navatation-admin/navatation-business`
-   - **Command**: `$env:JAVA_HOME = "D:\javaSoftware\jdk\jdk17"; mvn spring-boot:run`
-3. **Frontend**:
-   - **相对路径 (Cwd)**: `navatation-web`
-   - **Command**: `npm run dev`
-*(此备忘录优先级最高，用于避免读取子规范文件或脚本内容以缩短启动前置开销)*
+## ⚡ AI 极速启动与服务管理指南 (Fast Launch Guide)
+当老板下达“启动服务”、“启动前后端”或类似指令时，AI 必须遵循以下原则以防启动冲突：
+1. **防重检查**：当前项目已配置 agy `SessionStart` 自动生命周期托管，服务在 agy 启动时已由后台自动拉起。AI 应当先核对相关端口或服务状态。若已在运行，直接向老板汇报“服务已自动拉起并就绪”。
+2. **手动拉起/重启**：若服务未拉起或老板明确要求手动启动/重启，必须在**根目录**下直接异步执行一键启动脚本：
+   - **Cwd**: `.` (项目根目录)
+   - **Command**: `cmd.exe /c scripts\service\start-all.bat`
+   *(严禁在未检查状态下，手动分步执行 Redis、Backend 和 Frontend 命令以防端口冲突。)*
```

---

### 2.3 重构 `WORKFLOW.md`
将重复出现的 Git 推送红线合并、澄清 CodeGraph MCP 托管职责、理顺一键拉起逻辑。

#### ① 服务启动部分
将原来分步拉起的内容与 `GEMINI.md` 对齐，收拢至一键拉起职责：
```diff
-### 2. AI 快捷启动链路规则
-当老板让你"启动前后端"时，必须按以下顺序**直接启动后台任务**：
-1. **Redis**: `.\start-redis.bat` (Cwd: `E:\workspace\navatation\scripts\service`)
-2. **Backend**: `$env:JAVA_HOME = "D:\javaSoftware\jdk\jdk17"; mvn spring-boot:run` (Cwd: `E:\workspace\navatation\navatation-admin\navatation-business`)
-3. **Frontend**: `npm run dev` (Cwd: `E:\workspace\navatation\navatation-web`)
+### 2. AI 快捷启动与托管规则
+在 agy 模式下，系统在 Session 建立时已自动运行一键脚本拉起全部服务。如果老板要求手动启动或需要重启：
+- **操作原则**：优先执行根目录下的 `scripts\service\start-all.bat`。
+- **防重逻辑**：AI 在响应前必须自检端口是否已占用，避免重复拉起导致端口冲突崩溃。
```

#### ② CodeGraph 职责澄清
阐明 agy MCP 托管与独立 Daemon 之间的关系，防止 AI 混淆职责：
```diff
-### 3. CodeGraph 索引维护
-> [!IMPORTANT]
-> codegraph daemon 运行时自带 **file watcher**，会自动监听文件变更并增量同步 `.codegraph/codegraph.db`，**无需手动重建**。
-> 但 daemon 未启动期间的文件变更不会被捕获，因此开发前务必确认 daemon 处于运行状态。
-
-- **检查方式**：查看 `.codegraph/daemon.pid` 是否存在且进程存活。
-- **启动方式**：运行 [start-codegraph.bat](file:///E:/workspace/navatation/scripts/tools/start-codegraph.bat)，或直接执行 `npx -y @colbymchenry/codegraph`。
-- **全量重建场景**：长时间未启动 daemon（如切分支、长假归来）时，启动 daemon 即可自动全量索引。
+### 3. CodeGraph 索引维护与 MCP 托管
+> [!IMPORTANT]
+> 在 agy 模式下，CodeGraph 已经作为 MCP Server（由 `.agents/mcp_config.json` 托管）在会话启动时自动拉起。AI 助手可直接调用 MCP tools 进行符号依赖和 AST 索引查询，无需手动检查 `.codegraph/daemon.pid` 状态。
+
+- **非 agy 环境开发**：若在非 agy环境（如独立 IDE 或终端）中开发，需手动确认守护进程运行状态：
+  - 运行 [start-codegraph.bat](file:///E:/workspace/navatation/scripts/tools/start-codegraph.bat) 启动进程。
  - daemon 运行时自带 file watcher 监听变更并增量同步。
```

#### ③ Git 推送与代码评审重构
清理冗余，在“Git 推送闭环”里集中阐述规范，精简第 70 行的“实时代码评审”：
```diff
-### 4. 分支推送工作流 (CRITICAL)
-本项目采用 `dev` 与 `main` 双分支模型。
-- **日常推送 (`dev` 分支)**：完成任何修改且**向老板开口汇报之前**，必须自动调用 [push-dev.bat](file:///E:/workspace/navatation/scripts/git/push-dev.bat) 推送。调用时必须传入简短准确的提交描述（例如：`.\push-dev.bat "feat: 增加全局ESC关闭弹窗功能"`），严禁使用默认描述。执行复杂计划创建 `task.md` 时，必须将 `[ ] 自动运行 .\push-dev.bat 推送代码` 作为最后一项任务。
-- **合并发布 (`main` 分支)**：大特性在 `dev` 验证无误后，获得明确许可后再运行 [merge-to-main.bat](file:///E:/workspace/navatation/scripts/git/merge-to-main.bat) 推送至 `main`。
+### 4. 分支管理工作流
+本项目采用 `dev` 与 `main` 双分支模型。
+- **日常开发**：在 `dev` 分支进行。任务完成交付前执行 Git 推送闭环。
+- **合并发布 (`main` 分支)**：大特性在 `dev` 验证无误并获得明确许可后，运行 [merge-to-main.bat](file:///E:/workspace/navatation/scripts/git/merge-to-main.bat) 合并推送。

...

 ### 5. Git 推送闭环
 **⚠️ 【最高行为红线】 ⚠️**
-只要对工程目录下的任何文件进行了写操作，**向老板开口汇报前的最后一项动作**，必须且只能是运行 `.\push-dev.bat "描述"` 脚本进行推送。绝对严禁在本地存在未提交更改时向老板汇报完成。
+1. **时机**：只要对工程目录下的任何文件进行了写操作，**在开口汇报前**必须运行 `.\push-dev.bat "您的具体变更说明"`（禁止使用默认描述）。
+2. **无遗留**：绝对严禁在本地存在未提交更改（Working Tree 脏）时向老板汇报任务完成。
+3. **计划对齐**：执行复杂任务创建 `task.md` 时，必须将 `[ ] 运行 .\push-dev.bat 提交代码` 作为任务清单的最后一项。

...

-### 2. 实时代码评审
-在 `agy` 的 TUI 环境下工作时，AI 助手在每次交付代码时，必须首先保证代码的类型安全性与构建正确性，并在开口汇报前完成 `.\push-dev.bat` 的代码同步。
+### 2. 自动构建与校验
+在 `agy` 环境下开发时，AI 助手在每次交付前必须自动运行项目构建或 Lint 检查以确保代码类型安全性，排除潜在编译错误。Git 推送的执行规范详见本文件的 [Git 推送闭环](#5-git-推送闭环) 部分。
```

---

## 3. 🎯 预期优化效果

1.  **开箱即用（Portability）**：修改为相对路径后，项目移动或由新开发者 clone 时，agy 配置无需任何改动即可完美运行。
2.  **避免端口冲突（Robustness）**：厘清服务自动与手动职责，禁止盲目手动分步拉起，降低了开发环境因端口冲突造成服务不可用的概率。
3.  **精简冗余（Efficiency）**：消除了 CodeGraph 和 Git 同步相关的规则重复，使文档更紧凑，降低了 AI 交互时的 Token 开销。
