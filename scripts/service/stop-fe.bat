@echo off
title Stop Navatation Frontend
echo ============================================
echo   Stopping Navatation Frontend (Port 5173)...
echo ============================================
set PORT=5173
set FOUND=0

for /f "tokens=5" %%a in ('netstat -aon ^| findstr ":%PORT% " ^| findstr "LISTENING"') do (
    set FOUND=1
    echo Found process with PID %%a listening on port %PORT%. Killing...
    taskkill /F /PID %%a
)

if "%FOUND%"=="0" (
    echo No active process found listening on port %PORT%.
)
echo ============================================
