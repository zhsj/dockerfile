FROM alpine
MAINTAINER Shengjing Zhu <i@zhsj.me>

RUN set -ex \
    && export BINDVERSION=9.16.0 \
    && apk upgrade --update \
    && apk add --virtual .bind9-builddeps build-base bash curl python3 git go perl upx \
       bsd-compat-headers json-c-dev libcap-dev libuv-dev libxml2-dev linux-headers openssl-dev musl-dev \
    && apk add --virtual .bind9-deps json-c libcap libgcc libuv libxml2 s6 \
    && python3 -m pip install ply \
    && curl -sSL https://ftp.isc.org/isc/bind9/$BINDVERSION/bind-$BINDVERSION.tar.xz | tar xJ \
    && cd bind-$BINDVERSION \
       && CFLAGS="-O3" ./configure --prefix=/usr/local/bind9 --exec-prefix=/usr/local/bind9 \
          --with-libxml2 --with-libjson --with-libtool --enable-static=no \
          --enable-full-report \
       && make \
       && make install \
       && bash -c 'rm -rf /usr/local/bind9/{include,share}' \
       && bash -c 'rm -rf /usr/local/lib/{*.la,python3*}' \
       && bash -c 'strip /usr/local/bind9/{bin,sbin,lib}/* || exit 0' \
    && cd .. \
    && rm -rf bind-$BINDVERSION \
    && mkdir /gobuild \
       && export GOPATH=/gobuild \
       && go get -ldflags="-s -w" github.com/adnanh/webhook \
       && install -m 755 /gobuild/bin/webhook /usr/local/bin/webhook \
       && upx /usr/local/bin/webhook \
       && rm -rf /gobuild /usr/lib/go \
    && apk del --purge .bind9-builddeps \
    && rm -rf /usr/lib/python3* \
    && rm -rf ~/.cache \
    && rm -rf /var/cache/apk/* \
    && echo 'include "/etc/bind/named.conf";' > /usr/local/bind9/etc/named.conf

ADD files /etc/
VOLUME /etc/bind/
EXPOSE 53/udp 53/tcp 9000/tcp
CMD ["s6-svscan", "/etc/s6"]
