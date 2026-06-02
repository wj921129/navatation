@echo off
title Navatation Service and Git Control Panel
:menu
cls
echo ============================================
echo   Navatation 项目一键控制台仪表盘
echo ============================================
echo   [服务单个启动/停止]
echo     1. 启动 前端服务 (Vite)
echo     2. 停止 前端服务 (Port 5173)
echo     3. 启动 后端服务 (Spring Boot)
echo     4. 停止 后端服务 (Port 8080)
echo     5. 启动 Redis 缓存
echo     6. 停止 Redis 缓存
echo.
echo   [服务一键管理]
echo     7. 一键 启动所有 服务 (Redis -> 后端 -> 前端)
echo     8. 一键 停止所有 服务 (前端 -> 后端 -> Redis)
echo.
echo   [版本控制与提交]
echo     9. 一键推送所有仓库到 dev 开发分支
echo.
echo   [其他]
echo     10. 退出仪表盘
echo ============================================
set /p choice="请输入数字选择操作 (1-10): "

if "%choice%"=="1" goto start_fe
if "%choice%"=="2" goto stop_fe
if "%choice%"=="3" goto start_be
if "%choice%"=="4" goto stop_be
if "%choice%"=="5" goto start_redis
if "%choice%"=="6" goto stop_redis
if "%choice%"=="7" goto start_all
if "%choice%"=="8" goto stop_all
if "%choice%"=="9" goto push_dev
if "%choice%"=="10" goto exit
goto menu

:start_fe
echo 正在启动前端服务...
start "Navatation Frontend" cmd /c "%~dp0service\start-fe.bat"
pause
goto menu

:stop_fe
echo 正在停止前端服务...
call "%~dp0service\stop-fe.bat"
pause
goto menu

:start_be
echo 正在启动后端服务...
start "Navatation Backend" cmd /c "%~dp0service\start-be.bat"
pause
goto menu

:stop_be
echo 正在停止后端服务...
call "%~dp0service\stop-be.bat"
pause
goto menu

:start_redis
echo 正在启动 Redis 缓存...
start "Navatation Redis" cmd /c "%~dp0service\start-redis.bat"
pause
goto menu

:stop_redis
echo 正在停止 Redis 缓存...
call "%~dp0service\stop-redis.bat"
pause
goto menu

:start_all
echo 正在一键启动所有服务...
call "%~dp0service\start-all.bat"
pause
goto menu

:stop_all
echo 正在一键停止所有服务...
call "%~dp0service\stop-all.bat"
pause
goto menu

:push_dev
set /p msg="请输入本次提交的注释信息: "
if "%msg%"=="" set msg=dev: auto update code via dashboard
echo 正在一键推送所有仓库代码到 dev 开发分支...
call "%~dp0git\push-dev.bat" "%msg%"
pause
goto menu

:exit
echo 感谢使用！再见。
exit /b
