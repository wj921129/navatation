# 🚀 清理无用迁移文件与配置任务看板

> **Goal:** 扫描并删除因从 Gemini CLI 迁移到 Antigravity CLI (agy) 所残留的无用文件夹、文件及配置，保持项目目录干净整洁。

## 📋 任务列表

- [x] **Task 1: 删除空格前缀的 `.agents` 文件夹 (S)**
  - 任务：删除根目录下异常生成的空文件夹 ` .agents`（开头有空格）

- [x] **Task 2: 清理 `.claude` 文件夹 (S)**
  - 任务：删除旧 de Claude Code 配置文件及 `.claude` 目录

- [x] **Task 3: 清理 `.qoder` 文件夹 (S)**
  - 任务：删除旧的 Qoder 知识库及 `.qoder` 目录，并同步更新 `.gitignore`

- [x] **Task 4: 清理 `.gemini` 目录下的废弃配置 (S)**
  - 任务：删除 `.gemini/settings.json` 和 `.gemini/settings.local.json`，保留编码规范 `base_rule.md`

- [x] **Task 5: 自动运行 `.\push-dev.bat` 推送代码 (M)**
  - 任务：运行 Git 推送脚本，将变更推送到 `dev` 分支
