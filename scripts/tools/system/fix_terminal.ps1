$ErrorActionPreference = 'SilentlyContinue'

# 清理我们之前可能创建的所有乱码和错误的项
Remove-Item -Path "HKCU:\Software\Classes\Directory\Background\shell\PowerShellAdmin" -Recurse
Remove-Item -Path "HKCU:\Software\Classes\Directory\Background\shell\PowerShellAsAdmin" -Recurse
Remove-Item -Path "HKCU:\Software\Classes\Directory\shell\PowerShellAdmin" -Recurse
Remove-Item -Path "HKCU:\Software\Classes\Directory\shell\PowerShellAsAdmin" -Recurse
Remove-Item -Path "HKCU:\Software\Classes\Directory\Background\shell\CustomPowerShellAdmin" -Recurse
Remove-Item -Path "HKCU:\Software\Classes\Directory\shell\CustomPowerShellAdmin" -Recurse
Remove-Item -Path "HKCU:\Software\Classes\Directory\Background\shell\WTPowerShellAdmin" -Recurse
Remove-Item -Path "HKCU:\Software\Classes\Directory\shell\WTPowerShellAdmin" -Recurse

# 定义新的正确的注册表项路径
$bgKey = "HKCU:\Software\Classes\Directory\Background\shell\WTPowerShellAdmin"
$dirKey = "HKCU:\Software\Classes\Directory\shell\WTPowerShellAdmin"

# 1. 文件夹空白处右键 (Background)
New-Item -Path $bgKey -Force | Out-Null
Set-ItemProperty -Path $bgKey -Name "(default)" -Value "以管理员身份打开 Windows PowerShell"
Set-ItemProperty -Path $bgKey -Name "Icon" -Value "powershell.exe"
Set-ItemProperty -Path $bgKey -Name "HasLUAShield" -Value ""

$bgCmdKey = "$bgKey\command"
New-Item -Path $bgCmdKey -Force | Out-Null
# 对于 Background，$PWD 就是当前目录，这避免了任何 %V 可能导致的转义问题
$bgCmd = "powershell.exe -WindowStyle Hidden -Command `"Start-Process wt.exe -WorkingDirectory `$PWD -Verb RunAs`""
Set-ItemProperty -Path $bgCmdKey -Name "(default)" -Value $bgCmd

# 2. 文件夹图标上右键 (Directory)
New-Item -Path $dirKey -Force | Out-Null
Set-ItemProperty -Path $dirKey -Name "(default)" -Value "以管理员身份打开 Windows PowerShell"
Set-ItemProperty -Path $dirKey -Name "Icon" -Value "powershell.exe"
Set-ItemProperty -Path $dirKey -Name "HasLUAShield" -Value ""

$dirCmdKey = "$dirKey\command"
New-Item -Path $dirCmdKey -Force | Out-Null
# 对于选中的文件夹，无引号 %V，结合 $args -join ' '，彻底解决引号破裂和空格问题！
$dirCmd = "powershell.exe -WindowStyle Hidden -Command `"`$p = `$args -join ' '; if(`$p) { Start-Process wt.exe -WorkingDirectory `$p -Verb RunAs }`" %V"
Set-ItemProperty -Path $dirCmdKey -Name "(default)" -Value $dirCmd

Write-Host "Success!"
