FROM alpine:edge
MAINTAINER Shengjing Zhu <zsj950618@gmail.com>

RUN set -ex \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk pgrade --update \
    && apk add --virtual .sks-deps db-utils libgcc s6 \
    && apk add --virtual .sks-builddeps \
        build-base camlp4 curl db-dev zlib-dev \
    && curl -sSL https://bitbucket.org/skskeyserver/sks-keyserver/get/1.1.6.tar.gz | tar xz \
    && mv skskeyserver* sks-keyserver \
    && cd sks-keyserver \
        && sed 's/db-.*/db-5.3/' Makefile.local.unused > Makefile.local \
        && make dep \
        && make cryptokit-1.7/README.txt \
        && sed -i 's/uint32/uint32_t/g' cryptokit-1.7/src/stubs-md5.c \
        && make sks \
        && strip sks \
        && install -m755 sks /usr/sbin/sks \
    && cd .. \
    && apk --purge del .sks-builddeps \
    && rm -rf /var/cache/apk/* \
    && rm -rf sks-keyserver \
    && mkdir -p /var/lib/sks

ADD files /
VOLUME /var/lib/sks
EXPOSE 11371 11370
CMD /start.sh
