FROM alpine:edge
MAINTAINER Shengjing Zhu <zsj950618@gmail.com>

RUN set -ex \
    && export SS_GIT=https://github.com/shadowsocks/shadowsocks-libev \
    && export KCPTUN_PATH=github.com/xtaci/kcptun/server \
    && export SS_DIR=shadowsocks-libev \
    && apk upgrade --update \
    && apk add --virtual .ss-builddeps git autoconf build-base libtool linux-headers libressl-dev pcre-dev zlib-dev go \
    && apk add --virtual .ss-deps pcre s6 \
    && git clone $SS_GIT $SS_DIR \
    && cd $SS_DIR \
        && ./configure --disable-documentation \
        && make \
        && strip src/ss-server \
        && install -m755 src/ss-server /usr/local/bin/ \
        && cd .. \
        && rm -rf $SS_DIR \
    && mkdir /go \
        && export GOPATH=/go \
        && go get $KCPTUN_PATH \
        && strip /go/bin/server \
        && install -m755 /go/bin/server /usr/local/bin/kcptun-server \
        && rm -rf /go \
    && apk del --purge .ss-builddeps \
    && rm -rf /var/cache/apk/*

ADD files /
EXPOSE 443 443/udp 444/udp

CMD s6-svscan /etc/s6
