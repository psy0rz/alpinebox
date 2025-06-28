#!/bin/sh
set -e

DISK=$1
if ! [ "$DISK" ]; then
    echo "Usage: $0 <disk>"
    echo "Will install Alpine Box on your system."
    echo "Run this from a Alpine installer ISO!"

    echo "Will WIPE existing DATA!"
    exit 1
fi


./1-prepare.sh $DISK
./2-partition-disk.sh  $DISK
./3-install-bootloader.sh $DISK
./4-create-zpool.sh $DISK
./5-install-alpine.sh $DISK
./6-install-extras.sh $DISK
./7-cleanup.sh $DISK

test -e /dev/sr0 && eject -s /dev/sr0 || true



echo "ALPINEBOX: All done, will reboot in 5 seconds.."
sleep 5
reboot
