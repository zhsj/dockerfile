# Shadowsocks

![](https://images.microbadger.com/badges/image/zhusj/shadowsocks.svg)

ss-server and v2ray-plugin are included.

Default port is 443, encrypt method is xchacha20-ietf-poly1305.

See [start.sh](https://github.com/zhsj/dockerfile/blob/master/shadowsocks/start.sh)
for other default options and the available environment variables.

## Guide

Sample command to run:

```
docker run -it -d --name ss-server -e PASSWORD=password zhusj/shadowsocks
```
