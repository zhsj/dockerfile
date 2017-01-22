FROM alpine
MAINTAINER Shengjing Zhu <zsj950618@gmail.com>

RUN set -ex \
    && export SS_GIT=https://github.com/shadowsocks/shadowsocks-libev \
    && export SS_DIR=shadowsocks-libev \
    && apk upgrade --update \
    && apk add --virtual .ss-builddeps git autoconf automake build-base libtool linux-headers libressl-dev libsodium-dev udns-dev \
       libev-dev pcre-dev zlib-dev \
    && apk add --virtual .ss-deps udns \
    && git clone --recursive $SS_GIT $SS_DIR \
    && cd $SS_DIR \
        && ./autogen.sh \
        && ./configure --disable-documentation \
        && make \
        && cc src/ss_server*.o -Llibcork/.libs/ -Llibipset/.libs/ -Wl,-Bstatic -lcrypto -lsodium -lev -lipset -lcork -lpcre \
           -Wl,-Bdynamic -ludns -o src/ss-server-static \
        && strip src/ss-server-static \
        && install -m755 src/ss-server-static /usr/local/bin/ss-server \
        && cd .. \
        && rm -rf $SS_DIR \
    && apk del --purge .ss-builddeps \
    && rm -rf /var/cache/apk/*

EXPOSE 443 443/udp

CMD ss-server -s ${SERVER_ADDR:-0.0.0.0} \
              -p ${SERVER_PORT:-443} \
              -k ${PASSWORD:-$(hostname)} \
              -m ${METHOD:-chacha20} \
              -t ${TIMEOUT:-300} \
              -d ${DNS_ADDR:-8.8.8.8} \
              --fast-open -u -A
