#!/bin/sh

set -e

source config
echo "ALPINEBOX: Cleaning up"

#cleanup everything so that the underlying disk or image will be unused.

#this automaticly unmounts all the bindmounts as well
umount -l $INSTALL_ROOT

zfs snapshot $INSTALL_ZPOOL/ROOT@fresh-install
zpool export $INSTALL_ZPOOL

