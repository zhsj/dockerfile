# Redmine

![](https://images.microbadger.com/badges/image/zhusj/redmine.svg)

Redmine master branch. Database is SQLite3.

## Guide

Sample command to run:

```
docker run -it -d --name redmine \
       -v /srv/docker/redmine/files:/redmine/files \
       -v /srv/docker/redmine/gitrepo:/gitrepo \
       zhusj/redmine
```
