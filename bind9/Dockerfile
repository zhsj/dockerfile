FROM alpine:3.14

RUN set -ex \
    && export BIND_VERSION=9.16.38 \
    && apk upgrade --update \
    && apk add --virtual .bind9-builddeps build-base bash curl python3 py3-ply git go perl upx \
       bsd-compat-headers json-c-dev libcap-dev libuv-dev libxml2-dev linux-headers openssl-dev musl-dev \
    && apk add --virtual .bind9-deps json-c libcap libgcc libuv libxml2 s6 \
    && curl -sSL https://ftp.isc.org/isc/bind9/$BIND_VERSION/bind-$BIND_VERSION.tar.xz | tar xJ \
       && cd bind-$BIND_VERSION \
       && CFLAGS="-O3" ./configure --prefix=/usr/local/bind9 --exec-prefix=/usr/local/bind9 \
          --with-libxml2 --with-libjson --with-libtool --enable-static=no \
          --enable-full-report \
       && make \
       && make install \
       && bash -c 'rm -rf /usr/local/bind9/{include,share}' \
       && bash -c 'rm -rf /usr/local/bind9/lib/{*.la,python3*}' \
       && bash -c 'strip /usr/local/bind9/{bin,sbin,lib}/* || exit 0' \
       && cd .. \
       && rm -rf bind-$BIND_VERSION \
    && git clone --branch=2.8.0 https://github.com/adnanh/webhook \
       && cd /webhook \
       && go build -ldflags="-s -w" -o /usr/local/bin/webhook . \
       && upx /usr/local/bin/webhook \
       && cd .. \
       && rm -rf webhook ~/go /usr/lib/go \
    && apk del --purge .bind9-builddeps \
    && rm -rf /usr/lib/python3* \
    && rm -rf ~/.cache \
    && rm -rf /var/cache/apk/* \
    && echo 'include "/etc/bind/named.conf";' > /usr/local/bind9/etc/named.conf

ADD files /etc/
VOLUME /etc/bind/
EXPOSE 53/udp 53/tcp 9000/tcp
CMD ["s6-svscan", "/etc/s6"]
