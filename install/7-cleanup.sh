#!/bin/sh

set -e

#cleanup everything so that the underlying disk or image will be unused.

#this automaticly unmounts all the bindmounts as well
umount -l /mnt/newroot
zpool export $INSTALL_ZPOOL

