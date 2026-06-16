@echo off
echo ============================================
echo   Pulling latest dev code for all Navatation repositories...
echo ============================================

echo.
echo --------------------------------------------
echo [1/3] Pulling backend repository (navatation-admin)...
echo --------------------------------------------
cd /d "%~dp0..\..\navatation-admin"
git checkout dev
git pull origin dev

echo.
echo --------------------------------------------
echo [2/3] Pulling frontend repository (navatation-web)...
echo --------------------------------------------
cd /d "%~dp0..\..\navatation-web"
git checkout dev
git pull origin dev

echo.
echo --------------------------------------------
echo [3/3] Pulling main repository (navatation)...
echo --------------------------------------------
cd /d "%~dp0..\.."
git checkout dev
git pull origin dev

echo.
echo ============================================
echo   All dev repositories pulled successfully!
echo ============================================
