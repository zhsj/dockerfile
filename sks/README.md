# SKS Key Server

![](https://images.microbadger.com/badges/image/zhusj/sks.svg)

## Intro

This is [SKS Key Server](https://bitbucket.org/skskeyserver/sks-keyserver) unofficial Dockerfile.
It's built against latest code from upstream.

## Guide

This container has a volume which is `/var/lib/sks` inside. Please mount it for persistent storage.

Assume you created a local dir named `/srv/docker/sks` to store the data. Please download a copy of
[key dump](https://bitbucket.org/skskeyserver/sks-keyserver/wiki/KeydumpSources) and put it in
`/srv/docker/sks/dump`.

### One Time Setup

You should init your working dir `/srv/docker/sks` first:

```
docker run --rm -v /srv/docker/sks/:/var/lib/sks/ zhusj/sks sks-init
```

The command above will init the working directory for SKS.

Please read the [`sks-init`](https://github.com/zhsj/dockerfile/blob/master/sks/files/bin/sks-init)
script to check what it does. If you have a key dump directory, this script will import them. Otherwise
it will build an empty database. It will also copy some sample configuration files if you don't have
them in `/srv/docker/sks`. You can modify these configurations later.

### Run

After initialized the working dir, you can start the container with:

```
docker run -it -d --restart=always --name sks-keyserver \
  -v /srv/docker/sks/:/var/lib/sks/ \
  -p 0.0.0.0:11370:11370/tcp -p 127.0.0.1:11371:11371/tcp zhusj/sks
```

Besides you should setup a reverse proxy server for `127.0.0.1:11371`. And you should update
the membership file in `/srv/docker/sks/membership` to start peering.

Read more at [SKS Wiki](https://bitbucket.org/skskeyserver/sks-keyserver/wiki/Peering).

### Full version

`zhusj/sks:full` bundles [Caddy](https://github.com/mholt/caddy). So you don't need to setup reverse
proxy server now. Besides Caddy can automatically enable HTTPS.

You can just use `host` network to run this version,

```
docker run -it -d --restart=always --name sks-keyserver \
  -v /srv/docker/sks/:/var/lib/sks/ \
  --network=host zhusj/sks:full
```

This version exposes hkp(80,11371), hkps(443) and recon(11370) ports.

You need to edit `/srv/docker/sks/caddy/Caddyfile` to set your hostname and email.

### Demo

The full version is used for running <https://pgp.ustc.edu.cn>
