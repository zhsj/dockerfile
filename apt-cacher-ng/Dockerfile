FROM debian:bullseye-slim

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends apt-cacher-ng ca-certificates dumb-init \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo 'ForeGround: 1' >> /etc/apt-cacher-ng/docker.conf \
    && echo 'PassThroughPattern: .*' >> /etc/apt-cacher-ng/docker.conf \
    && chown apt-cacher-ng:apt-cacher-ng /run/apt-cacher-ng

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
EXPOSE 3142/tcp
VOLUME /var/cache/apt-cacher-ng
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["apt-cacher-ng", "-c", "/etc/apt-cacher-ng"]
