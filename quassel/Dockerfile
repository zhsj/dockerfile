FROM alpine

RUN set -ex \
    && export QT_VER=5.13.2 \
    && export QT_DIST=/usr/local/Qt-"$QT_VER" \
    && export QT_BASE_SRC=https://download.qt.io/official_releases/qt/"${QT_VER%.*}"/"$QT_VER"/submodules/qtbase-everywhere-src-"$QT_VER".tar.xz \
    && export QT_BASE_DIR=qtbase-everywhere-src-"$QT_VER" \
    && export QT_SCRIPT_SRC=https://download.qt.io/official_releases/qt/"${QT_VER%.*}"/"$QT_VER"/submodules/qtscript-everywhere-src-"$QT_VER".tar.xz \
    && export QT_SCRIPT_DIR=qtscript-everywhere-src-"$QT_VER" \
    && export QS_GIT=https://github.com/quassel/quassel.git \
    && export QS_DIR=quassel \
    && apk add --update --virtual .qs-deps libgcc libssl1.1 libstdc++ zlib su-exec \
    && apk add --virtual .qs-builddeps build-base bash cmake curl git perl \
       boost-dev linux-headers openssl-dev zlib-dev \
    && curl -sSL $QT_BASE_SRC | tar xJ \
    && cd $QT_BASE_DIR \
      && bash ./configure -opensource -confirm-license -shared -qt-sqlite -sql-sqlite \
         -no-accessibility -no-gui -no-widgets -no-dbus \
         -no-compile-examples -nomake tools -nomake examples \
      && make \
      && make install \
      && cd .. \
    && curl -sSL $QT_SCRIPT_SRC | tar xJ \
    && cd $QT_SCRIPT_DIR \
      && $QT_DIST/bin/qmake \
      && make \
      && make install \
      && cd .. \
    && git clone $QS_GIT $QS_DIR \
    && cd $QS_DIR \
        && sed -i '/CMAKE_AUTOUIC/d' CMakeLists.txt \
        && cmake . -DCMAKE_VERBOSE_MAKEFILE=ON -DWANT_CORE=ON -DWANT_QTCLIENT=OFF -DWANT_MONO=OFF \
           -DWITH_KDE=OFF -DWITH_BUNDLED_ICONS=OFF -DWITH_WEBKIT=OFF -DWITH_WEBENGINE=OFF \
           -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$QT_DIST \
        && make \
        && make install/strip \
        && cd .. \
    && rm -rf $QS_DIR $QT_BASE_DIR $QT_SCRIPT_DIR \
    && rm -rf /usr/local/lib64/*.so \
    && cd $QT_DIST \
       && rm -rf bin doc include mkspecs plugins/bearer \
       && rm -rf lib/cmake lib/pkgconfig lib/*.a lib/*.la lib/*.prl \
       && rm -rf lib/libQt5Concurrent.so* lib/libQt5Test.so* lib/libQt5Xml.so* lib/*.so \
       && rm -rf lib/libQt5Script.so* \
    && apk del --purge .qs-builddeps \
    && rm -rf /var/cache/apk/* \
    && mkdir /var/lib/quassel \
    && adduser -h /var/lib/quassel -s /sbin/nologin -u 1000 -D -H quassel \
    && chown -R quassel:quassel /var/lib/quassel

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
EXPOSE 4242
VOLUME ["/var/lib/quassel"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["quasselcore", "--configdir=/var/lib/quassel/"]
