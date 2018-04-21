FROM alpine
MAINTAINER Shengjing Zhu <i@zhsj.me>

RUN set -ex \
    && apk upgrade --update \
    && apk add --virtual .sks-deps db-utils libgcc gmp s6 ca-certificates \
    && apk add --virtual .sks-builddeps \
        build-base opam curl git go db-dev patch m4 perl gmp-dev zlib-dev \
    && opam init --no-setup -y \
    && opam install -y cryptokit \
    && export PATH=~/.opam/system/bin/:$PATH \
    && curl -sSL https://bitbucket.org/skskeyserver/sks-keyserver/get/default.tar.gz | tar xz \
    && mv skskeyserver* sks-keyserver \
    && cd sks-keyserver \
        && sed 's/db-.*/db-5.3/' Makefile.local.unused > Makefile.local \
        && sed -i '/warn-error/d' Makefile \
        && make dep \
        && make sks \
        && strip sks \
        && install -m755 sks /usr/sbin/sks \
        && cd .. \
        && rm -rf sks-keyserver \
    && rm -rf ~/.opam \
    && mkdir /gobuild \
        && export GOPATH=/gobuild \
        && go get -d github.com/mholt/caddy \
        && go get -d github.com/caddyserver/builds \
        && cd $GOPATH/src/github.com/mholt/caddy \
        && CADDY_TAG=$(git describe --tags `git rev-list --tags --max-count=1`) \
        && git checkout $CADDY_TAG \
        && go install -ldflags="-s -w -X github.com/mholt/caddy/caddy/caddymain.gitTag=$CADDY_TAG" github.com/mholt/caddy/caddy \
        && install -m755 $GOPATH/bin/caddy /usr/bin/caddy \
        && cd \
        && rm -rf /gobuild \
    && apk --purge del .sks-builddeps \
    && rm -rf /var/cache/apk/* \
    && mkdir -p /var/lib/sks

ADD files /usr/local/
VOLUME /var/lib/sks
EXPOSE 80 443 11371 11370
CMD ["s6-svscan", "/usr/local/etc/s6"]
