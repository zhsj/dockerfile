#!/bin/sh
cd /var/lib/sks || exist 1
if [ -d dump ] && [ "$(echo dump/*.pgg)" != "" ]; then
    sks build dump/*.pgp -n 10 -cache 100
    sks cleandb
    sks pbuild -cache 20 -ptree_cache 70
fi
if [ ! -e sksconf ]; then
    cp /etc/sks/sksconf .
fi
if [ ! -e membership ]; then
    cp /etc/sks/membership .
fi

s6-svscan /etc/s6
