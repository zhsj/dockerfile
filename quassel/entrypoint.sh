#!/bin/sh

set -ex

if [ "$1" != "quasselcore" ]; then
	exec "$@"
fi

if [ "$(id -u)" = '0' ]; then
	chown -R quassel:quassel /var/lib/quassel || true
	exec su-exec quassel:quassel /usr/local/bin/entrypoint.sh "$@"
fi

exec "$@"
