# Bind9

![](https://images.microbadger.com/badges/image/zhusj/rbd-nbd.svg)

## Guide

Sample command to run:

```
docker run -d -it --cap-add SYS_MODULE --cap-add SYS_ADMIN \
       -v /lib/modules/:/lib/modules/:ro -v /dev/:/dev/ \
       zhusj/rbd-nbd
```
