@echo off
setlocal
cd /d "%~dp0..\..\navatation-web"

echo ==============================================================
echo WARNING: This script will switch to the 'dev' branch.
echo Please ensure you have no uncommitted changes!
echo ==============================================================
pause

echo.
echo [1/5] Switching to 'dev' branch and pulling latest code...
git checkout dev
git pull

echo.
echo [2/5] Installing dependencies...
call npm install

echo.
echo [3/5] Building frontend project (dev mode)...
call npm run build -- --mode development

echo.
echo [4/5] Compressing static files...
if exist "..\scripts\package\dist-dev.zip" del /q "..\scripts\package\dist-dev.zip"
powershell Compress-Archive -Path dist -DestinationPath ..\scripts\package\dist-dev.zip -Force

echo.
echo [5/5] Build complete! File saved at scripts\package\dist-dev.zip
endlocal
pause
