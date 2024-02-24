#!/bin/sh

set -e

echo "ALPINEBOX: Installing alpine in /mnt/newroot"

mkdir -p /mnt/newroot/etc/apk
cp /etc/apk/repositories /mnt/newroot/etc/apk

apk --allow-untrusted -U --root /mnt/newroot --initdb add \
    alpine-base \
    linux-firmware-none\
    linux-lts\
    zfs


cp /etc/hostid /mnt/newroot/etc
cp /etc/resolv.conf /mnt/newroot/etc
cp /etc/network/interfaces /mnt/newroot/etc/network

mount --rbind /dev /mnt/newroot/dev
mount --rbind /sys /mnt/newroot/sys
mount --rbind /proc /mnt/newroot/proc



echo "/etc/hostid" >> /mnt/newroot/etc/mkinitfs/features.d/zfshost.files
echo 'features="ata base keymap kms mmc nvme scsi usb virtio zfs zfshost"' > /mnt/newroot/etc/mkinitfs/mkinitfs.conf
chroot /mnt/newroot mkinitfs $(ls /mnt/newroot/lib/modules)                

echo "ALPINEBOX: done"

