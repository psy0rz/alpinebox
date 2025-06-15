#!/bin/sh
set -e

DISK=${1:-/dev/$(lsblk -e8 -o NAME,TYPE,SIZE | grep 'disk' | awk '{printf $1;}')}

echo "Will install Alpine Box on your system."

read -p "WARNING: installation will overwrite $DISK and all existing data will be lost! Proceed? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Exiting. No changes have been made to your device."
    exit
fi

echo "ALPINEBOX: Writing to disk $DISK ..."

export INSTALL_DISK=$DISK
export INSTALL_EFI_DEV=$DISK""2
export INSTALL_SWAP_DEV=$DISK""3
export INSTALL_ZPOOL_DEV=$DISK""4
export INSTALL_ZPOOL=${INSTALL_ZPOOL:-rpool}


./1-prepare.sh
./2-partition-disk.sh 
./3-install-bootloader.sh 
./4-create-zpool.sh 
./5-install-alpine.sh 
./6-install-extras.sh 
./7-cleanup.sh

test -e /dev/sr0 && eject -s /dev/sr0 || true

echo "ALPINEBOX: All done, will reboot in 5 seconds.."
sleep 5
reboot
