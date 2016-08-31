FROM alpine
MAINTAINER Shengjing Zhu <zsj950618@gmail.com>

RUN set -ex \
    && export SS_GIT=https://github.com/shadowsocks/shadowsocks-libev \
    && export SS_DIR=shadowsocks-libev \
    && apk add --update --virtual .ss-builddeps git autoconf build-base libtool linux-headers openssl-dev \
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
