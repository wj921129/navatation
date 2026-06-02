@echo off
echo ============================================
echo   Merging all Navatation repositories from dev to main...
echo ============================================

echo.
echo --------------------------------------------
echo [1/3] Merging backend repository (navatation-admin)...
echo --------------------------------------------
cd /d "%~dp0..\..\navatation-admin"
git checkout main
git pull origin main
git merge dev --no-edit
git push origin main
git checkout dev

echo.
echo --------------------------------------------
echo [2/3] Merging frontend repository (navatation-web)...
echo --------------------------------------------
cd /d "%~dp0..\..\navatation-web"
git checkout main
git pull origin main
git merge dev --no-edit
git push origin main
git checkout dev

echo.
echo --------------------------------------------
echo [3/3] Merging main repository (navatation)...
echo --------------------------------------------
cd /d "%~dp0..\.."
git checkout main
git pull origin main
git merge dev --no-edit
git push origin main
git checkout dev

echo.
echo ============================================
echo   All repositories merged and pushed to main successfully!
echo ============================================
