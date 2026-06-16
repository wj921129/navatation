# 🚀 AI 规范大一统合并重构任务看板

> **Goal:** 整合项目内的多个 AI 规范文件，将核心实质性规则统一汇总至 `GEMINI.md`；其他文件配置为纯重定向，保留不同 Agent 客户端兼容性的同时，最大程度减少维护成本。

## 📋 任务列表

- [x] **Task 1: 合并所有实质规范至 `GEMINI.md` (M)**
  - 任务：将 `.agents/base_rule.md` 的编码红线规范、以及 `.antigravity.md` 的 agy 配置说明，统一合并到 `GEMINI.md` 中，形成结构清晰的独立章节，并清除旧的引用。

- [x] **Task 2: 配置其他客户端引导文件为纯重定向 (S)**
  - 任务：更新 `CLAUDE.md`、`AGENTS.md` 和 `.antigravity.md`，内容精简为“重定向指向 `GEMINI.md`”的一句话声明，从而实现“单源信托”。

- [x] **Task 3: 物理删除无用的 `.agents/base_rule.md` (S)**
  - 任务：清理无用文件以保持 `.agents` 目录极简。

- [x] **Task 4: 自动运行 `.\push-dev.bat` 推送重构代码 (M)**
  - 任务：运行 Git 推送脚本，将变更同步到 `dev` 分支，完成闭环。
