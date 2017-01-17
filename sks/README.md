# SKS Key Server

![](https://images.microbadger.com/badges/image/zhusj/sks.svg)

## Intro

This is [SKS Key Server](https://bitbucket.org/skskeyserver/sks-keyserver) unofficial Dockerfile.
Currently the latest version is 1.1.6.

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
script to check what it does.

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
