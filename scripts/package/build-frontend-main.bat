@echo off
setlocal
cd /d "%~dp0..\..\navatation-web"

echo ==============================================================
echo WARNING: This script will switch to the 'main' branch.
echo Please ensure you have no uncommitted changes!
echo ==============================================================
pause

echo.
echo [1/5] Switching to 'main' branch and pulling latest code...
git checkout main
git pull

echo.
echo [2/5] Installing dependencies...
call npm install

echo.
echo [3/5] Building frontend project (production mode)...
call npm run build -- --mode production

echo.
echo [4/5] Compressing static files...
if exist "..\scripts\package\dist-main.zip" del /q "..\scripts\package\dist-main.zip"
powershell Compress-Archive -Path dist -DestinationPath ..\scripts\package\dist-main.zip -Force

echo.
echo [5/5] Build complete! File saved at scripts\package\dist-main.zip
endlocal
pause
