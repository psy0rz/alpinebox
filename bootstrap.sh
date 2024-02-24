#!/bin/sh
set -e

echo "ALPINEBOX: installing basic pacakges stuff we need for the rest of the scripts to function."

ALPINE_RELEASE=v3.19

cat >/etc/apk/repositories <<EOF
http://dl-cdn.alpinelinux.org/alpine/$ALPINE_RELEASE/main
http://dl-cdn.alpinelinux.org/alpine/$ALPINE_RELEASE/community
EOF

apk update
apk add sgdisk zfs syslinux

modprobe zfs

echo "ALPINEBOX: done"
