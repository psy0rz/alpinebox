#!/bin/sh

set -e

#cleanup everything so that the underlying disk or image will be unused.

#this automaticly unmounts all the bindmounts as well
umount -l /mnt/newroot

zfs snapshot $INSTALL_ZPOOL/ROOT@fresh-install
zpool export $INSTALL_ZPOOL

