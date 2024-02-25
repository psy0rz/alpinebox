#!/bin/sh

set -e

echo "ALPINEBOX: Installing alpine in /mnt/newroot"

mkdir -p /mnt/newroot/etc/apk
cp /etc/apk/repositories /mnt/newroot/etc/apk

apk --allow-untrusted -U --root /mnt/newroot --initdb add \
    alpine-base \
    linux-firmware-none\
    linux-lts\
    openssh-server\
    chrony\
    acpid\
    zfs


cp /etc/hostid /mnt/newroot/etc
cp /etc/resolv.conf /mnt/newroot/etc
cp /etc/network/interfaces /mnt/newroot/etc/network

mount --rbind /dev /mnt/newroot/dev
mount --rbind /sys /mnt/newroot/sys
mount --rbind /proc /mnt/newroot/proc

# zfs stuff
echo "/etc/hostid" >> /mnt/newroot/etc/mkinitfs/features.d/zfshost.files
echo 'features="ata base keymap kms mmc nvme scsi usb virtio zfs zfshost"' > /mnt/newroot/etc/mkinitfs/mkinitfs.conf
chroot /mnt/newroot mkinitfs $(ls /mnt/newroot/lib/modules)                

# services
chroot /mnt/newroot rc-update add hwdrivers sysinit
chroot /mnt/newroot rc-update add networking  boot
chroot /mnt/newroot rc-update add hostname boot
chroot /mnt/newroot rc-update add sshd default
chroot /mnt/newroot rc-update add swap default
chroot /mnt/newroot rc-update add acpid default
# chroot /mnt/newroot rc-update add zfs-mount default
# chroot /mnt/newroot rc-update add zfs-import default

# fstab
SWAPDEV=$INSTALL_SWAP_DEV
cat > /mnt/newroot/etc/fstab <<EOF
tmpfs	/tmp	tmpfs	nosuid,nodev	0	0
$SWAPDEV none swap sw 0 0
EOF

#this automaticly unmounts all the bindmounts as well
umount -l /mnt/newroot
zpool export $INSTALL_ZPOOL

eject -s /dev/sr0 || true

echo "ALPINEBOX: done"

