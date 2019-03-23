FROM alpine
MAINTAINER Shengjing Zhu <i@zhsj.me>

RUN set -ex \
    && apk upgrade --update \
    && apk add --virtual .sks-deps db-utils gmp libgcc s6 \
    && apk add --virtual .sks-builddeps \
        build-base curl m4 opam patch perl \
        db-dev gmp-dev zlib-dev \
    && opam init --auto-setup --disable-sandboxing -y \
    && opam switch create 4.04.2 \
    && eval `opam env` \
    && opam install -y cryptokit num camlp4 \
    && curl -sSL https://bitbucket.org/skskeyserver/sks-keyserver/get/default.tar.gz | tar xz \
    && mv skskeyserver* sks-keyserver \
    && cd sks-keyserver \
        && sed 's/db-.*/db-5.3/' Makefile.local.unused > Makefile.local \
        && sed -i '/warn-error/d' Makefile \
        && curl -sSL https://git.io/fNYQz | patch -p1 \
        && make dep \
        && make sks \
        && strip sks \
        && install -m755 sks /usr/local/bin/sks \
        && cd .. \
        && rm -rf sks-keyserver \
    && apk --purge del .sks-builddeps \
    && rm -rf /var/cache/apk/* \
    && rm -rf ~/.opam \
    && rm -rf ~/.cache/ ~/.gitconfig ~/.profile \
    && mkdir -p /var/lib/sks

ADD files /usr/local/
VOLUME /var/lib/sks
EXPOSE 11371 11370
CMD ["s6-svscan", "/usr/local/etc/s6"]
