FROM alpine:edge

ARG AUUID="aa0607f5-6546-45f8-96ce-45e7e7e38cf8"
ARG CADDYIndexPage="https://github.com/kkkewd/Html/raw/main/wow-portfolio-multi-purpose-html5.zip"
ARG ParameterSSENCYPT="chacha20-ietf-poly1305"
ARG PORT=8000

ADD etc/Caddyfile /tmp/Caddyfile
ADD etc/config.json /tmp/config.json
ADD start.sh /start.sh

RUN apk update && \
    apk add --no-cache ca-certificates caddy wget && \
    wget -O v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip && \
    unzip v2ray.zip && \
    chmod +x /v2ray && \
    rm -rf /var/cache/apk/* && \
    rm -f v2ray.zip && \
    mkdir -p /etc/caddy/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt && \
    wget $CADDYIndexPage -O /usr/share/caddy/index.html && unzip -qo /usr/share/caddy/index.html -d /usr/share/caddy/ && mv /usr/share/caddy/*/* /usr/share/caddy/ && \
    cat /tmp/Caddyfile | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $AUUID)/g" >/etc/caddy/Caddyfile && \
    cat /tmp/config.json | sed -e "s/\$AUUID/$AUUID/g" -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" >/config.json

RUN chmod +x /start.sh

CMD /start.sh
