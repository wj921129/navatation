@echo off
setlocal
set JAVA_HOME=D:\javaSoftware\jdk\jdk17
cd /d "%~dp0..\..\navatation-admin"

echo ==============================================================
echo WARNING: This script will switch to the 'dev' branch.
echo Please ensure you have no uncommitted changes!
echo ==============================================================
pause

echo.
echo [1/4] Switching to 'dev' branch and pulling latest code...
git checkout dev
git pull

echo.
echo [2/4] Building backend service (dev)...
call mvn clean package -DskipTests

echo [3/4] Copying build artifacts...
for /f "delims=" %%i in ('dir /b navatation-business\target\navatation-business-*.jar 2^>nul ^| findstr /v /i "original"') do (
    copy /B /Y "navatation-business\target\%%i" "..\scripts\package\navatation-backend-dev.jar"
)

echo.
echo [4/4] Build complete! File saved at scripts\package\navatation-backend-dev.jar
endlocal
pause
