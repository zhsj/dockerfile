FROM alpine:3.13

RUN set -ex \
    && export SS_GIT=https://github.com/shadowsocks/shadowsocks-libev \
    && export V2RAY_GIT=https://github.com/shadowsocks/v2ray-plugin \
    && export SS_DIR=shadowsocks-libev \
    && export V2RAY_DIR=v2ray-plugin \
    && apk upgrade --update \
    && apk add --virtual .ss-builddeps git cmake build-base go upx \
       linux-headers libressl-dev libsodium-dev libsodium-static c-ares-dev c-ares-static \
       mbedtls-dev mbedtls-static libev-dev pcre-dev zlib-dev \
    && git clone --recursive $SS_GIT $SS_DIR \
    && cd $SS_DIR/build \
        && cmake -DWITH_STATIC=ON -DWITH_DOC_MAN=OFF -DWITH_DOC_HTML=OFF -DCMAKE_BUILD_TYPE=Release .. \
        && make \
        && strip bin/ss-server \
        && install -m755 bin/ss-server /usr/local/bin/ss-server \
        && cd ../.. \
        && rm -rf $SS_DIR \
    && git clone $V2RAY_GIT $V2RAY_DIR \
    && cd $V2RAY_DIR \
       && go build -ldflags="-s -w" -o /usr/local/bin/v2ray-plugin . \
       && upx /usr/local/bin/v2ray-plugin \
       && cd .. \
       && rm -rf $V2RAY_DIR \
    && rm -rf ~/go /usr/lib/go \
    && rm -rf ~/.cache \
    && apk del --purge .ss-builddeps \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*

EXPOSE 443 443/udp

COPY start.sh /usr/local/bin
CMD ["/usr/local/bin/start.sh"]
