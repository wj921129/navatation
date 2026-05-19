#!/bin/bash
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
# SessionStart Hook: 自动检查并启动 Navatation 前后端服务
# 仅当服务未运行时才启动，已在运行则跳过

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
LOG_DIR="$PROJECT_DIR/navatation-admin/log"
FE_LOG="$LOG_DIR/navatation-fe.log"
HOOK_LOG="$LOG_DIR/navatation-hooks.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

mkdir -p "$LOG_DIR"

echo "$TIMESTAMP [HOOK] SessionStart 开始" >> "$HOOK_LOG"

echo ""
echo "============================================"
echo "  Navatation 服务状态检查"
echo "============================================"

# 检查后端 (8080)
if ! netstat -ano | grep ":8080 " | grep LISTEN > /dev/null 2>&1; then
	echo "$TIMESTAMP [后端] 未运行 → 启动中" >> "$HOOK_LOG"
	echo "  [后端] 未运行 → 后台启动中 (日志: $HOOK_LOG)"
	bash "$SCRIPT_DIR/start-be.sh" >> "$HOOK_LOG" 2>&1 &
	echo "  [后端] 正在启动..."
else
	echo "$TIMESTAMP [后端] 已在运行" >> "$HOOK_LOG"
	echo "  [后端] 已在运行 ✓"
fi

# 检查前端 (5173)
if ! netstat -ano | grep ":5173 " | grep LISTEN > /dev/null 2>&1; then
	echo "$TIMESTAMP [前端] 未运行 → 启动中" >> "$HOOK_LOG"
	echo "  [前端] 未运行 → 后台启动中 (日志: $FE_LOG)"
	bash "$SCRIPT_DIR/start-fe.sh" > /dev/null 2>&1 &
	echo "  [前端] 正在启动..."
else
	echo "$TIMESTAMP [前端] 已在运行" >> "$HOOK_LOG"
	echo "  [前端] 已在运行 ✓"
fi

echo "$TIMESTAMP [HOOK] SessionStart 结束" >> "$HOOK_LOG"
echo "============================================"
echo ""
