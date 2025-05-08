FROM debian:bullseye-slim

ARG TARGETARCH

RUN apt-get update && apt-get install -y --no-install-recommends \
    squid \
    supervisor \
    curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY frpc/linux_${TARGETARCH}/frpc /usr/local/bin/frpc
RUN chmod +x /usr/local/bin/frpc

COPY squid.conf /etc/squid/squid.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /app

EXPOSE 3128

ENTRYPOINT ["/entrypoint.sh"]