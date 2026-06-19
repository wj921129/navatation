---
name: custom-finish-development-task
description: Executes the mandatory project wrap-up sequence (Git push and METRICS logging) before concluding a task. Call this when development work is completed.
---

# 🏁 任务收尾与 Git 推送流程 (Task Wrap-up Sequence)

当开发者（用户老板）的当前开发任务完成，并在本地测试通过后，你需要强制触发本技能，以确保所有的变更都被正确推送到仓库，并按要求留下可供审查的度量数据。

## 严格执行步骤 (Strict Execution Steps)

你必须**按顺序**自动执行以下步骤，任何一步失败都必须先解决错误：

### 1. 运行本地推送脚本 (Run Git Push)
在 `navatation` 根目录下调用内置的 Git 推送脚本。
- **日常开发**（dev 分支）：运行 `scripts\git\push-dev.bat`
- **主干合并**（需要老板许可）：运行 `scripts\git\merge-to-main.bat`
> **注意**：如果在推送过程中遇到冲突或失败，请立刻报告并引导解决，不要继续宣称任务完成。必须保证工作区 (`Working Tree`) 干净。

### 2. 输出 METRICS 度量数据 (Output Metrics)
在 Git 推送成功后，你**必须且只能**在你最后一次回复消息的最末尾，输出一个 `[METRICS]` 数据块，供后台指标系统扫描收集。

**必须原样输出的格式模板**：
```text
[METRICS]
Plugins / MCP & Skills: {列出本次调用的外部插件/MCP工具或技能，如 "custom-finish-development-task, run_command"}
原生 Tools: {列出使用到的原生工具名称，如 "replace_file_content, run_command"}
Subagents: {若派发了后台智能体则列出其角色，否则写 "未派发"}
[/METRICS]
```

> **⚠️ 绝对红线 (CRITICAL)**：绝对严禁在本地存在未提交更改时向老板宣布“任务已完成”。METRICS 数据块是本次会话收尾的强制句号，不可省略。
