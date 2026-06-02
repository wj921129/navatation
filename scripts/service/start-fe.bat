@echo off
title Navatation Frontend Service
echo ============================================
echo   Starting Navatation Frontend Service...
echo ============================================
cd /d "%~dp0..\..\navatation-web"
npm run dev
