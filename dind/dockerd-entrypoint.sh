#!/bin/sh

set -eux

if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
	set -- dockerd \
		--host=tcp://0.0.0.0:2375 \
		--tls=false \
		"$@"
fi

if [ "$1" = 'dockerd' ]; then
	find /run /var/run -iname 'docker*.pid' -delete || :

	uid="$(id -u)"
	: "${XDG_RUNTIME_DIR:=/run/user/$uid}"
	export XDG_RUNTIME_DIR

	exec dumb-init rootlesskit \
		--disable-host-loopback \
		--net=slirp4netns \
		--port-driver=builtin \
		--publish 0.0.0.0:2375:2375/tcp \
		--copy-up=/etc \
		--copy-up=/run \
		"$@"
fi

export DOCKER_HOST='tcp://127.0.0.1:3275'
exec "$@"
