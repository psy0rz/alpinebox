#!/bin/sh
set -e



echo "ALPINEBOX: Creating zpool on $INSTALL_DISK"

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
    rpool $INSTALL_SWAP_DEV

zfs create -o mountpoint=/ -o canmount=noauto rpool/ROOT
zpool set bootfs=rpool/ROOT rpool

# zpool export rpool
# zpool import -N -R /mnt rpool
zfs mount rpool/ROOT

echo "ALPINEBOX: Done, rpool mounted under /mnt/newroot"
