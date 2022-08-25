#!/bin/sh

set -eux

if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
	set -- dockerd \
		--host=tcp://0.0.0.0:2375 \
		--tls=false \
		"$@"
fi

if [ "$1" = 'dockerd' ]; then
	if [ "$(id -u)" = '0' ]; then
		mkdir -p /unmasked-proc
		mount -t proc proc /unmasked-proc
		mkdir -p /unmasked-sys
		mount -t sysfs sysfs /unmasked-sys
		mkdir -p /dev/net
		mknod /dev/net/tun c 10 200 || :
		chmod 666 /dev/net/tun
		exec setpriv --reuid=rootless --regid=rootless \
			--init-groups --reset-env "$0" "$@"
	fi

	find /run /var/run -iname 'docker*.pid' -delete || :

	uid="$(id -u)"
	: "${XDG_RUNTIME_DIR:=/run/user/$uid}"
	PATH=/usr/local/sbin:/usr/sbin:/sbin:${PATH}
	export XDG_RUNTIME_DIR PATH

	exec dumb-init rootlesskit \
		--pidns \
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
