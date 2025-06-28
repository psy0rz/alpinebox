#!/bin/sh

set -e

source config
echo "ALPINEBOX: Installing alpine in $INSTALL_ROOT"


mkdir -p $INSTALL_ROOT/etc/apk
cp /etc/apk/repositories $INSTALL_ROOT/etc/apk

apk --allow-untrusted -U --root $INSTALL_ROOT --initdb add \
    alpine-base \
    linux-firmware-none linux-lts openssh-server openssh-client chrony acpid syslinux sgdisk partx mount zfs wireless-tools wpa_supplicant lsblk

cp /etc/hostid $INSTALL_ROOT/etc
cp /etc/resolv.conf $INSTALL_ROOT/etc
if [[ -e /etc/network/interfaces ]]; then
    cp /etc/network/interfaces $INSTALL_ROOT/etc/network
else
    cp files/interfaces $INSTALL_ROOT/etc/network
fi

mount --rbind /dev $INSTALL_ROOT/dev
mount --rbind /sys $INSTALL_ROOT/sys
mount --rbind /proc $INSTALL_ROOT/proc

# Blacklist GPUs (issue #3)
cp files/blacklist-gpu.conf $INSTALL_ROOT/etc/modprobe.d

# zfs stuff
echo "/etc/hostid" >>$INSTALL_ROOT/etc/mkinitfs/features.d/zfshost.files
echo 'features="ata base keymap kms mmc nvme scsi usb virtio zfs zfshost"' >$INSTALL_ROOT/etc/mkinitfs/mkinitfs.conf

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
# chroot $INSTALL_ROOT rc-update add zfs-import default

# fstab
cat >$INSTALL_ROOT/etc/fstab <<EOF
tmpfs	/tmp	tmpfs	nosuid,nodev	0	0
EOF

echo "ALPINEBOX: done"
