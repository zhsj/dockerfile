FROM debian:bullseye-slim

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends dumb-init apt-cacher-ng ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo 'ForeGround: 1' >> /etc/apt-cacher-ng/docker.conf \
    && echo 'PassThroughPattern: .*' >> /etc/apt-cacher-ng/docker.conf \
    && ln -sf /dev/stdout /var/log/apt-cacher-ng/apt-cacher.out \
    && ln -sf /dev/stderr /var/log/apt-cacher-ng/apt-cacher.err

COPY entrypoint.sh /usr/sbin/entrypoint.sh

EXPOSE 3142/tcp

CMD ["dumb-init", "--", "apt-cacher-ng", "-c", "/etc/apt-cacher-ng"]
