#!/bin/sh

set -e

ROOT=/mnt/newroot

########### motd
MOTD=$ROOT/etc/motd
cp files/motd $MOTD
VER=`git describe --always --tags`
sed "s/%v/$VER/" -i $MOTD

########## issue
ISSUE=$ROOT/etc/issue
cp files/issue $ISSUE
VER=`git describe --always --tags`
sed "s/%v/$VER/" -i $ISSUE

########### DTAP prompt
cp files/z_dtap-prompt.sh $ROOT/etc/profile.d/

########### this repo
cp -R .. $ROOT/root/alpinebox

########## stuff to make life easier
mkdir $ROOT/root/.ssh
touch $ROOT/root/.ssh/authorized_keys



