#!/bin/sh

set -ex

set -- ss-server -s "${SERVER_ADDR:-0.0.0.0}" -p "${SERVER_PORT:-443}" \
    -k "${PASSWORD:-$(hostname)}" -m "${METHOD:-chacha20-ietf-poly1305}" \
    -t "${TIMEOUT:-300}" -d "${DNS_ADDR:-8.8.8.8}" -u

if [ -n "$V2RAY_PATH" ]; then
  set -- "$@" --plugin /usr/local/bin/v2ray-plugin \
      --plugin-opts "server;path=$V2RAY_PATH;"
fi

exec "$@"
