FROM alpine
MAINTAINER Shengjing Zhu <zsj950618@gmail.com>¬

RUN set -ex \
    && export QT_VER=5.9.2 \
    && export QT_DIST=/usr/local/Qt-"$QT_VER" \
    && export QT_BASE_SRC=https://download.qt.io/official_releases/qt/"${QT_VER%.*}"/"$QT_VER"/submodules/qtbase-opensource-src-"$QT_VER".tar.xz \
    && export QT_BASE_DIR=qtbase-opensource-src-"$QT_VER" \
    && export QT_SCRIPT_SRC=https://download.qt.io/official_releases/qt/"${QT_VER%.*}"/"$QT_VER"/submodules/qtscript-opensource-src-"$QT_VER".tar.xz \
    && export QT_SCRIPT_DIR=qtscript-opensource-src-"$QT_VER" \
    && export QS_GIT=https://github.com/quassel/quassel.git \
    && export QS_DIR=quassel \
    && apk add --update --virtual .qs-deps libgcc libstdc++ \
    && apk add --virtual .qs-builddeps bash build-base openssl-dev linux-headers curl git cmake \
    && curl -sSL $QT_BASE_SRC | tar xJ \
    && cd $QT_BASE_DIR \
      && bash ./configure -opensource -confirm-license -static -qt-sqlite -sql-sqlite \
         -no-accessibility -no-qml-debug -no-gui -no-widgets -no-dbus \
         -no-compile-examples -nomake tools -nomake examples \
      && make install \
      && cd .. \
    && curl -sSL $QT_SCRIPT_SRC | tar xJ \
    && cd $QT_SCRIPT_DIR \
      && $QT_DIST/bin/qmake \
      && make install \
      && cd .. \
    && git clone $QS_GIT $QS_DIR \
    && cd $QS_DIR \
        && mkdir staticlibs \
        && cp $QT_DIST/plugins/sqldrivers/libqsqlite.a staticlibs/ \
        && cp $QT_DIST/lib/libqtpcre2.a staticlibs/ \
        && cmake . -DWANT_CORE=ON -DWANT_QTCLIENT=OFF -DWANT_MONO=OFF \
           -DUSE_QT5=ON -DWITH_KDE=OFF -DWITH_OXYGEN=OFF -DWITH_WEBKIT=OFF \
           -DHAVE_SSL=ON -DCMAKE_BUILD_TYPE=Release -DSTATIC=ON -DCMAKE_PREFIX_PATH=$QT_DIST \
           -DLINK_EXTRA='qsqlite;qtpcre2' \
        && make \
        && strip quasselcore \
        && install -m755 quasselcore /usr/local/bin \
        && cd .. \
    && rm -rf $QS_DIR $QT_BASE_DIR $QT_SCRIPT_DIR $QT_DIST \
    && apk del --purge .qs-builddeps \
    && rm -rf /var/cache/apk/* \
    && mkdir /var/lib/quassel

VOLUME ["/var/lib/quassel"]
ENTRYPOINT ["quasselcore", "--configdir=/var/lib/quassel/"]
EXPOSE 4242
