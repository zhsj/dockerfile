FROM golang as builder
COPY ./helper /go/src/helper
RUN cd /go/src/helper/ \
    && go build -ldflags="-w -s" -trimpath -o /go/bin/gha-helper .

FROM debian:bullseye-slim

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       curl \
       git \
       git-lfs \
       s6 \
       sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && adduser --home /home/runner --gecos 'Runner' --disabled-password --uid 1000 runner \
    && echo "runner ALL= EXEC: NOPASSWD:ALL" >> /etc/sudoers.d/runner

ENV DOCKER_VERSION=20.10.21
RUN set -ex \
    && curl -sSL "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" | \
         tar -xz --strip-components=1 -C /usr/local/bin docker/docker

ENV RUNNER_VERSION=2.299.1
RUN set -ex \
    && curl -sL "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" | \
         tar -xz -C /home/runner \
    && /home/runner/bin/installdependencies.sh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/gha-helper /usr/local/bin/
ADD --chown=runner:runner files /home/runner

USER runner
WORKDIR /home/runner
CMD ["s6-svscan", "/home/runner/s6"]
