FROM alpine
MAINTAINER Shengjing Zhu <zsj950618@gmail.com>¬

ENV QT_VER=5.7.0
ENV QT_DIST=/usr/local/Qt-$QT_VER \
    QT_BASE_SRC=https://download.qt.io/official_releases/qt/5.7/5.7.0/submodules/qtbase-opensource-src-$QT_VER.tar.xz \
    QT_BASE_DIR=qtbase-opensource-src-$QT_VER \
    QT_SCRIPT_SRC=https://download.qt.io/official_releases/qt/5.7/5.7.0/submodules/qtscript-opensource-src-$QT_VER.tar.xz \
    QT_SCRIPT_DIR=qtscript-opensource-src-$QT_VER \
    BUILD_DEP="bash build-base openssl-dev linux-headers curl git cmake" \
    QS_DIR=quassel \
    QS_DEP="libgcc libstdc++"

RUN set -x \
    && apk add --update $BUILD_DEP $QS_DEP \
    && curl -sSL $QT_BASE_SRC | tar xJ \
    && cd $QT_BASE_DIR \
      && bash ./configure -opensource -confirm-license -static -no-accessibility -qt-sql-sqlite -no-qml-debug \
        -no-gif -no-libpng -no-libjpeg -qt-doubleconversion -no-freetype -no-harfbuzz -openssl-linked -qt-pcre \
        -no-xkbcommon-evdev -no-xinput2 -no-xcb-xlib -no-glib -no-pulseaudio -no-alsa -no-gtk -no-compile-examples \
        -no-gui -no-dbus -nomake tools -nomake examples \
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
        && cp $QT_DIST/lib/libqtpcre.a staticlibs \
        && cmake . -DWANT_CORE=ON -DWANT_QTCLIENT=OFF -DWANT_MONO=OFF \
           -DUSE_QT5=ON -DWITH_KDE=OFF -DWITH_OXYGEN=OFF -DWITH_WEBKIT=OFF \
           -DHAVE_SSL=ON -DCMAKE_BUILD_TYPE=Release -DSTATIC=ON -DCMAKE_PREFIX_PATH=$QT_DIST \
        && make \
        && strip quasselcore \
        && install -m755 quasselcore /usr/local/bin \
        && cd .. \
    && rm -rf $QS_DIR $QT_BASE_DIR $QT_SCRIPT_DIR $QT_DIST \
    && apk del --purge $BUILD_DEP \
    && rm -rf /var/cache/apk/* \
    && mkdir /var/lib/quassel

USER root

VOLUME ["/var/lib/quassel"]

ENTRYPOINT ["quasselcore", "--configdir=/var/lib/quassel/"]

EXPOSE 4242
