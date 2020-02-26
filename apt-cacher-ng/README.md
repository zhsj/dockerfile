# Apt-Cacher NG

![](https://images.microbadger.com/badges/image/zhusj/apt-cacher-ng.svg)

## Guide

Sample command to run:

``` bash
mkdir -p /srv/docker/apt-cacher-ng
chown 101:101 /srv/docker/apt-cacher-ng
docker run -it -d --restart=always --user apt-cacher-ng \
       --name apt-cacher-ng -p 0.0.0.0:3142:3142 \
       -v /srv/docker/apt-cacher-ng:/var/cache/apt-cacher-ng \
       zhusj/apt-cacher-ng
```

Client configurations:

+ `apt`

  File: `/etc/apt/apt.conf.d/00apt-cacher-ng-proxy`

  ```
  Acquire::http::Proxy "http://127.0.0.1:3142/";
  ```

+ `yum`

  File: `/etc/yum.conf`

  ```
  proxy=http://127.0.0.1:3142
  ```
