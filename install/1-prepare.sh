#!/bin/sh
set -e

echo "ALPINEBOX: installing basic pacakges stuff we need for the rest of the scripts to function."

apk add sgdisk zfs syslinux

modprobe zfs

echo "ALPINEBOX: done"
