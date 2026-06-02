@echo off
echo ============================================
echo   Pushing all Navatation repositories to dev branch...
echo ============================================

set COMMIT_MSG=%~1

if "%COMMIT_MSG%"=="" (
    set COMMIT_MSG=dev: auto update code
)

echo.
echo --------------------------------------------
echo [1/3] Pushing backend repository (navatation-admin) to dev...
echo --------------------------------------------
cd /d "%~dp0..\..\navatation-admin"
git add .
git diff-index --quiet HEAD -- || git commit -m "%COMMIT_MSG%"
git push origin dev

echo.
echo --------------------------------------------
echo [2/3] Pushing frontend repository (navatation-web) to dev...
echo --------------------------------------------
cd /d "%~dp0..\..\navatation-web"
git add .
git diff-index --quiet HEAD -- || git commit -m "%COMMIT_MSG%"
git push origin dev

echo.
echo --------------------------------------------
echo [3/3] Pushing main repository (navatation) to dev...
echo --------------------------------------------
cd /d "%~dp0..\.."
git add .
git diff-index --quiet HEAD -- || git commit -m "%COMMIT_MSG%"
git push origin dev

echo.
echo ============================================
echo   All dev repositories pushed successfully!
echo ============================================
