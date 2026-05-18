#!/bin/bash
chcp 65001 > /dev/null 2>&1
# Navatation 后端停止脚本

PORT=8080
PIDS=$(netstat -ano | grep ":$PORT " | grep LISTEN | awk '{print $5}' | sort -u)
if [ -n "$PIDS" ]; then
  echo "正在终止后端进程 (端口 $PORT, PID: $(echo $PIDS | tr '\n' ' '))..."
  for p in $PIDS; do
    taskkill //F //PID "$p" > /dev/null 2>&1 && echo "  已终止 PID $p" || echo "  无法终止 PID $p"
  done
else
  echo "后端 (端口 $PORT) 未在运行"
fi
