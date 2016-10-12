# Quassel Core

[![](https://images.microbadger.com/badges/image/zhusj/quassel.svg)]

## Intro

This only contains Quassel server part binary. It is statically linked with
Qt library and run in Alpine Linux.

It only support SQLite3 as its database.

It's always built with latest Quassel, from master branch in git repo.

## Guide

Sample command to run:

```
docker run -it -d --name quasselcore -v /srv/docker/quassel:/var/lib/quassel \
  -p 0.0.0.0:4242:4242/tcp zhusj/quassel
```
