#!/bin/sh

set -e


IMAGE_SIZE=3G
IMAGE=/tmp/alpine.img

#cleanup old stuff
losetup -d /dev/loop0 &>/dev/null || true
rm $IMAGE &>/dev/null || true

#prepare image
truncate -s $IMAGE_SIZE $IMAGE
losetup -P /dev/loop0 $IMAGE

export INSTALL_DISK=/dev/loop0
export INSTALL_EFI_DEV=$INSTALL_DISK""p2
export INSTALL_SWAP_DEV=$INSTALL_DISK""p3
export INSTALL_ZPOOL_DEV=$INSTALL_DISK""p4
export INSTALL_POOL=${INSTALL_RPOOL:-rpool}


cd ../install
./1-prepare.sh
./2-partition-disk.sh 
./3-install-bootloader.sh 
./4-create-zpool.sh 
./5-install-alpine.sh 

echo "ALPINEBOX: Compressing image..."
losetup -d /dev/loop0 
gzip $IMAGE

echo "ALPINEBOX: Done, $IMAGE"".gz created."

