# Shadowsocks

![](https://images.microbadger.com/badges/image/zhusj/shadowsocks.svg)

Only ss-server is included.

* `zhusj/shadowsocks:latest` is the nomarl shadowsocks-libev server.
* `zhusj/shadowsocks:kcptun` includes kcptun.

Default ports are 443(for shadowsocks) and 444(for kcptun),
encrypt method is xchacha20-ietf-poly1305.

See Dockerfile for other default options and the available environment variables.

## Guide

Sample command to run:

```
docker run -it -d --name ss-server -e PASSWORD=password zhusj/shadowsocks
```
