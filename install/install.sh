#!/bin/sh
set -e

DISK=$1
if ! [ "$DISK" ]; then
    echo "Usage: $0 <disk>"
    echo "Will install Alpine Box on your system."

    echo "Will WIPE existing DATA!"
    exit 1
fi

./1-prepare.sh
./2-partition-disk.sh $DISK
./3-install-bootloader.sh $DISK
./4-create-zpool.sh $DISK
./5-install-alpine.sh $DISK

echo "ALPINEBOX: All done, will reboot in 5 seconds.."
sleep 5
reboot
