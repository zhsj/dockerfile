#!/bin/sh

set -ex

if [ "$1" != "apt-cacher-ng" ] && [ "$1" != "/usr/sbin/apt-cacher-ng" ]; then
	exec "$@"
fi

if [ "$(id -u)" = '0' ]; then
	chown -R apt-cacher-ng:apt-cacher-ng /var/cache/apt-cacher-ng || true
	exec setpriv --reuid=apt-cacher-ng --regid=apt-cacher-ng --init-groups /usr/local/bin/entrypoint.sh "$@"
fi

exec dumb-init -- "$@"
