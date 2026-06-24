#!/bin/bash

# ==============================================================================
# Navatation 前端生产静态包 (dist-main.zip) Linux 部署与运行脚本
# ==============================================================================
# 
# [使用说明]
# 1. 将 scripts/package/dist-main.zip 以及本脚本上传至 Linux 服务器的同一目录下
# 2. 赋予脚本执行权限: chmod +x deploy-frontend.sh
# 3. 运行脚本: ./deploy-frontend.sh
#
# ==============================================================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0;m' # No Color

# 打印带颜色的信息
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_err() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_title() {
    echo -e "\n${BLUE}====================================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}====================================================${NC}"
}

# 检查必要工具
check_requirements() {
    log_info "正在检查系统依赖工具..."
    if ! command -v unzip &> /dev/null; then
        log_err "未检测到 unzip 工具，请先安装。例如: sudo apt-get install unzip 或 sudo yum install unzip"
        exit 1
    fi
    log_info "unzip 工具已安装。"
}

# 模式1: Nginx 宿主机部署
deploy_nginx_host() {
    log_title "开始配置：Nginx 宿主机静态部署"
    
    # 默认路径
    DEFAULT_WEB_ROOT="/var/www/html/navatation"
    read -p "请输入前端静态文件存放目录 [默认: $DEFAULT_WEB_ROOT]: " WEB_ROOT
    WEB_ROOT=${WEB_ROOT:-$DEFAULT_WEB_ROOT}
    
    log_info "目标存放目录: $WEB_ROOT"
    
    # 创建目录并解压
    if [ ! -d "$WEB_ROOT" ]; then
        log_info "目录不存在，正在创建: $WEB_ROOT"
        sudo mkdir -p "$WEB_ROOT"
    fi
    
    log_info "正在解压 dist-main.zip 到临时目录..."
    TEMP_DIR=$(mktemp -d)
    unzip -q dist-main.zip -d "$TEMP_DIR"
    
    log_info "正在将文件移动到目标目录..."
    # 兼容打包出来的压缩包内包含 dist 目录或直接是文件的情况
    if [ -d "$TEMP_DIR/dist" ]; then
        sudo cp -r "$TEMP_DIR/dist/"* "$WEB_ROOT/"
    else
        sudo cp -r "$TEMP_DIR/"* "$WEB_ROOT/"
    fi
    
    rm -rf "$TEMP_DIR"
    
    log_info "前端静态资源解压替换成功！"
    
    # 提供 Nginx 配置模板说明
    log_title "Nginx 配置推荐 (请检查并放入您的 /etc/nginx/conf.d/ 目录下)"
    cat << EOF
----------------- Nginx 配置样例 (Navatation-Frontend) -----------------
server {
    listen 80;
    server_name YOUR_DOMAIN_OR_IP; # 替换成您的域名或公网IP

    # 前端静态页面
    location / {
        root   $WEB_ROOT;
        index  index.html;
        try_files \$uri \$uri/ /index.html; # 支持 React SPA 路由
    }

    # 后端 API 反向代理（请根据实际后端地址修改）
    location /api/ {
        proxy_pass         http://127.0.0.1:8080/;
        proxy_set_header   Host              \$host;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto \$scheme;
        proxy_read_timeout 60s;
        proxy_connect_timeout 10s;
    }
}
------------------------------------------------------------------------
EOF
    
    read -p "是否尝试重新加载 Nginx 服务以使配置生效? (y/n) [默认: n]: " RELOAD_NGINX
    if [[ "$RELOAD_NGINX" =~ ^[Yy]$ ]]; then
        log_info "正在重新加载 Nginx..."
        if sudo nginx -t &> /dev/null; then
            sudo systemctl reload nginx
            log_info "Nginx 重载成功！"
        else
            log_err "Nginx 配置检查失败，请检查配置文件是否正确后再手动重载。"
        fi
    fi
    
    log_title "部署完成！"
}

# 模式2: Node.js (serve) 极速启动部署
deploy_nodejs_serve() {
    log_title "开始配置：Node.js serve 极速托管"
    
    # 检查 Node.js 环境
    if ! command -v node &> /dev/null; then
        log_err "未检测到 Node.js，此部署方案需要 Node.js 环境，请先安装 Node.js 或选择其他部署方案。"
        return 1
    fi
    
    DEFAULT_PORT="3000"
    read -p "请设置前端监听端口 [默认: $DEFAULT_PORT]: " PORT
    PORT=${PORT:-$DEFAULT_PORT}
    
    # 安装 serve
    if ! command -v serve &> /dev/null; then
        log_warn "未检测到全局 serve 工具，正在尝试通过 npm 安装..."
        sudo npm install -g serve
    fi
    
    # 解压文件
    TARGET_DIR="./navatation-frontend"
    log_info "正在解压静态资源至 $TARGET_DIR ..."
    if [ -d "$TARGET_DIR" ]; then
        rm -rf "$TARGET_DIR"
    fi
    mkdir -p "$TARGET_DIR"
    unzip -q dist-main.zip -d "$TARGET_DIR"
    
    # 如果解压出的第一层是 dist 目录，将目录内部提出来
    if [ -d "$TARGET_DIR/dist" ]; then
        mv "$TARGET_DIR/dist"/* "$TARGET_DIR/"
        rm -rf "$TARGET_DIR/dist"
    fi
    
    # 启动 serve 并使用 nohup 后台运行，配置单页应用支持 (-s)
    log_info "正在启动 serve 服务，绑定端口 $PORT，后台运行..."
    nohup serve -s "$TARGET_DIR" -l "$PORT" > serve.log 2>&1 &
    
    PID=$!
    log_info "服务已在后台启动！进程 PID: $PID"
    log_info "运行日志正在输出到: $(pwd)/serve.log"
    log_info "若需要关闭服务，请运行: kill $PID"
    log_warn "注意：本模式适合快速测试，生产环境强烈建议通过 Nginx 进行代理和部署！"
    
    log_title "极速托管启动成功！"
}

# ─── 主程序流程 ────────────────────────────────────────────────
if [ ! -f "dist-main.zip" ]; then
    log_err "未在当前目录下找到 dist-main.zip，请确保将 dist-main.zip 和本脚本放在同一目录下！"
    exit 1
fi

check_requirements

echo -e "\n请选择您的部署运行方案:"
echo -e "  [1] Nginx 宿主机部署 (推荐生产使用，性能极佳，支持反向代理)"
echo -e "  [2] Node.js serve 极速启动 (适合简单快速调试验证)"
echo -e "  [q] 退出"
read -p "请输入选项数字: " CHOICE

case "$CHOICE" in
    1)
        deploy_nginx_host
        ;;
    2)
        deploy_nodejs_serve
        ;;
    q|Q)
        log_info "已退出。"
        exit 0
        ;;
    *)
        log_err "无效的选项，程序退出。"
        exit 1
        ;;
esac
