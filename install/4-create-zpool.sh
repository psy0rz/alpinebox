#!/bin/sh
# Environment variables:
# INSTALL_ZPOOL: The name of the zpool (e.g. rpool)
# INSTALL_ZPOOL_DEV: The device for the zpool (e.g. /dev/sda4)

set -e


source config
echo "ALPINEBOX: Creating zpool on $INSTALL_ZPOOL_DEV"

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
    -O atime=off \
    -O xattr=sa \
    -R $INSTALL_ROOT \
    $INSTALL_ZPOOL $INSTALL_ZPOOL_DEV

zfs create -o mountpoint=/ -o canmount=noauto $INSTALL_ZPOOL/ROOT
zpool set bootfs=$INSTALL_ZPOOL/ROOT $INSTALL_ZPOOL

# zpool export $INSTALL_ZPOOL
# zpool import -N -R /mnt $INSTALL_ZPOOL
zfs mount $INSTALL_ZPOOL/ROOT

#set default zfsbootmenu kernel commandline
zfs set org.zfsbootmenu:commandline="$APPEND" $INSTALL_ZPOOL/ROOT


echo "ALPINEBOX: Done, $INSTALL_ZPOOL mounted under $INSTALL_ROOT"
