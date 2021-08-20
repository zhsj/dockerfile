FROM debian:bullseye-slim

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends exim4 s6 logrotate \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/spool/exim4 /var/log/exim4 \
    && mkdir /data \
    && chown Debian-exim:Debian-exim /data

EXPOSE 25/tcp
VOLUME /data

ADD files /usr/local/etc
CMD ["s6-svscan", "/usr/local/etc/s6"]
