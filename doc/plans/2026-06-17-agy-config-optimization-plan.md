# agy 配置与工作流文档优化重构实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 优化 `agy` 配置文件中的硬编码路径，并重构 `GEMINI.md` 与 `WORKFLOW.md` 中的冲突/冗余规则，以确保环境可移植性和规则的一致性。

**Architecture:** 
1. 将 `.agents/settings.json` 中的绝对路径全部替换为相对路径。
2. 重写 `GEMINI.md` 中极速启动指南，增加自动状态的自检引导，精简手动启动为一键脚本调用。
3. 重构 `WORKFLOW.md`，将服务自动拉起、CodeGraph MCP 托管及 Git 推送闭环的规则去重并收拢。

**Tech Stack:** JSON, Markdown, Powershell/Batch CMD

## Global Constraints

- 修改所有路径必须为相对项目根目录的路径，确保环境可移植性。
- 代码注释、文档、以及 Git 提交日志必须全部使用中文。
- 所有写操作完成后，开口向老板汇报前，必须运行 `.\push-dev.bat` 进行推送。

---

### Task 1: 优化 `.agents/settings.json` 路径

**Files:**
- Modify: `E:\workspace\navatation\.agents\settings.json`

**Interfaces:**
- Consumes: 无
- Produces: 相对路径执行 SessionStart 和 SessionEnd 钩子

- [ ] **Step 1: 修改 `.agents/settings.json` 中的绝对路径**

将文件中的 `"cmd.exe /c E:\\workspace\\navatation\\scripts\\service\\start-all.bat"` 和 `"cmd.exe /c E:\\workspace\\navatation\\scripts\\service\\stop-all.bat"` 替换为相对路径。

```json
{
  "tools": {
    "autoExecutionPolicy": "always",
    "confirmCommands": false,
    "allowed": [
      "*"
    ],
    "allowedCommands": [
      "npm *",
      "npx *",
      "mvn *",
      "git *",
      "java *",
      "cmd.exe *",
      "powershell *"
    ]
  },
  "hooks": {
    "SessionStart": [
      "cmd.exe /c scripts\\service\\start-all.bat"
    ],
    "SessionEnd": [
      "cmd.exe /c scripts\\service\\stop-all.bat"
    ]
  }
}
```

- [ ] **Step 2: 验证 JSON 格式是否正确**

运行：`powershell -Command "Get-Content E:\workspace\navatation\.agents\settings.json | ConvertFrom-Json"`
Expected: 无报错输出，且输出正确的 JSON 结构。

- [ ] **Step 3: 提交修改**

运行：`git add .agents/settings.json`
运行：`git commit -m "refact: 将 settings.json 中的启动/停止钩子绝对路径重构为相对路径"`
Expected: 提交成功。

---

### Task 2: 重构 `GEMINI.md` 中的极速启动指南

**Files:**
- Modify: `E:\workspace\navatation\GEMINI.md`

**Interfaces:**
- Consumes: Task 1 中对生命周期启动脚本的修改
- Produces: 统一的极速启动与防重判定文档说明

- [ ] **Step 1: 修改 `GEMINI.md` 的 `⚡ AI 极速启动服务指令 (Fast Launch Guide)` 部分**

将原本的 `E:\workspace\navatation\GEMINI.md` 第 12 行到第 30 行替换为防重检查与一键脚本调用逻辑。

现有内容：
```markdown
## ⚡ AI 极速启动服务指令 (Fast Launch Guide)
当老板下达“启动前后端”、“启动服务”或类似指令时，AI **必须在 0 文件检索的前提下**立即、直接依次执行以下后台异步命令（Cwd 路径为项目根目录的相对路径）：
1. **Redis**:
   - **相对路径 (Cwd)**: `scripts/service`
   - **Command**: `.\start-redis.bat`
2. **Backend**:
   - **相对路径 (Cwd)**: `navatation-admin/navatation-business`
   - **Command**: `$env:JAVA_HOME = "D:\javaSoftware\jdk\jdk17"; mvn spring-boot:run`
3. **Frontend**:
   - **相对路径 (Cwd)**: `navatation-web`
   - **Command**: `npm run dev`
*(此备忘录优先级最高，用于避免读取子规范文件或脚本内容以缩短启动前置开销)*
```

替换为：
```markdown
## ⚡ AI 极速启动与服务管理指南 (Fast Launch Guide)
当老板下达“启动服务”、“启动前后端”或类似指令时，AI 必须遵循以下原则以防启动冲突：
1. **防重检查**：当前项目已配置 agy `SessionStart` 自动生命周期托管，服务在 agy 启动时已由后台自动拉起。AI 应当先核对相关端口或服务状态（如 Redis 6379, 后端 8080, 前端 5173）。若已在运行，直接向老板汇报“服务已自动拉起并就绪”。
2. **手动拉起/重启**：若服务未拉起或老板明确要求手动启动/重启，必须在**根目录**下直接异步执行一键启动脚本：
   - **Cwd**: `.` (项目根目录)
   - **Command**: `cmd.exe /c scripts\service\start-all.bat`
   *(严禁在未检查状态下，手动分步执行 Redis、Backend 和 Frontend 命令以防端口冲突。)*
```

- [ ] **Step 2: 确认文档格式与排版**

查看 `GEMINI.md` 第 1-50 行，确认内容替换没有破坏后续其他章节。

- [ ] **Step 3: 提交修改**

运行：`git add GEMINI.md`
运行：`git commit -m "docs: 重写 GEMINI.md 服务极速启动指南，理顺自动启动与手动干预逻辑"`
Expected: 提交成功。

---

### Task 3: 重构 `WORKFLOW.md` 规则去重与整理

**Files:**
- Modify: `E:\workspace\navatation\.agents\rules\WORKFLOW.md`

**Interfaces:**
- Consumes: Task 2 中的启动原则
- Produces: 集中、精简的无冲突工作流规则

- [ ] **Step 1: 修改 `WORKFLOW.md` 中的 `### 2. AI 快捷启动链路规则`**

修改 `WORKFLOW.md` 的第 19-24 行。
现有内容：
```markdown
### 2. AI 快捷启动链路规则
当老板让你"启动前后端"时，必须按以下顺序**直接启动后台任务**：
1. **Redis**: `.\start-redis.bat` (Cwd: `E:\workspace\navatation\scripts\service`)
2. **Backend**: `$env:JAVA_HOME = "D:\javaSoftware\jdk\jdk17"; mvn spring-boot:run` (Cwd: `E:\workspace\navatation\navatation-admin\navatation-business`)
3. **Frontend**: `npm run dev` (Cwd: `E:\workspace\navatation\navatation-web`)
```

替换为：
```markdown
### 2. AI 快捷启动与托管规则
在 agy 模式下，系统在 Session 建立时已自动运行一键脚本拉起全部服务。如果老板要求手动启动或需要重启：
- **操作原则**：优先执行根目录下的 `scripts\service\start-all.bat`。
- **防重逻辑**：AI 在响应前必须自检端口是否已占用，避免重复拉起导致端口冲突崩溃。
```

- [ ] **Step 2: 修改 `WORKFLOW.md` 中的 `### 3. CodeGraph 索引维护`**

修改 `WORKFLOW.md` 的第 25-33 行。
现有内容：
```markdown
### 3. CodeGraph 索引维护
> [!IMPORTANT]
> codegraph daemon 运行时自带 **file watcher**，会自动监听文件变更并增量同步 `.codegraph/codegraph.db`，**无需手动重建**。
> 但 daemon 未启动期间的文件变更不会被捕获，因此开发前务必确认 daemon 处于运行状态。

- **检查方式**：查看 `.codegraph/daemon.pid` 是否存在且进程存活。
- **启动方式**：运行 [start-codegraph.bat](file:///E:/workspace/navatation/scripts/tools/start-codegraph.bat)，或直接执行 `npx -y @colbymchenry/codegraph`。
- **全量重建场景**：长时间未启动 daemon（如切分支、长假归来）时，启动 daemon 即可自动全量索引。
```

替换为：
```markdown
### 3. CodeGraph 索引维护与 MCP 托管
> [!IMPORTANT]
> 在 agy 模式下，CodeGraph 已经作为 MCP Server（由 `.agents/mcp_config.json` 托管）在会话启动时自动拉起。AI 助手可直接调用 MCP tools 进行符号依赖和 AST 索引查询，无需手动检查 `.codegraph/daemon.pid` 状态。

- **非 agy 环境开发**：若在非 agy 环境（如独立 IDE 或终端）中开发，需手动确认守护进程运行状态：
  - 运行 [start-codegraph.bat](file:///E:/workspace/navatation/scripts/tools/start-codegraph.bat) 启动进程。
  - daemon 运行时自带 file watcher 监听变更并增量同步。
```

- [ ] **Step 3: 优化 `WORKFLOW.md` 中的推送和代码评审规则**

修改 `WORKFLOW.md` 的第 34-45 行以及第 69-71 行。

修改 `WORKFLOW.md` 的 `### 4. 分支推送工作流 (CRITICAL)` 现有内容：
```markdown
### 4. 分支推送工作流 (CRITICAL)
本项目采用 `dev` 与 `main` 双分支模型。
- **日常推送 (`dev` 分支)**：完成任何修改且**向老板开口汇报之前**，必须自动调用 [push-dev.bat](file:///E:/workspace/navatation/scripts/git/push-dev.bat) 推送。调用时必须传入简短准确的提交描述（例如：`.\push-dev.bat "feat: 增加全局ESC关闭弹窗功能"`），严禁使用默认描述。执行复杂计划创建 `task.md` 时，必须将 `[ ] 自动运行 .\push-dev.bat 推送代码` 作为最后一项任务。
- **合并发布 (`main` 分支)**：大特性在 `dev` 验证无误后，获得明确许可后再运行 [merge-to-main.bat](file:///E:/workspace/navatation/scripts/git/merge-to-main.bat) 推送至 `main`。
```

替换为：
```markdown
### 4. 分支管理工作流
本项目采用 `dev` 与 `main` 双分支模型。
- **日常开发**：在 `dev` 分支进行。任务完成交付前执行 Git 推送闭环。
- **合并发布 (`main` 分支)**：大特性在 `dev` 验证无误并获得明确许可后，运行 [merge-to-main.bat](file:///E:/workspace/navatation/scripts/git/merge-to-main.bat) 合并推送。
```

修改 `WORKFLOW.md` 的 `### 5. Git 推送闭环` 现有内容：
```markdown
### 5. Git 推送闭环
**⚠️ 【最高行为红线】 ⚠️**
只要对工程目录下的任何文件进行了写操作，**向老板开口汇报前的最后一项动作**，必须且只能是运行 `.\push-dev.bat "描述"` 脚本进行推送。绝对严禁在本地存在未提交更改时向老板汇报完成。
```

替换为：
```markdown
### 5. Git 推送闭环
**⚠️ 【最高行为红线】 ⚠️**
1. **时机**：只要对工程目录下的任何文件进行了写操作，**在开口汇报前**必须运行 `.\push-dev.bat "您的具体变更说明"`（禁止使用默认描述）。
2. **无遗留**：绝对严禁在本地存在未提交更改（Working Tree 脏）时向老板汇报任务完成。
3. **计划对齐**：执行复杂任务创建 `task.md` 时，必须将 `[ ] 运行 .\push-dev.bat 提交代码` 作为任务清单的最后一项。
```

修改 `WORKFLOW.md` 的 `### 2. 实时代码评审` 现有内容：
```markdown
### 2. 实时代码评审
In `agy` 的 TUI 环境下工作时，AI 助手在每次交付代码时，必须首先保证代码的类型安全性与构建正确性，并在开口汇报前完成 `.\push-dev.bat` 的代码同步。
```

替换为：
```markdown
### 2. 自动构建与校验
在 `agy` 环境下开发时，AI 助手在每次交付前必须自动运行项目构建或 Lint 检查以确保代码类型安全性，排除潜在编译错误。Git 推送的执行规范详见本文件的 [Git 推送闭环](#5-git-推送闭环) 部分。
```

- [ ] **Step 4: 确认重构后的 `WORKFLOW.md` 整体格式**

查看修改后的 `WORKFLOW.md`，确认没有其他多余重复，格式良好。

- [ ] **Step 5: 提交修改**

运行：`git add .agents/rules/WORKFLOW.md`
运行：`git commit -m "docs: 优化 WORKFLOW.md 中服务启动、CodeGraph MCP 和推送闭环规则，精简冗余规则"`
Expected: 提交成功。

---

### Task 4: 运行自动化推送脚本并向老板提交

**Files:**
- Modify: 无

**Interfaces:**
- Consumes: Task 1-3 产生的全部修改与提交记录
- Produces: 成功同步的远程分支

- [ ] **Step 1: 执行本地代码自动推送**

在项目根目录下，运行开发环境同步推送脚本：
`cmd.exe /c .\scripts\git\push-dev.bat "docs/refact: 全面重构优化 agy 配置与启动推送工作流规范"`
Expected: 本地所有待提交文件清空，并且远程 dev 分支同步成功。
