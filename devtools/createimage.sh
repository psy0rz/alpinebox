#!/bin/sh

set -e

IMAGE_SIZE=3G
IMAGE=/tmp/alpine.img

#requirements
apk add zfs losetup git

#cleanup old stuff
losetup -D
rm -f $IMAGE 

LOOP_DEV=`losetup -f`

#prepare image
truncate -s $IMAGE_SIZE $IMAGE
losetup -P $LOOP_DEV $IMAGE

export INSTALL_DISK=$LOOP_DEV
export INSTALL_EFI_DEV=$INSTALL_DISK""p2
export INSTALL_SWAP_DEV=$INSTALL_DISK""p3
export INSTALL_ZPOOL_DEV=$INSTALL_DISK""p4
export INSTALL_ZPOOL=${INSTALL_ZPOOL:-zpool}


cd ../install
./1-prepare.sh
./2-partition-disk.sh 
./3-install-bootloader.sh 
./4-create-zpool.sh 
./5-install-alpine.sh 
./6-install-extras.sh 
./7-cleanup.sh

echo "ALPINEBOX: Compressing image..."
losetup -d $LOOP_DEV 
rm $IMAGE"".gz &>/dev/null || true
gzip $IMAGE

echo "ALPINEBOX: Done, $IMAGE"".gz created."

