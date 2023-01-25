FROM debian:bullseye-slim

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       dumb-init rootlesskit slirp4netns \
       iptables iproute2 ca-certificates \
       containerd runc \
    && rm -rf \
       /usr/bin/rootlessctl \
       /usr/bin/containerd-shim-runc-v1 \
       /usr/bin/containerd-shim \
       /usr/bin/ctr \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV DOCKER_VERSION=20.10.23
RUN set -ex \
    && /usr/lib/apt/apt-helper download-file "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" /docker.tgz \
    && tar -xz -f /docker.tgz --strip-components=1 -C /usr/local/bin docker/dockerd \
    && rm -f /docker.tgz

ADD ./dockerd-entrypoint.sh /usr/local/bin

RUN set -ex \
    && mkdir /run/user \
    && chmod 1777 /run/user \
    && adduser --home /home/rootless --gecos 'Rootless' --disabled-password --uid 1000 rootless \
    && mkdir -p /home/rootless/.local/share/docker \
    && chown -R rootless:rootless /home/rootless

VOLUME /home/rootless/.local/share/docker

EXPOSE 2375
ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh"]
CMD []
