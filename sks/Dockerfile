FROM alpine:3.7
MAINTAINER Shengjing Zhu <i@zhsj.me>

RUN set -ex \
    && apk upgrade --update \
    && apk add --virtual .sks-deps db-utils libgcc gmp s6 \
    && apk add --virtual .sks-builddeps \
        build-base curl db-dev patch m4 perl gmp-dev zlib-dev \
        opam \
    && opam init --auto-setup -y \
    && eval `opam config env` \
    && opam install -y cryptokit num \
    && curl -sSL https://bitbucket.org/skskeyserver/sks-keyserver/get/default.tar.gz | tar xz \
    && mv skskeyserver* sks-keyserver \
    && cd sks-keyserver \
        && sed 's/db-.*/db-5.3/' Makefile.local.unused > Makefile.local \
        && sed -i '/warn-error/d' Makefile \
        && curl -sSL https://git.io/fNYQz | patch -p1 \
        && make dep \
        && make sks \
        && strip sks \
        && install -m755 sks /usr/sbin/sks \
        && cd .. \
        && rm -rf sks-keyserver \
    && rm -rf ~/.opam \
    && rm ~/.ocamlinit \
    && apk --purge del .sks-builddeps \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /var/lib/sks

ADD files /usr/local/
VOLUME /var/lib/sks
EXPOSE 11371 11370
CMD ["s6-svscan", "/usr/local/etc/s6"]
