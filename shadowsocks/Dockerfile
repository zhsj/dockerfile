FROM golang as builder

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends upx-ucl

RUN go env -w CGO_ENABLED=0
RUN go install -ldflags="-w -s" -v github.com/shadowsocks/v2ray-plugin@master
RUN upx /go/bin/v2ray-plugin

FROM alpine:3.13

RUN set -ex \
    && export SS_GIT=https://github.com/shadowsocks/shadowsocks-libev \
    && export SS_DIR=shadowsocks-libev \
    && apk upgrade --update \
    && apk add --virtual .ss-builddeps git cmake build-base \
       linux-headers libressl-dev libsodium-dev libsodium-static c-ares-dev c-ares-static \
       mbedtls-dev mbedtls-static libev-dev pcre-dev zlib-dev \
    && git clone --depth=1 --recursive $SS_GIT $SS_DIR \
    && cd $SS_DIR/build \
        && cmake -DWITH_STATIC=ON -DWITH_DOC_MAN=OFF -DWITH_DOC_HTML=OFF -DCMAKE_BUILD_TYPE=Release .. \
        && make \
        && strip bin/ss-server \
        && install -m755 bin/ss-server /usr/local/bin/ss-server \
        && cd ../.. \
        && rm -rf $SS_DIR \
    && apk del --purge .ss-builddeps \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*
COPY --from=builder /go/bin/v2ray-plugin /usr/local/bin/

EXPOSE 443 443/udp

COPY start.sh /usr/local/bin
CMD ["/usr/local/bin/start.sh"]
