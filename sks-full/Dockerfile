FROM alpine
MAINTAINER Shengjing Zhu <i@zhsj.me>

RUN set -ex \
    && apk upgrade --update \
    && apk add --virtual .sks-deps db-utils gmp libgcc s6 \
        ca-certificates \
    && apk add --virtual .sks-builddeps \
        build-base curl m4 opam patch perl \
        db-dev gmp-dev zlib-dev \
        git go \
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
    && export GOPATH=/gocode \
    && mkdir "$GOPATH" \
        && export CADDY_TAG=v0.11.4 \
        && go get -d github.com/mholt/caddy \
        && go get -d github.com/nicolasazrak/caddy-cache \
        && cd $GOPATH/src/github.com/mholt/caddy \
        && git checkout $CADDY_TAG \
        && git config --global user.email "user@example.com" \
        && curl -sSL https://github.com/mholt/caddy/pull/2477.patch | git am \
        && sed -i 's|var EnableTelemetry = true|var EnableTelemetry = false|g' caddy/caddymain/run.go \
        && sed -i 's|// This is.*|_ "github.com/nicolasazrak/caddy-cache"|g' caddy/caddymain/run.go \
        && go install -ldflags="-s -w -X github.com/mholt/caddy/caddy/caddymain.gitTag=$CADDY_TAG" github.com/mholt/caddy/caddy \
        && install -m755 $GOPATH/bin/caddy /usr/local/bin/caddy \
        && cd .. \
        && rm -rf "$GOPATH" \
    && apk --purge del .sks-builddeps \
    && rm -rf /var/cache/apk/* \
    && rm -rf ~/.opam \
    && rm -rf ~/.cache/ ~/.gitconfig ~/.profile \
    && mkdir -p /var/lib/sks

ADD files /usr/local/
VOLUME /var/lib/sks
EXPOSE 80 443 11371 11370
CMD ["s6-svscan", "/usr/local/etc/s6"]
