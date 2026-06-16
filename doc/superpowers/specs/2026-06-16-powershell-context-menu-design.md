# Windows 右键菜单添加“在 PowerShell 中打开”设计说明书

本项目旨在通过修改 Windows 注册表，在 Windows 11 的右键菜单第一级中添加“在 PowerShell 中打开 (管理员)”选项，并将其与“在终端中打开”放置在相近的区域。

## 1. 方案背景与架构设计

在 Windows 11 中，默认的现代右键菜单（Fluent Context Menu）为了保证安全和样式统一，隐藏了传统的第三方 shell 注册项，只允许将它们展示在“显示更多选项”子菜单中。
为了能在第一级主右键菜单中直接添加自定义项，我们采用**恢复 Windows 10 经典右键菜单样式**的方案，这样自定义注册项即可直接生效并显示在第一级。
为满足管理员权限运行并且以黑色背景样式（而非默认蓝色）打开的需求，菜单指令使用 `Start-Process cmd.exe -Verb RunAs` 提权拉起黑色 CMD 宿主，并使用 `/c` 参数在该窗口中启动并托管 `powershell.exe`。当 PowerShell 退出时，宿主窗口同步自动关闭。

## 2. 详细配置设计

### 2.1 恢复经典右键菜单 (Win10 样式)
通过在当前用户下的 CLSID 中覆写资源管理器服务代理项实现：
- **注册表路径**：`HKEY_CURRENT_USER\Software\Classes\CLSID\{5A292D82-B836-40B3-8897-F70C340F4844}\InprocServer32`
- **默认值 (Default)**：空（在注册表中表现为 `@=""`）

### 2.2 添加“在 PowerShell 中打开 (管理员)”菜单
在以下三个注册表配置点添加相同的子项结构：
1. `HKEY_CLASSES_ROOT\Directory\shell\OpenPowerShell` (文件夹右键)
2. `HKEY_CLASSES_ROOT\Directory\Background\shell\OpenPowerShell` (文件夹内空白处右键)
3. `HKEY_CLASSES_ROOT\Drive\shell\OpenPowerShell` (磁盘驱动器右键)

每个配置点的数据定义如下：
- **默认值 (Default)**: `在 PowerShell 中打开 (管理员)` (菜单显示的文本)
- **Icon**: `powershell.exe` (直接关联系统自带的 PowerShell 图标)
- **HasLUAShield**: `""` (启用系统管理员安全盾牌图标)

对应的命令执行子项：
- `...\OpenPowerShell\command` 的**默认值 (Default)**:
  ```cmd
  powershell.exe -Command "Start-Process cmd.exe -ArgumentList '/c', 'powershell.exe -NoExit -Command Set-Location -LiteralPath ''%V''' -Verb RunAs"
  ```

## 3. 回滚方案 (卸载脚本)

为防万一，提供一套完全卸载和恢复系统默认行为的注册表文件：
1. 删除 `HKEY_CURRENT_USER\Software\Classes\CLSID\{5A292D82-B836-40B3-8897-F70C340F4844}` 以恢复 Windows 11 现代圆角右键菜单。
2. 删除以下三个 `OpenPowerShell` 键：
   - `HKEY_CLASSES_ROOT\Directory\shell\OpenPowerShell`
   - `HKEY_CLASSES_ROOT\Directory\Background\shell\OpenPowerShell`
   - `HKEY_CLASSES_ROOT\Drive\shell\OpenPowerShell`

## 4. 验证与测试方法

1. **导入注册表**：双击生成的 `.reg` 文件，写入系统注册表。
2. **重启资源管理器**：在任务管理器中重启 `explorer.exe`，或者注销并重新登录系统以使菜单生效。
3. **右键验证**：
   - 选中文件夹右键：点击“在 PowerShell 中打开 (管理员)”，验证是否能在黑底命令行窗口中加载 PowerShell，并定位至选中目录。
   - 文件夹空白处右键：点击“在 PowerShell 中打开 (管理员)”，验证是否在黑底窗口定位启动。
   - 磁盘驱动器右键：点击“在 PowerShell 中打开 (管理员)”，验证是否在黑底窗口定位启动。
   - 输入 `exit` 退出，验证窗口是否同步自动关闭。
