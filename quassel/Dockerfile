FROM alpine
MAINTAINER Shengjing Zhu <zsj950618@gmail.com>¬

ENV QS_VER=0.12.4
ENV QS_URL=https://github.com/quassel/quassel/archive/$QS_VER.tar.gz \
    QS_DIR=quassel-$QS_VER \
    QS_BUILD_DEP="curl cmake build-base qt5-qtbase-dev qt5-qtscript-dev" \
    QS_DEP="qt5-qtbase qt5-qtbase-sqlite qt5-qtscript"

RUN set -ex \
    && apk add --update $QS_DEP $QS_BUILD_DEP \
    && curl -sSL $QS_URL | tar xz \
    && cd $QS_DIR \
        && cmake . -DWANT_CORE=ON -DWANT_QTCLIENT=OFF -DWANT_MONO=OFF \
           -DUSE_QT5=ON -DWITH_KDE=OFF -DWITH_OXYGEN=OFF -DWITH_WEBKIT=OFF \
           -DHAVE_SSL=ON \
        && make \
        && make install \
        && cd .. \
        && rm -rf $QS_DIR \
    && apk del --purge $QS_BUILD_DEP \
    && rm -rf /var/cache/apk/* \
    && mkdir /var/lib/quassel

USER root

VOLUME ["/var/lib/quassel"]

ENTRYPOINT ["quasselcore", "--configdir=/var/lib/quassel/"]

EXPOSE 4242
