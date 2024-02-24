#!/bin/sh
set -e

DISK=$1
if ! [ "$DISK" ]; then
    echo "Usage: $0 <disk>"
    echo "Creates zpool on disk. (that is already prepared with partition-disk.sh)"

    echo "Will WIPE existing DATA!"
    exit 1
fi

echo "ALPINEBOX: Creating zpool on $DISK"

zgenhostid -f

zpool create \
    -f \
    -o ashift=12 \
    -o autotrim=on \
    -O mountpoint=none \
    -O acltype=posixacl \
    -O compression=on \
    -O dnodesize=auto \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -R /mnt/newroot \
    rpool $DISK""4

zfs create -o mountpoint=/ -o canmount=noauto rpool/ROOT
zpool set bootfs=rpool/ROOT rpool

# zpool export rpool
# zpool import -N -R /mnt rpool
zfs mount rpool/ROOT

echo "ALPINEBOX: Done, rpool mounted under /mnt/newroot"
