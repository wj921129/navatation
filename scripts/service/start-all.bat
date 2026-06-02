@echo off
title Start All Navatation Services
echo ============================================
echo   Starting all Navatation Services...
echo ============================================

echo [1/3] Starting Redis Service...
start "Navatation Redis" cmd /c "%~dp0start-redis.bat"

echo Waiting for Redis to initialize (3 seconds)...
timeout /t 3 /nobreak >nul

echo [2/3] Starting Backend Service...
start "Navatation Backend" cmd /c "%~dp0start-be.bat"

echo Waiting for Backend to initialize (5 seconds)...
timeout /t 5 /nobreak >nul

echo [3/3] Starting Frontend Service...
start "Navatation Frontend" cmd /c "%~dp0start-fe.bat"

echo ============================================
echo   All services launched!
echo ============================================
