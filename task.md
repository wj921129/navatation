# 🚀 Antigravity CLI (agy) 迁移任务看板

## 📋 任务列表

- [x] **PHASE 3.1: 基础设施搭建 (M)**
  - [x] 创建 `.agents/` 目录并初始化 `settings.json`
  - [x] 提取并转换 `.gemini/settings.json` 中的 MCP 配置到 `.agents/mcp_config.json`
  - [ ] 迁移 `.gemini/` 下的技能文件到 `.agents/skills/`

- [x] **PHASE 3.2: 权限与信任模型同步 (L)**
  - [x] 解析 `.gemini/settings.json` 中的 `allowed` 和 `permissions`
  - [x] 在 `.agents/settings.json` 中配置 agy 的自动执行策略 (`autoExecutionPolicy`)
  - [x] 验证 `allowedCommands` 在 agy 中的兼容性

- [x] **PHASE 3.3: 会话钩子适配 (L)**
  - [x] 迁移 SessionStart/End 钩子逻辑
  - [x] 验证服务自动启停逻辑（start-be.bat / start-fe.bat）
  - [x] 适配 agy 的钩子 JSON 负载结构

- [x] **PHASE 3.4: 项目指令升级 (S)**
  - [x] 创建 `.antigravity.md` (或更新 GEMINI.md) 以包含 agy 特有指令
  - [x] 更新 `GEMINI.md` 中的脚本调用说明

- [ ] **PHASE 4: 自我验证与闭环 (M)**
  - [ ] 运行 `agy --version` 确认环境
  - [ ] 启动服务并验证权限策略
  - [ ] **[CRITICAL] 运行 .\push-dev.bat 推送迁移代码**

---
## 📝 迁移笔记
- Antigravity 默认使用 `.agents/` 目录。
- MCP 远程服务字段由 `url` 变更为 `serverUrl`。
- 钩子负载路径由 `.tool_input` 变更为 `.toolCall.args`。
