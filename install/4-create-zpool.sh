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
    -o autoexpand=on \
    -O dnodesize=auto \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    -R /mnt/newroot \
    $INSTALL_ZPOOL $INSTALL_ZPOOL_DEV

zfs create -o mountpoint=/ -o canmount=noauto $INSTALL_ZPOOL/ROOT
zpool set bootfs=$INSTALL_ZPOOL/ROOT $INSTALL_ZPOOL

# zpool export $INSTALL_ZPOOL
# zpool import -N -R /mnt $INSTALL_ZPOOL
zfs mount $INSTALL_ZPOOL/ROOT

echo "ALPINEBOX: Done, $INSTALL_ZPOOL mounted under /mnt/newroot"
