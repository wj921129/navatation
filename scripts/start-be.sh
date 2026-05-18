#!/bin/bash
chcp 65001 > /dev/null 2>&1
# Navatation 后端启动脚本
# 使用前请检查 JAVA_HOME 路径是否正确

# ========== 环境配置 ==========
export JAVA_HOME=/d/javaSoftware/jdk/jdk17
export MAVEN_HOME=/d/javaSoftware/apache-maven-3.8.8
export PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

# ========== 清理旧进程 ==========
SCRIPT_DIR="$(dirname "$0")"
bash "$SCRIPT_DIR/stop-be.sh"

# ========== 构建 ==========
echo "正在编译项目..."
cd "$SCRIPT_DIR/../navatation-admin" || exit 1
mvn clean install -DskipTests -q

# ========== 启动 ==========
echo "启动后端服务 (http://localhost:8080)..."
cd navatation-business
mvn spring-boot:run
