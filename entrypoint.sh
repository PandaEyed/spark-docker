#!/bin/bash

# 确保 frpc.ini 目录存在
mkdir -p /etc/frp

# 检查必要环境变量
: "${FRPS_ADDR:?Missing FRPS_ADDR}"
: "${REMOTE_PORT:?Missing REMOTE_PORT}"

# 自动生成唯一的代理名称
DEFAULT_PROXY_NAME="proxy_squid_$(hostname)"
PROXY_NAME=${PROXY_NAME:-$DEFAULT_PROXY_NAME}

# 写入配置文件
cat > /etc/frp/frpc.ini <<EOF
[common]
server_addr = ${FRPS_ADDR}
server_port = 7000
token = qaz123!@#

[${PROXY_NAME}]
type = tcp
local_ip = 127.0.0.1
local_port = 3128
remote_port = ${REMOTE_PORT}
EOF

echo "[INFO] frpc.ini 已生成，目标 FRPS 为 [${FRPS_ADDR}],代理名为 [${PROXY_NAME}]，映射端口为 ${REMOTE_PORT}"
echo "====== BEGIN frpc.ini ======"
cat /etc/frp/frpc.ini
echo "====== END frpc.ini ========"

# 启动服务
exec /usr/bin/supervisord -n