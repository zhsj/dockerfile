# Exim4

![](https://images.microbadger.com/badges/image/zhusj/exim4.svg)

Based on Debian Exim4, but only supports:

* mail sent by smarthost; no local mail

Environments:

* `SMTP_HOST`
* `SMTP_USER`
* `SMTP_PASSWORD`

## Guide

Sample command to run:

```
docker run -d -it --name exim4 --restart=always \
  -e SMTP_HOST=smtp.gmail.com::578 \
  -e SMTP_USER=test@gmail.com \
  -e SMTP_PASSWORD=password \
  -p 127.0.0.1:25:25/tcp \
  -v /srv/docker/exim4:/data \
  zhusj/exim4
```

Now you can send email through `127.0.0.1:25`
without credentials.
