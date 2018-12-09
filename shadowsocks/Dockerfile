FROM alpine
MAINTAINER Shengjing Zhu <i@zhsj.me>

RUN set -ex \
    && export SS_GIT=https://github.com/shadowsocks/shadowsocks-libev \
    && export SS_DIR=shadowsocks-libev \
    && apk upgrade --update \
    && apk add --virtual .ss-builddeps git cmake build-base linux-headers libressl-dev libsodium-dev c-ares-dev \
       mbedtls-dev mbedtls-static libev-dev pcre-dev zlib-dev \
    && git clone --recursive $SS_GIT $SS_DIR \
    && cd $SS_DIR/build \
        && cmake -DWITH_STATIC=ON -DWITH_DOC_MAN=OFF -DWITH_DOC_HTML=OFF -DCMAKE_BUILD_TYPE=Release .. \
        && make \
        && strip bin/ss-server \
        && install -m755 bin/ss-server /usr/local/bin/ss-server \
        && cd ../.. \
        && rm -rf $SS_DIR \
    && apk del --purge .ss-builddeps \
    && rm -rf /var/cache/apk/*

EXPOSE 443 443/udp

CMD ss-server -s ${SERVER_ADDR:-0.0.0.0} \
              -p ${SERVER_PORT:-443} \
              -k ${PASSWORD:-$(hostname)} \
              -m ${METHOD:-chacha20-ietf-poly1305} \
              -t ${TIMEOUT:-300} \
              -d ${DNS_ADDR:-8.8.8.8} \
              --fast-open -u
