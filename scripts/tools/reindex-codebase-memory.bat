@echo off
echo ======================================================
echo   手动重索引 Navatation 项目...
echo ======================================================
codebase-memory-mcp cli index_repository "{\"repo_path\": \"E:/workspace/navatation\"}"
codebase-memory-mcp cli index_status "{\"repo_path\": \"E:/workspace/navatation\"}"
echo 完成！
pause
