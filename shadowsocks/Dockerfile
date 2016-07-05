FROM alpine
MAINTAINER Shengjing Zhu <zsj950618@gmail.com>

ENV SS_GIT=https://github.com/shadowsocks/shadowsocks-libev \
    SS_DIR=shadowsocks-libev \
    SS_BUILD_DEP="git autoconf build-base curl libtool linux-headers openssl-dev"

RUN set -x \
    && apk add --update $SS_BUILD_DEP \
    && git clone $SS_GIT $SS_DIR \
    && cd $SS_DIR \
        && ./configure --disable-documentation \
        && make \
        && install -m755 src/ss-server /usr/local/bin/
        && cd .. \
        && rm -rf $SS_DIR \
    && apk del --purge $SS_DEP \
    && rm -rf /var/cache/apk/*

ENV SERVER_ADDR=0.0.0.0 \
    SERVER_PORT=8388 \
    PASSWORD= \
    METHOD=chacha20 \
    TIMEOUT=300 \
    DNS_ADDR=8.8.8.8

EXPOSE $SERVER_PORT $SERVER_PORT/udp

CMD ss-server -s $SERVER_ADDR \
              -p $SERVER_PORT \
              -k ${PASSWORD:-$(hostname)} \
              -m $METHOD \
              -t $TIMEOUT \
              -d $DNS_ADDR \
              --fast-open -u -A
