#!/bin/sh
set -e

echo "ALPINEBOX: Formatting EFI and installing bootloader (legacy and efi mode)"

source config

#format and mount
umount /mnt/boot 2>/dev/null || true
mkdir -p /mnt/boot 2>/dev/null || true
mkfs.vfat -n EFI $INSTALL_EFI_DEV
mount -t vfat $INSTALL_EFI_DEV /mnt/boot

# get zfsbootmenu
CWD=$(pwd)
cd /tmp
if ! [ -e zfsbootmenu.tar.gz ]; then
    wget $CONFIG_ZFSBOOTMENU_BIOS -O wget.tmp
    mv wget.tmp zfsbootmenu.tar.gz
fi
tar -xvzf zfsbootmenu.tar.gz

if ! [ -e zfsbootmenu.EFI ]; then
    wget $CONFIG_ZFSBOOTMENU_EFI -O wget.tmp
    mv wget.tmp zfsbootmenu.EFI
fi

# EFI version:
mkdir -p /mnt/boot/EFI/BOOT/
cp zfsbootmenu.EFI /mnt/boot/EFI/BOOT/BOOTX64.EFI

#BIOS version:
mkdir -p /mnt/boot/syslinux

cp zfsbootmenu-*/* /mnt/boot/syslinux
cp /usr/share/syslinux/*c32 /mnt/boot/syslinux
cp $CWD/syslinux.cfg /mnt/boot/syslinux
extlinux --install /mnt/boot/syslinux
dd bs=440 count=1 conv=notrunc if=/usr/share/syslinux/gptmbr.bin of=$INSTALL_DISK

umount /mnt/boot

echo "ALPINEBOX: done"
