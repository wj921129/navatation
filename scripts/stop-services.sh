#!/bin/bash
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
# SessionEnd Hook: 退出 Claude 时自动停止 Navatation 前后端服务

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_DIR="$PROJECT_DIR/navatation-admin/log"
HOOK_LOG="$LOG_DIR/navatation-hooks.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "$TIMESTAMP [HOOK] SessionEnd 开始" >> "$HOOK_LOG"

echo ""
echo "============================================"
echo "  Navatation 服务停止"
echo "============================================"

# 停止前端 (5173)
echo "$TIMESTAMP [前端] 正在停止..." >> "$HOOK_LOG"
bash "$SCRIPT_DIR/stop-fe.sh"
echo "$TIMESTAMP [前端] 已停止" >> "$HOOK_LOG"

# 停止后端 (8080)
echo "$TIMESTAMP [后端] 正在停止..." >> "$HOOK_LOG"
bash "$SCRIPT_DIR/stop-be.sh"
echo "$TIMESTAMP [后端] 已停止" >> "$HOOK_LOG"

echo "$TIMESTAMP [HOOK] SessionEnd 结束" >> "$HOOK_LOG"
echo "============================================"
echo ""
