# Bind9

`/etc/bind` should have two major files: `named.conf` and `hook.sh`.

`named.conf` is the configure file for bind, and you can include any other
files in it.

`hook.sh` is the hook will be executed when you trigger
`http://container-ip:9000/hooks/bind`.

53/tcp, 53/udp, 9000/tcp are exported.

## Guide

Sample command to run:

```
docker run -d -it -v /srv/docker/bind:/etc/bind zhusj/bind9
```
