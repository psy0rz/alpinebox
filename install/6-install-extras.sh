#!/bin/sh

set -e

ROOT=/mnt/newroot

########### motd
MOTD=$ROOT/etc/motd
cp files/motd $MOTD
VER=`git describe --always --tags`
sed "s/%v/$VER/" -i $MOTD

#show on boot
cp files/motd.init $ROOT/etc/init.d/motd
chroot $ROOT rc-update add motd default

########### prompt
cp files/z_dtap-prompt.sh $ROOT/etc/profile.d/

########### this repo
cp -R .. $ROOT/root/alpinebox





