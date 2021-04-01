FROM golang as huproxy-builder

RUN go install -ldflags="-w -s" -v github.com/google/huproxy@master

FROM debian:bullseye-slim

RUN set -ex \
    && apt-get update \
    && apt-get install -y --no-install-recommends openssh-server busybox s6 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=huproxy-builder /go/bin/huproxy /usr/local/bin/
ADD files /usr/local/etc

EXPOSE 22/tcp 8888/tcp
CMD ["s6-svscan", "/usr/local/etc/s6"]
