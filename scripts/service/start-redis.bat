@echo off
title Navatation Redis Service
echo ============================================
echo   Starting Navatation Redis Service...
echo ============================================
cd /d "D:\javaSoftware\Redis"
redis-server.exe redis.windows.conf
