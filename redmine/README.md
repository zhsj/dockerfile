# Redmine

![](https://images.microbadger.com/badges/image/zhusj/redmine.svg)

Redmine master branch. Database is SQLite3.

It's forked from [serverbee/docker-redmine-alpine](https://github.com/serverbee/docker-redmine-alpine),
and files inside this directory are licensed under GPL-2.0.

## Guide

Sample command to run:

```
docker run -it -d --name redmine \
       -v /srv/docker/redmine/files:/redmine/files \
       zhusj/redmine
```
