FROM debian:bullseye-slim

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends openssh-server busybox s6 \
    && rm -rf /var/lib/apt/lists/*

ADD files /usr/local/etc

EXPOSE 22/tcp
CMD ["s6-svscan", "/usr/local/etc/s6"]
