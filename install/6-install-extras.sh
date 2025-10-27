#!/bin/sh

set -e


source config

echo "ALPINEBOX: Installing extra stuff in $INSTALL_ROOT"

#make git happy
chown root:root .. ../.git

########### motd
MOTD=$INSTALL_ROOT/etc/motd
cp files/motd $MOTD
VER=`git describe --always --tags`
sed "s/%v/$VER/" -i $MOTD

########## issue
ISSUE=$INSTALL_ROOT/etc/issue
cp files/issue $ISSUE
VER=`git describe --always --tags`
sed "s/%v/$VER/" -i $ISSUE

########### DTAP prompt
cp files/z_dtap-prompt.sh $INSTALL_ROOT/etc/profile.d/

########### this repo
cp -R .. $INSTALL_ROOT/root/alpinebox
chown -R root:root $INSTALL_ROOT/root/alpinebox
cd $INSTALL_ROOT/root/alpinebox
git remote set https://github.com/psy0rz/alpinebox.git


########## stuff to make life easier
mkdir $INSTALL_ROOT/root/.ssh
touch $INSTALL_ROOT/root/.ssh/authorized_keys

