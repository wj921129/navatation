#!/bin/bash
chcp 65001 > /dev/null 2>&1
# Navatation 前端启动脚本

# ========== 环境配置（按需修改） ==========
# export NODE_HOME=/d/javaSoftware/Node.js
# export PATH=$NODE_HOME:$PATH

# ========== 清理旧进程 ==========
SCRIPT_DIR="$(dirname "$0")"
bash "$SCRIPT_DIR/stop-fe.sh"

# ========== 启动 ==========
echo "启动前端开发服务器 (http://localhost:5173)..."
cd "$SCRIPT_DIR/../navatation-web" || exit 1
npm run dev
