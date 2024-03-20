#!/bin/sh
set -e

echo "ALPINEBOX: installing basic pacakges stuff we need for the rest of the scripts to function."

apk add sgdisk zfs syslinux partx

#may fail, in docker
modprobe zfs || true

echo "ALPINEBOX: done"
