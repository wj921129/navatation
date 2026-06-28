@echo off
echo ======================================================
echo   安装 codebase-memory-mcp 并索引 Navatation 项目...
echo ======================================================

REM 1. 通过 winget 安装（静态二进制，零依赖）
echo [1/4] 安装 codebase-memory-mcp...
winget install DeusData.codebase-memory-mcp --accept-source-agreements --accept-package-agreements

REM 2. 开启自动索引
echo [2/4] 开启自动索引...
codebase-memory-mcp config set auto_index true
codebase-memory-mcp config set auto_index_limit 50000

REM 3. 首次索引当前项目
echo [3/4] 索引项目 E:\workspace\navatation ...
codebase-memory-mcp cli index_repository "{\"repo_path\": \"E:/workspace/navatation\"}"

REM 4. 验证
echo [4/4] 验证安装...
codebase-memory-mcp cli index_status "{\"repo_path\": \"E:/workspace/navatation\"}"

echo ======================================================
echo   安装完毕！后台 watcher 已启动，索引将自动维护。
echo ======================================================
pause
