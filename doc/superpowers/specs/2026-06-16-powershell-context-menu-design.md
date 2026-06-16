# Windows 右键菜单添加“在 PowerShell 中打开”设计说明书

本项目旨在通过修改 Windows 注册表，在 Windows 11 的右键菜单第一级中添加“在 PowerShell 中打开 (管理员)”选项，并将其与“在终端中打开”放置在相近的区域。

## 1. 方案背景与架构设计

在 Windows 11 中，默认的现代右键菜单（Fluent Context Menu）为了保证安全和样式统一，隐藏了传统的第三方 shell 注册项，只允许将它们展示在“显示更多选项”子菜单中。
为了能在第一级主右键菜单中直接添加自定义项，我们采用**恢复 Windows 10 经典右键菜单样式**的方案，这样自定义注册项即可直接生效并显示在第一级。
为实现使用现代 Windows 终端（Windows Terminal，版本 1.24+）运行并且以管理员身份定位到当前目录，菜单指令使用 `Start-Process wt.exe -Verb RunAs` 提权拉起 Windows 终端主程序，并附带 `-p "Windows PowerShell"` 指定配置文件，以及 `-d` 参数指定当前起始工作目录。

## 2. 详细配置设计

### 2.1 恢复经典右键菜单 (Win10 样式)
通过在当前用户下的 CLSID 中覆写资源管理器 service 代理项实现：
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
  powershell.exe -Command "Start-Process wt.exe -ArgumentList '-p', '\"Windows PowerShell\"', '-d', '\"%V\"' -Verb RunAs"
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
   - 选中文件夹右键：点击“在 PowerShell 中打开 (管理员)”，验证是否成功在 Windows 终端中提权加载 PowerShell，并定位至选中目录。
   - 文件夹空白处右键：点击“在 PowerShell 中打开 (管理员)”，验证是否在 Windows 终端中定位启动。
   - 磁盘驱动器右键：点击“在 PowerShell 中打开 (管理员)”，验证是否在 Windows 终端中定位启动。
