FROM alpine
MAINTAINER Shengjing Zhu <zsj950618@gmail.com>

RUN set -ex \
    && export BINDVERSION=9.11.0-P2 \
    && apk upgrade --update \
    && apk add --virtual .bind9-builddeps build-base bash curl libressl-dev libcap-dev perl linux-headers bsd-compat-headers libxml2-dev go git musl-dev \
    && apk add --virtual .bind9-deps libxml2 libcap libgcc s6 \
    && curl -sSL https://ftp.isc.org/isc/bind9/$BINDVERSION/bind-$BINDVERSION.tar.gz | tar xz \
    && cd bind-$BINDVERSION \
       && CFLAGS="-O3" ./configure --enable-ipv6  --enable-filter-aaaa --enable-threads --prefix=/usr/local/bind9 --exec-prefix=/usr/local/bind9 \
       && make \
       && make install \
       && bash -c 'rm -rf /usr/local/bind9/{include,lib,share}' \
    && cd .. \
    && rm -rf bind-$BINDVERSION \
    && mkdir /gobuild \
       && export GOPATH=/gobuild \
       && go get github.com/adnanh/webhook \
       && strip /gobuild/bin/webhook \
       && install -m 755 /gobuild/bin/webhook /usr/local/bin/webhook \
       && rm -rf /gobuild /usr/lib/go \
    && apk del --purge .bind9-builddeps \
    && rm -rf /var/cache/apk/* \
    && /usr/local/bind9/sbin/rndc-confgen -a -r /dev/urandom \
    && echo 'include "/etc/bind/named.conf";' > /usr/local/bind9/etc/named.conf

ADD files /etc/
VOLUME /etc/bind/
EXPOSE 53/udp 53/tcp 9000/tcp
CMD ["s6-svscan", "/etc/s6"]
