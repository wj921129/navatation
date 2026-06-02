@echo off
title Stop All Navatation Services
echo ============================================
echo   Stopping all Navatation Services...
echo ============================================

echo [1/3] Stopping Frontend Service (Port 5173)...
call "%~dp0stop-fe.bat"

echo [2/3] Stopping Backend Service (Port 8080)...
call "%~dp0stop-be.bat"

echo [3/3] Stopping Redis Service (Port 6379)...
call "%~dp0stop-redis.bat"

echo ============================================
echo   All services stopped!
echo ============================================
