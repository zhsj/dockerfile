FROM alpine
MAINTAINER Shengjing Zhu <i@zhsj.me>

RUN set -ex \
    && export SS_GIT=https://github.com/shadowsocks/shadowsocks-libev \
    && export KCPTUN_PATH=github.com/xtaci/kcptun/server \
    && export SS_DIR=shadowsocks-libev \
    && apk upgrade --update \
    && apk add --virtual .ss-builddeps git cmake build-base linux-headers libressl-dev libsodium-dev c-ares-dev \
       mbedtls-dev mbedtls-static libev-dev pcre-dev zlib-dev \
       go \
    && apk add --virtual .ss-deps s6 \
    && git clone --recursive $SS_GIT $SS_DIR \
    && cd $SS_DIR/build \
        && cmake -DWITH_STATIC=ON -DWITH_DOC_MAN=OFF -DWITH_DOC_HTML=OFF -DCMAKE_BUILD_TYPE=Release .. \
        && make \
        && strip bin/ss-server \
        && install -m755 bin/ss-server /usr/local/bin/ss-server \
        && cd ../.. \
        && rm -rf $SS_DIR \
    && mkdir /gobuild \
        && export GOPATH=/gobuild \
        && go get -ldflags="-s -w" $KCPTUN_PATH \
        && install -m755 /gobuild/bin/server /usr/local/bin/kcptun-server \
        && rm -rf /gobuild /usr/lib/go/pkg \
    && rm -rf ~/.cache \
    && apk del --purge .ss-builddeps \
    && rm -rf /var/cache/apk/*

ADD files /usr/local/
EXPOSE 443 443/udp 444/udp

CMD ["s6-svscan", "/usr/local/etc/s6"]
