@echo off
echo ============================================
echo   Pushing all Navatation repositories to GitHub...
echo ============================================

set COMMIT_MSG=%~1

if "%COMMIT_MSG%"=="" (
    set /p COMMIT_MSG="Please enter commit message (default 'update: general code polish and updates'): "
)

if "%COMMIT_MSG%"=="" (
    set COMMIT_MSG=update: general code polish and updates
)

echo.
echo --------------------------------------------
echo [1/3] Pushing backend repository (navatation-admin)...
echo --------------------------------------------
cd /d "%~dp0..\navatation-admin"
git add .
git diff-index --quiet HEAD -- || git commit -m "%COMMIT_MSG%"
git push origin main

echo.
echo --------------------------------------------
echo [2/3] Pushing frontend repository (navatation-web)...
echo --------------------------------------------
cd /d "%~dp0..\navatation-web"
git add .
git diff-index --quiet HEAD -- || git commit -m "%COMMIT_MSG%"
git push origin main

echo.
echo --------------------------------------------
echo [3/3] Pushing main repository (navatation)...
echo --------------------------------------------
cd /d "%~dp0.."
git add .
git diff-index --quiet HEAD -- || git commit -m "%COMMIT_MSG%"
git push origin main

echo.
echo ============================================
echo   All repositories pushed successfully!
echo ============================================
