@echo off
setlocal
set JAVA_HOME=D:\javaSoftware\jdk\jdk17
cd /d "%~dp0..\..\navatation-admin"

echo ==============================================================
echo WARNING: This script will switch to the 'main' branch.
echo Please ensure you have no uncommitted changes!
echo ==============================================================
pause

echo.
echo [1/4] Switching to 'main' branch and pulling latest code...
git checkout main
git pull

echo.
echo [2/4] Building backend service (main)...
call mvn clean package -DskipTests

echo.
echo [3/4] Copying build artifacts...
copy /Y navatation-business\target\navatation-business-*.jar "..\scripts\package\navatation-backend-main.jar"

echo.
echo [4/4] Build complete! File saved at scripts\package\navatation-backend-main.jar
endlocal
pause
