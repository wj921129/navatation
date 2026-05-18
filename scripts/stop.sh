#!/bin/bash
chcp 65001 > /dev/null 2>&1
# Navatation 停止快捷入口 - 同时终止前后端

DIR="$(dirname "$0")"

echo "===== 停止前端 ====="
bash "$DIR/stop-fe.sh"

echo ""
echo "===== 停止后端 ====="
bash "$DIR/stop-be.sh"

echo ""
echo "清理完成。"
