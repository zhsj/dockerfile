FROM debian:buster-slim

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends openssh-server \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 22/tcp

VOLUME /home

ADD entrypoint.sh /usr/local/bin/
ENTRYPOINT ["entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D", "-e"]
