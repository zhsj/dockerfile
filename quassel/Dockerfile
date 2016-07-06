FROM alpine
MAINTAINER Shengjing Zhu <zsj950618@gmail.com>¬

ENV QS_GIT=https://github.com/quassel/quassel \
    QS_DIR=quassel \
    QS_BUILD_DEP="git cmake build-base qt5-qtbase-dev qt5-qtscript-dev" \
    QS_DEP="qt5-qtbase qt5-qtbase-sqlite qt5-qtscript"

RUN set -x \
    && apk add --update $QS_DEP $QS_BUILD_DEP \
    && git clone $QS_GIT $QS_DIR \
    && cd $QS_DIR \
        && cmake . -DWANT_CORE=ON -DWANT_QTCLIENT=OFF -DWANT_MONO=OFF \
           -DUSE_QT5=ON -DWITH_KDE=OFF -DWITH_OXYGEN=OFF -DWITH_WEBKIT=OFF \
           -DHAVE_SSL=ON -DCMAKE_BUILD_TYPE=Release \
        && make \
        && strip quasselcore \
        && install -m755 quasselcore /usr/local/bin \
        && cd .. \
        && rm -rf $QS_DIR \
    && apk del --purge $QS_BUILD_DEP \
    && rm -rf /var/cache/apk/* \
    && mkdir /var/lib/quassel

USER root

VOLUME ["/var/lib/quassel"]

ENTRYPOINT ["quasselcore", "--configdir=/var/lib/quassel/"]

EXPOSE 4242
