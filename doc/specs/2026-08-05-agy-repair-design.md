# 方案设计：Antigravity (AGY) 2.0 启动异常与对话无反应自动化修复方案

本方案旨在解决老板在 Windows 环境下运行 `agy` 客户端时遇到的三个核心阻塞故障（Windows 兼容路径盘符丢失、本地网络代理冲突、MCP 模块卡死），并最终实现能够顺利拉起 `agy` 并正常完成对话。

## 1. 架构与模块设计

修复方案主要由两个部分组成：

### 1.1. 可视化诊断报告 (`diagnose_report.md`)
*   **存放路径**：`C:\Users\63196\.gemini\antigravity-cli\brain\c0ada140-48aa-400a-a3c9-7c4b6c3bb4fd\diagnose_report.md` （Artifact 目录，使用户能直接通过对话框链接点开查看）。
*   **主要内容**：
    *   故障诊断摘要。
    *   三大核心故障（Windows 兼容性路径 Bug、本地网络代理冲突、MCP 模块卡死）的技术成因与原理解析。
    *   `repair-agy.ps1` 脚本的原理说明与运行指导。
    *   快速自测与验证流程。

### 1.2. 自动化修复脚本 (`repair-agy.ps1`)
*   **存放路径**：`E:\workspace\navatation\scripts\repair-agy.ps1`。
*   **主要功能**：
    1.  **路径 Bug 修复**：
        *   将 `MSYS_NO_PATHCONV=1` 写入 Windows 用户环境变量。
        *   探测用户主目录下是否有 Git Bash 的配置文件（`.bash_profile`、`.bashrc`、`.profile`），若有则自动追加 `export MSYS_NO_PATHCONV=1`。
    2.  **网络代理阻断检测**：
        *   使用 PowerShell 校验 localhost/127.0.0.1 端口回环通信状态。
        *   打印常见代理软件（如 Clash、Sing-box、V2Ray）的绕过配置示范（Bypass 列表格式）。
    3.  **MCP 卡死问题检测与优化**：
        *   定位 `C:\Users\63196\.gemini\antigravity-cli\mcp\@modelcontextprotocol/fetch` 目录。
        *   检查 `fetch.json` 配置文件，如果发现有超时风险的在线加载项，则自动备份并隔离它，防止其在同步等待中卡死 Language Server。
    4.  **环境闭环清理**：
        *   在脚本执行完毕且验证 agy 能够正常启动后，将由 AI 助手引导老板删除该脚本，保持代码库的洁净，防止临时调试脚本残留。

---

## 2. 实施计划 (Implementation Plan)

1.  **步骤一**：在 Artifacts 目录生成诊断报告 `diagnose_report.md`。
2.  **步骤二**：创建 `E:\workspace\navatation\scripts\repair-agy.ps1` 脚本。
3.  **步骤三**：引导老板在 PowerShell 中运行该修复脚本。
4.  **步骤四**：老板重新打开 Git Bash 或终端，重新运行 `agy` 客户端并完成对话测试。
5.  **步骤五**：确认可以对话后，执行收尾流程，彻底删除 `repair-agy.ps1` 临时修复脚本，并使用 `custom-finish-development-task` 完成工作交接。

---

## 3. 安全性与防御性设计

*   **路径隔离**：脚本仅对指定的系统环境变量和当前用户的 `.bashrc` 等配置文件进行追加写入，写入前将自动复制备份原文件。
*   **备份机制**：若脚本修改 MCP 服务配置，会先创建 `.bak` 文件，支持一键还原。
