#!/bin/bash

# ==============================================================================
# Navatation 后端服务管理脚本 (Linux Version)
# ==============================================================================

# 配置参数
JAVA_PATH="/www/server/java/jdk-17.0.8/bin/java"
JAR_PATH="/www/wwwroot/navatation/navatation-backend-main.jar"
APP_DIR="/www/wwwroot/navatation"
JVM_OPTS="-Xmx1024M -Xms256M"

# 切换工作目录
cd "$APP_DIR" || exit 1

# 确保日志目录存在
mkdir -p "$APP_DIR/log"

# 获取程序运行的 PID
get_pid() {
    # 查找匹配当前 JAR 路径的 java 进程 PID
    pid=$(pgrep -f "$(basename "$JAR_PATH")")
    echo "$pid"
}

# 启动服务
start() {
    pid=$(get_pid)
    if [ -n "$pid" ]; then
        echo "=================================================="
        echo "警告: Navatation 后端已在运行中 (PID: $pid)"
        echo "=================================================="
        return 1
    fi

    echo "正在启动 Navatation 后端服务..."
    LOG_FILE="$APP_DIR/log/log_$(date +%Y%m%d).log"
    # 使用 nohup 后台静默启动，并将日志重定向至指定文件
    nohup "$JAVA_PATH" -jar $JVM_OPTS "$JAR_PATH" > "$LOG_FILE" 2>&1 &
    
    sleep 2
    pid=$(get_pid)
    if [ -n "$pid" ]; then
        echo "=================================================="
        echo "启动成功! PID: $pid"
        echo "日志输出至: $LOG_FILE"
        echo "=================================================="
    else
        echo "=================================================="
        echo "启动失败! 请检查日志: $LOG_FILE"
        echo "=================================================="
    fi
}

# 停止服务
stop() {
    pid=$(get_pid)
    if [ -z "$pid" ]; then
        echo "=================================================="
        echo "提示: Navatation 后端未在运行"
        echo "=================================================="
        return 1
    fi

    echo "正在停止 Navatation 后端服务 (PID: $pid)..."
    kill "$pid"
    
    # 循环检测进程是否已退出
    for i in {1..10}; do
        sleep 0.5
        pid=$(get_pid)
        if [ -z "$pid" ]; then
            echo "=================================================="
            echo "停止成功!"
            echo "=================================================="
            return 0
        fi
    done
    
    # 超时后强制杀死
    echo "优雅停止超时，正在强制停止 (kill -9)..."
    kill -9 "$pid"
    echo "强制停止成功!"
}

# 查看状态
status() {
    pid=$(get_pid)
    if [ -n "$pid" ]; then
        echo "=================================================="
        echo "服务状态: 运行中 (PID: $pid)"
        echo "=================================================="
    else
        echo "=================================================="
        echo "服务状态: 未运行"
        echo "=================================================="
    fi
}

# 重启服务
restart() {
    stop
    sleep 1
    start
}

# 脚本入口解析
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    *)
        echo "用法: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac

exit 0
