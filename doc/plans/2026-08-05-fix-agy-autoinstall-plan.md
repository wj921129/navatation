# 修复 agy2.0 下载完成后不触发自动安装实现计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 解决 Windows headless 模式下 agy2.0 下载更新后没有静默自动安装以及更新后无法自动以 headless 参数拉起的问题。

**Architecture:** 解包已安装客户端的 `app.asar`，修改 `dist/updater.js`。在 Windows headless 模式下，采用 `autoUpdater.quitAndInstall(true, false)` 静默安装并不强制拉起，同时在退出前 spawn 一个后台 PowerShell Job 循环检测主进程 PID 释放，在安装包完成文件覆盖（解除 exe 文件锁定）后，使用指定的无头参数 `--ozone-platform=headless --headless --disable-gpu --no-sandbox` 重新拉起程序，最终重新打包并覆盖原 `app.asar`。

**Tech Stack:** Node.js, Electron, electron-updater, PowerShell, asar

## Global Constraints
- 所有修改必须在 Windows 环境下完全兼容并安全运行。
- 静默安装绝不能弹出 UAC / 安装界面，防止在 headless 模式下卡死进程。
- 升级重启后必须保持原 headless 运行状态。

---

### Task 1: 修改解包后的 `updater.js` 中的更新事件处理

**Files:**
- Modify: `C:\Users\63196\AppData\Local\Temp\antigravity-app\dist\updater.js`

**Interfaces:**
- Consumes: `electron-updater`'s `autoUpdater`
- Produces: `headlessQuitAndInstallWin()` for post-update monitoring and silent installation triggering.

- [ ] **Step 1: 定位并修改 `update-downloaded` 监听器**

将 `C:\Users\63196\AppData\Local\Temp\antigravity-app\dist\updater.js` 中第 191-207 行的代码：
```javascript
    electron_updater_1.autoUpdater.on('update-downloaded', (info) => {
        console.log(`[AutoUpdater] Update downloaded: ${info.version}`);
        if (isHeadless) {
            // Proceed to auto install in headless mode
            if (electron_1.app.isPackaged) {
                if (process.platform === 'linux') {
                    const downloadedFilePath = info.downloadedFile;
                    headlessQuitAndInstall(downloadedFilePath);
                }
                else {
                    electron_updater_1.autoUpdater.quitAndInstall();
                }
            }
            else {
                console.log('[AutoUpdater] Headless mode: Skipping quitAndInstall (not packaged).');
            }
            return;
        }
```
替换为以下包含 `win32` 专门处理的分支：
```javascript
    electron_updater_1.autoUpdater.on('update-downloaded', (info) => {
        console.log(`[AutoUpdater] Update downloaded: ${info.version}`);
        if (isHeadless) {
            // Proceed to auto install in headless mode
            if (electron_1.app.isPackaged) {
                if (process.platform === 'linux') {
                    const downloadedFilePath = info.downloadedFile;
                    headlessQuitAndInstall(downloadedFilePath);
                }
                else if (process.platform === 'win32') {
                    headlessQuitAndInstallWin();
                }
                else {
                    electron_updater_1.autoUpdater.quitAndInstall();
                }
            }
            else {
                console.log('[AutoUpdater] Headless mode: Skipping quitAndInstall (not packaged).');
            }
            return;
        }
```

- [ ] **Step 2: 增加 `headlessQuitAndInstallWin` 函数定义**

在 `C:\Users\63196\AppData\Local\Temp\antigravity-app\dist\updater.js` 文件末尾（第 286 行后）添加以下实现代码：
```javascript
function headlessQuitAndInstallWin() {
    console.log('[AutoUpdater] Windows Headless mode: Scheduling post-quit restart.');
    try {
        const currentPid = process.pid;
        const appPath = process.execPath;
        const args = [
            '--ozone-platform=headless',
            '--headless',
            '--disable-gpu',
            '--no-sandbox',
        ];
        
        // 使用 PowerShell 脚本监控主进程 PID 退出并等待 exe 文件锁定解除（安装完成），然后重新拉起
        const psCommand = `
            $parentPid = ${currentPid};
            $app = "${appPath.replace(/\\\\/g, '\\\\')}";
            $argsList = @('--ozone-platform=headless', '--headless', '--disable-gpu', '--no-sandbox');
            
            # 等待原父进程完全退出
            while (Get-Process -Id $parentPid -ErrorAction SilentlyContinue) {
                Start-Sleep -Milliseconds 500
            }
            
            # 轮询尝试以写模式打开文件。若成功打开说明安装包已经写完并释放了 exe 的文件锁
            $locked = $true;
            $retryCount = 0;
            while ($locked -and $retryCount -lt 60) {
                try {
                    $fileStream = [System.IO.File]::Open($app, 'Open', 'Write', 'None');
                    $fileStream.Close();
                    $locked = $false;
                } catch {
                    Start-Sleep -Seconds 1;
                    $retryCount++;
                }
            }
            
            # 释放锁后额外等待 2 秒以确保稳定，随后拉起
            Start-Sleep -Seconds 2;
            Start-Process -FilePath $app -ArgumentList $argsList;
        `;
        
        const child = (0, child_process_1.spawn)('powershell.exe', ['-NoProfile', '-NonInteractive', '-Command', psCommand], {
            detached: true,
            stdio: 'ignore',
        });
        child.unref();
    }
    catch (e) {
        console.error('[AutoUpdater] Failed to schedule Windows restart:', e);
    }
    electron_updater_1.autoUpdater.quitAndInstall(true, false);
}
```

- [ ] **Step 3: 保存并验证修改后的文件**

通过静态分析或编译检查确保无 JavaScript 语法错误。

---

### Task 2: 重新打包并覆盖 `app.asar` 进行部署

**Files:**
- Modify: `C:\Users\63196\AppData\Local\Programs\antigravity\resources\app.asar`

- [ ] **Step 1: 重新打包 asar 文件**

运行打包命令：
`npx asar pack "C:\Users\63196\AppData\Local\Temp\antigravity-app" "C:\Users\63196\AppData\Local\Temp\app.asar"`

- [ ] **Step 2: 备份原 asar 文件**

备份原始的 `app.asar`（防回滚使用）：
`Copy-Item -Path "C:\Users\63196\AppData\Local\Programs\antigravity\resources\app.asar" -Destination "C:\Users\63196\AppData\Local\Programs\antigravity\resources\app.asar.bak" -Force`

- [ ] **Step 3: 覆盖原 asar 文件**

将打包好的 `app.asar` 覆盖至 Antigravity 的 resources 目录：
`Copy-Item -Path "C:\Users\63196\AppData\Local\Temp\app.asar" -Destination "C:\Users\63196\AppData\Local\Programs\antigravity\resources\app.asar" -Force`

- [ ] **Step 4: 清理临时目录**

删除解包和打包时的临时缓存文件以保持环境清净。
`Remove-Item -Recurse -Force "C:\Users\63196\AppData\Local\Temp\antigravity-app" -ErrorAction SilentlyContinue`
`Remove-Item -Force "C:\Users\63196\AppData\Local\Temp\app.asar" -ErrorAction SilentlyContinue`

---
