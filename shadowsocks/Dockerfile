FROM alpine:edge
MAINTAINER Shengjing Zhu <zsj950618@gmail.com>

RUN set -ex \
    && export SS_GIT=https://github.com/shadowsocks/shadowsocks-libev \
    && export SS_DIR=shadowsocks-libev \
    && apk upgrade --update \
    && apk add --virtual .ss-builddeps git autoconf build-base libtool linux-headers libressl-dev pcre-dev zlib-dev \
    && apk add --virtual .ss-deps pcre \
    && git clone $SS_GIT $SS_DIR \
    && cd $SS_DIR \
        && ./configure --disable-documentation \
        && make \
        && strip src/ss-server \
        && install -m755 src/ss-server /usr/local/bin/ \
        && cd .. \
        && rm -rf $SS_DIR \
    && apk del --purge .ss-builddeps \
    && rm -rf /var/cache/apk/*

EXPOSE 443 443/udp

CMD ss-server -s ${SERVER_ADDR:-0.0.0.0} \
              -p ${SERVER_PORT:-8388} \
              -k ${PASSWORD:-$(hostname)} \
              -m ${METHOD:-chacha20} \
              -t ${TIMEOUT:-300} \
              -d ${DNS_ADDR:-8.8.8.8} \
              --fast-open -u -A
