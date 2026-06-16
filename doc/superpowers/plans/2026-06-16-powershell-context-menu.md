# Windows 右键菜单添加“在 PowerShell 中打开”实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 通过注册表脚本在 Windows 11 中恢复经典右键菜单并增加“在 PowerShell 中打开 (管理员)”功能，启用安全盾牌并实现自动提权。

**Architecture:** 编写添加与移除注册表分支的 `.reg` 配置文件，并提供对应的自动化导入与清理测试验证脚本。

**Tech Stack:** Windows Registry, PowerShell, Batch

---

### Task 1: 创建添加和删除的注册表配置源文件

**Files:**
- Create: `scripts/tools/add-powershell-menu.reg`
- Create: `scripts/tools/remove-powershell-menu.reg`

- [ ] **Step 1: 编写添加菜单注册表脚本 `scripts/tools/add-powershell-menu.reg`**

写入以下内容：
```ini
Windows Registry Editor Version 5.00

; 1. 恢复 Windows 10 经典右键菜单样式
[HKEY_CURRENT_USER\Software\Classes\CLSID\{5A292D82-B836-40B3-8897-F70C340F4844}]
@="CLSID_ContextMenuTrigger"

[HKEY_CURRENT_USER\Software\Classes\CLSID\{5A292D82-B836-40B3-8897-F70C340F4844}\InprocServer32]
@=""

; 2. 文件夹空白处右键
[HKEY_CLASSES_ROOT\Directory\Background\shell\OpenPowerShell]
@="在 PowerShell 中打开 (管理员)"
"Icon"="powershell.exe"
"HasLUAShield"=""

[HKEY_CLASSES_ROOT\Directory\Background\shell\OpenPowerShell\command]
@="powershell.exe -Command \"Start-Process powershell.exe -ArgumentList '-NoExit', '-Command', 'Set-Location -LiteralPath ''%V''' -Verb RunAs\""

; 3. 文件夹对象右键
[HKEY_CLASSES_ROOT\Directory\shell\OpenPowerShell]
@="在 PowerShell 中打开 (管理员)"
"Icon"="powershell.exe"
"HasLUAShield"=""

[HKEY_CLASSES_ROOT\Directory\shell\OpenPowerShell\command]
@="powershell.exe -Command \"Start-Process powershell.exe -ArgumentList '-NoExit', '-Command', 'Set-Location -LiteralPath ''%V''' -Verb RunAs\""

; 4. 磁盘驱动器右键
[HKEY_CLASSES_ROOT\Drive\shell\OpenPowerShell]
@="在 PowerShell 中打开 (管理员)"
"Icon"="powershell.exe"
"HasLUAShield"=""

[HKEY_CLASSES_ROOT\Drive\shell\OpenPowerShell\command]
@="powershell.exe -Command \"Start-Process powershell.exe -ArgumentList '-NoExit', '-Command', 'Set-Location -LiteralPath ''%V''' -Verb RunAs\""
```

- [ ] **Step 2: 编写移除/回滚菜单注册表脚本 `scripts/tools/remove-powershell-menu.reg`**

写入以下内容：
```ini
Windows Registry Editor Version 5.00

; 1. 恢复 Windows 11 原生右键菜单样式
[-HKEY_CURRENT_USER\Software\Classes\CLSID\{5A292D82-B836-40B3-8897-F70C340F4844}]

; 2. 删除注入的 PowerShell 选项
[-HKEY_CLASSES_ROOT\Directory\Background\shell\OpenPowerShell]
[-HKEY_CLASSES_ROOT\Directory\shell\OpenPowerShell]
[-HKEY_CLASSES_ROOT\Drive\shell\OpenPowerShell]
```

- [ ] **Step 3: 运行 Git 提交**
```bash
git add scripts/tools/add-powershell-menu.reg scripts/tools/remove-powershell-menu.reg
git commit -m "feat: 新增 PowerShell 右键菜单注册表脚本及其回滚配置"
```

---

### Task 2: 编写注册表自动测试与验证脚本

**Files:**
- Create: `scripts/tools/test-powershell-menu.ps1`

- [ ] **Step 1: 编写测试脚本 `scripts/tools/test-powershell-menu.ps1`**

写入以下内容：
```powershell
# Windows 右键菜单功能集成测试脚本

Write-Host "开始右键菜单配置导入测试..." -ForegroundColor Cyan

# 1. 导入 add-powershell-menu.reg 并验证
Write-Host "导入 add-powershell-menu.reg..." -ForegroundColor Yellow
reg import scripts\tools\add-powershell-menu.reg
if ($LASTEXITCODE -ne 0) {
    Write-Error "导入 add-powershell-menu.reg 失败"
    exit 1
}

# 验证经典菜单 CLSID 注册项是否存在
$clsidPath = "HKCU:\Software\Classes\CLSID\{5A292D82-B836-40B3-8897-F70C340F4844}\InprocServer32"
if (!(Test-Path $clsidPath)) {
    Write-Error "测试失败：未检测到经典菜单 CLSID 注册项"
    exit 1
}

# 验证 Directory 右键项是否存在
$shellPath = "Registry::HKEY_CLASSES_ROOT\Directory\shell\OpenPowerShell\command"
if (!(Test-Path $shellPath)) {
    Write-Error "测试失败：未检测到 Directory\shell\OpenPowerShell"
    exit 1
}

$shellCommand = (Get-ItemProperty -Path $shellPath)."(default)"
if ($shellCommand -notlike "*Start-Process*") {
    Write-Error "测试失败：OpenPowerShell 命令数据不匹配"
    exit 1
}

Write-Host "✅ 注册表导入与各节点存在性校验通过！" -ForegroundColor Green

# 2. 导入 remove-powershell-menu.reg 并验证清理
Write-Host "测试回滚方案，导入 remove-powershell-menu.reg..." -ForegroundColor Yellow
reg import scripts\tools\remove-powershell-menu.reg
if ($LASTEXITCODE -ne 0) {
    Write-Error "导入 remove-powershell-menu.reg 失败"
    exit 1
}

# 验证经典菜单已被彻底清理
if (Test-Path "HKCU:\Software\Classes\CLSID\{5A292D82-B836-40B3-8897-F70C340F4844}") {
    Write-Error "测试失败：回滚后经典菜单 CLSID 仍然存在"
    exit 1
}

# 验证 OpenPowerShell 节点已被删除
if (Test-Path "Registry::HKEY_CLASSES_ROOT\Directory\shell\OpenPowerShell") {
    Write-Error "测试失败：回滚后 Directory\shell\OpenPowerShell 仍然存在"
    exit 1
}

Write-Host "✅ 注册表清理与回滚功能校验通过！" -ForegroundColor Green
Write-Host "集成测试全部通过！" -ForegroundColor Green
```

- [ ] **Step 2: 运行测试脚本验证注册表配置的正确性**

运行命令：
```powershell
powershell -ExecutionPolicy Bypass -File scripts\tools\test-powershell-menu.ps1
```
预期输出：最后显示 “集成测试全部通过！”

- [ ] **Step 3: 运行 Git 提交**
```bash
git add scripts/tools/test-powershell-menu.ps1
git commit -m "test: 新增注册表注入自动化集成测试脚本"
```

---

### Task 3: 最终部署与重启资源管理器

**Files:**
- Modify: `scripts/tools/add-powershell-menu.reg` (无修改，直接执行)
- Modify: `task.md`

- [ ] **Step 1: 最终导入添加配置**

运行命令：
```powershell
reg import scripts\tools\add-powershell-menu.reg
```

- [ ] **Step 2: 重启 explorer.exe 使菜单即时生效**

在 PowerShell 中运行以下命令，重启 Windows 资源管理器：
```powershell
Stop-Process -Name explorer -Force
```
*(Windows 资源管理器进程 explorer.exe 将自动重新拉起)*

- [ ] **Step 3: 清理临时测试文件**
我们在运行测试后，已将系统回退到了默认状态。刚才我们在 Step 1 重新导入了配置，为保持系统干净，仅保留 add/remove 配置脚本和测试脚本，且确保系统注册表处于已应用最新 add 配置状态。

- [ ] **Step 4: 自动运行 `.\push-dev.bat` 推送代码**
运行：
```powershell
.\scripts\git\push-dev.bat "feat: 部署 PowerShell 右键菜单配置并更新仓库"
```
确保全套变更推送到 dev 分支。
