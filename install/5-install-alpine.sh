#!/bin/sh

set -xe

source config
echo "ALPINEBOX: Installing alpine in $INSTALL_ROOT"


mkdir -p $INSTALL_ROOT/etc/apk
cp /etc/apk/repositories $INSTALL_ROOT/etc/apk

apk --allow-untrusted -U --root $INSTALL_ROOT --initdb add \
    alpine-base \
    linux-firmware-none linux-lts openssh-server openssh-client chrony acpid syslinux sgdisk partx mount zfs wireless-tools wpa_supplicant lsblk curl zfs-udev sysstat util-linux procps findutils coreutils grep sed gawk kexec-tools bash bash-completion mdevd mdevd-openrc

cp /etc/hostid $INSTALL_ROOT/etc
#only take over the network and dns config of a real installer environment.
#when building the image in docker (github actions) the resolv.conf contains docker/azure stuff (issue #18)
if [[ -e /etc/network/interfaces ]]; then
    cp /etc/network/interfaces $INSTALL_ROOT/etc/network
    cp /etc/resolv.conf $INSTALL_ROOT/etc
else
    cp files/interfaces $INSTALL_ROOT/etc/network
    echo "# Will be filled in by DHCP" >$INSTALL_ROOT/etc/resolv.conf
fi

#bash as default shell, for better tab completion stuff (esp with docker)
sed -i 's#/bin/sh#/bin/bash#' /etc/passwd 

mount --rbind /dev $INSTALL_ROOT/dev
mount --rbind /sys $INSTALL_ROOT/sys
mount --rbind /proc $INSTALL_ROOT/proc

# Blacklist GPUs (issue #3)
cp files/blacklist-gpu.conf $INSTALL_ROOT/etc/modprobe.d

# zfs stuff
echo "/etc/hostid" >>$INSTALL_ROOT/etc/mkinitfs/features.d/zfshost.files
echo 'features="ata base keymap kms mmc nvme scsi usb virtio zfs zfshost"' >$INSTALL_ROOT/etc/mkinitfs/mkinitfs.conf
sed -i '1i^zfs$ root:root 0666' $INSTALL_ROOT/etc/mdev.conf

# rebuild initfs for above two things
chroot $INSTALL_ROOT mkinitfs $(ls $INSTALL_ROOT/lib/modules)

# services
chroot $INSTALL_ROOT rc-update add hwdrivers sysinit
chroot $INSTALL_ROOT rc-update add networking boot
chroot $INSTALL_ROOT rc-update add hostname boot
chroot $INSTALL_ROOT rc-update add sshd default
chroot $INSTALL_ROOT rc-update add swap default
chroot $INSTALL_ROOT rc-update add acpid default
chroot $INSTALL_ROOT rc-update add crond default
chroot $INSTALL_ROOT rc-update add syslog default
chroot $INSTALL_ROOT rc-update add chronyd default
chroot $INSTALL_ROOT rc-update add zfs-mount default
chroot $INSTALL_ROOT rc-update add zfs-zed default
chroot $INSTALL_ROOT rc-update add sysctl default 

#NOTE: mdev mode is way too slow vs mdevd. (it will do hotplug fork flooding when having lots of zfs volumes)
chroot $INSTALL_ROOT rc-update add mdevd sysinit 
chroot $INSTALL_ROOT rc-update add mdevd-init sysinit 
chroot $INSTALL_ROOT rc-update add hwdrivers sysinit 

# fstab
cat >$INSTALL_ROOT/etc/fstab <<EOF
tmpfs	/tmp	tmpfs	nosuid,nodev	0	0
EOF

echo "ALPINEBOX: done"
