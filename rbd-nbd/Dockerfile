From debian:stretch-slim
MAINTAINER Shengjing Zhu <i@zhsj.me>

RUN set -x \
    && apt -y update \
    && apt -y upgrade \
    && apt -y install gnupg kmod \
    && touch /etc/apt/trusted.gpg.d/ceph.gpg \
    && mkdir --mode=700 ~/.gnupg/ \
    && gpg --no-default-keyring --keyring=/etc/apt/trusted.gpg.d/ceph.gpg --recv-key 0xE84AC2C0460F3994 \
    && echo "deb http://download.ceph.com/debian-kraken/ xenial main" > /etc/apt/sources.list.d/ceph.list \
    && apt -y update \
    && apt -y install rbd-nbd \
    && apt -y purge --auto-remove gnupg \
    && rm -rf ~/.gnupg/ \
    && apt -y clean
