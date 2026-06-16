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
if ($shellCommand -notlike "*powershell.exe*") {
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
