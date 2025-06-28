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

cd ../install
./1-prepare.sh $LOOP_DEV
./2-partition-disk.sh $LOOP_DEV
./3-install-bootloader.sh $LOOP_DEV
./4-create-zpool.sh $LOOP_DEV
./5-install-alpine.sh $LOOP_DEV
./6-install-extras.sh $LOOP_DEV
./7-cleanup.sh $LOOP_DEV

losetup -d $LOOP_DEV 
rm $IMAGE"".gz &>/dev/null || true
if ! [ "$SKIP_COMPRESS" ]; then
    echo "ALPINEBOX: Compressing image..."
    gzip -k $IMAGE
fi

#so that runimage.sh works without root
chmod 666 /tmp/alpine.img

echo "ALPINEBOX: Done, $IMAGE created."

