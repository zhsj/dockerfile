FROM alpine
MAINTAINER Shengjing Zhu <zsj950618@gmail.com>¬

RUN set -ex \
    && export QT_VER=5.9.7 \
    && export QT_DIST=/usr/local/Qt-"$QT_VER" \
    && export QT_BASE_SRC=https://download.qt.io/official_releases/qt/"${QT_VER%.*}"/"$QT_VER"/submodules/qtbase-opensource-src-"$QT_VER".tar.xz \
    && export QT_BASE_DIR=qtbase-opensource-src-"$QT_VER" \
    && export QT_SCRIPT_SRC=https://download.qt.io/official_releases/qt/"${QT_VER%.*}"/"$QT_VER"/submodules/qtscript-opensource-src-"$QT_VER".tar.xz \
    && export QT_SCRIPT_DIR=qtscript-opensource-src-"$QT_VER" \
    && export QS_GIT=https://github.com/quassel/quassel.git \
    && export QS_DIR=quassel \
    && apk add --update --virtual .qs-deps libgcc libstdc++ \
    && apk add --virtual .qs-builddeps bash build-base openssl-dev boost-dev linux-headers curl git cmake \
    && curl -sSL $QT_BASE_SRC | tar xJ \
    && cd $QT_BASE_DIR \
      && bash ./configure -opensource -confirm-license -static -qt-sqlite -sql-sqlite \
         -no-accessibility -no-gui -no-widgets -no-dbus \
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
        && sed -i '1i#include <QtCore/QtPlugin>\nQ_IMPORT_PLUGIN(QSQLiteDriverPlugin)' src/main/main.cpp \
        && sed -i "s|Quassel::Core)|Quassel::Core $QT_DIST/plugins/sqldrivers/libqsqlite.a)|g" src/main/CMakeLists.txt \
        && echo 'target_link_libraries(${TARGET} PUBLIC '"$QT_DIST"'/lib/libqtpcre2.a)' >> src/common/CMakeLists.txt \
        && cmake . -DCMAKE_VERBOSE_MAKEFILE=ON -DWANT_CORE=ON -DWANT_QTCLIENT=OFF -DWANT_MONO=OFF \
           -DWITH_KDE=OFF -DWITH_OXYGEN=OFF -DWITH_BUNDLED_ICONS=OFF -DWITH_WEBKIT=OFF -DWITH_WEBENGINE=OFF \
           -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$QT_DIST \
        && make \
        && make install/strip \
        && cd .. \
    && rm -rf $QS_DIR $QT_BASE_DIR $QT_SCRIPT_DIR $QT_DIST \
    && apk del --purge .qs-builddeps \
    && rm -rf /var/cache/apk/* \
    && mkdir /var/lib/quassel

VOLUME ["/var/lib/quassel"]
CMD ["quasselcore", "--configdir=/var/lib/quassel/"]
EXPOSE 4242
