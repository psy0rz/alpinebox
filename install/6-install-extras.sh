#!/bin/sh

set -e

ROOT=/mnt/newroot

########### motd
MOTD=$ROOT/etc/motd
cp motd $MOTD
VER=`git describe --always --tags`
sed "s/%v/$VER/" -i $MOTD

#show on boot
cp motd.init $ROOT/etc/init.d/motd
chroot $ROOT rc-update add motd default

########### prompt
cp z_dtap-prompt.sh $ROOT/etc/profile.d/

########### this repo
cp -R .. $ROOT/root/alpinebox





