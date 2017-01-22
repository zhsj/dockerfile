FROM alpine
MAINTAINER Shengjing Zhu <zsj950618@gmail.com>

RUN set -ex \
    && export SS_GIT=https://github.com/shadowsocks/shadowsocks-libev \
    && export KCPTUN_PATH=github.com/xtaci/kcptun/server \
    && export SS_DIR=shadowsocks-libev \
    && apk upgrade --update \
    && apk add --virtual .ss-builddeps git autoconf automake build-base libtool linux-headers libressl-dev libsodium-dev udns-dev \
       libev-dev pcre-dev zlib-dev \
       go \
    && apk add --virtual .ss-deps udns \
       s6 \
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
    && mkdir /go \
        && export GOPATH=/go \
        && go get $KCPTUN_PATH \
        && strip /go/bin/server \
        && install -m755 /go/bin/server /usr/local/bin/kcptun-server \
        && rm -rf /go \
        && rm -rf /usr/lib/go/pkg \
    && apk del --purge .ss-builddeps \
    && rm -rf /var/cache/apk/*

ADD files /usr/local/
EXPOSE 443 443/udp 444/udp

CMD ["s6-svscan", "/usr/local/etc/s6"]
