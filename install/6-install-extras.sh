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
rm .git/config #clean any access tokens
git remote add origin https://github.com/psy0rz/alpinebox.git -t master

########## stuff to make life easier
mkdir $INSTALL_ROOT/root/.ssh
touch $INSTALL_ROOT/root/.ssh/authorized_keys

########## ssh: only allow key based logins
#put it at the top: sshd uses the first value it finds, and this keeps it outside any Match block
SSHD_CONFIG=$INSTALL_ROOT/etc/ssh/sshd_config
sed -i '/^[#[:space:]]*PasswordAuthentication[[:space:]]/d' $SSHD_CONFIG
sed -i '1i PasswordAuthentication no' $SSHD_CONFIG

