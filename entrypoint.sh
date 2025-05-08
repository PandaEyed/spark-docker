#!/bin/bash

: "${FRPS_ADDR:?Missing FRPS_ADDR}"
: "${FRPS_PORT:?Missing FRPS_PORT}"
: "${FRPS_TOKEN:?Missing FRPS_TOKEN}"

DEFAULT_PROXY_NAME="proxy_squid_$(hostname)"
PROXY_NAME=${PROXY_NAME:-$DEFAULT_PROXY_NAME}

REMOTE_PORT=${REMOTE_PORT:-7890}

cat > /etc/frp/frpc.ini <<EOF
[common]
server_addr = ${FRPS_ADDR}
server_port = ${FRPS_PORT}
token = ${FRPS_TOKEN}

[${PROXY_NAME}]
type = tcp
local_ip = 127.0.0.1
local_port = 3128
remote_port = ${REMOTE_PORT}
EOF

echo "[INFO] frpc.ini 已生成，代理名为 [${PROXY_NAME}]，映射端口为 ${REMOTE_PORT}"
echo "====== BEGIN frpc.ini ======"
cat /etc/frp/frpc.ini
echo "====== END frpc.ini ========"

exec /usr/bin/supervisord -n