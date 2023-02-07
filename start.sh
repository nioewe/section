#!/bin/sh

#tor &
/v2ray  run -config=/config.json &
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
