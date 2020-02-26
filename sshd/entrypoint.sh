#!/bin/sh

set -e

if [ "$1" != "/usr/sbin/sshd" ]; then
	exec "$@"
fi

user="${SSH_USER:-root}"
password="${SSH_PASSWORD:-$(perl -e 'print map{("a".."z","A".."Z",0..9)[int(rand(62))]}(1..12)')}"

printf 'Username: %s\nPassword: %s\n' "$user" "$password"

if [ "$user" = "root" ]; then
	sed -i '/PermitRootLogin/ c PermitRootLogin yes' /etc/ssh/sshd_config
fi

if ! getent passwd "$user" >/dev/null; then
	adduser --quiet --disabled-password --gecos '' "$user"
fi

echo "$user:$password" | chpasswd

mkdir -p /run/sshd
chmod 0755 /run/sshd

exec dumb-init -- "$@"
