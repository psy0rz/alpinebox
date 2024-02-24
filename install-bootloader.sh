#!/bin/sh
set -e

ZFSBOOTMENU_EFI="https://github.com/zbm-dev/zfsbootmenu/releases/download/v2.3.0/zfsbootmenu-release-x86_64-v2.3.0-vmlinuz.EFI"
ZFSBOOTMENU_BIOS="https://github.com/zbm-dev/zfsbootmenu/releases/download/v2.3.0/zfsbootmenu-recovery-x86_64-v2.3.0.tar.gz"
DISK=$1
if ! [ "$DISK" ]; then
    echo "Usage: $0 <disk>"
    echo "Install zfsbootmenu bootloader for both MBR and UEFI mode"
    echo "Disk should be paritioned with partition-disk.sh"
    exit 1
fi

echo "ALPINEBOX: Formatting EFI and installing bootloader (legacy and efi mode)"

#format and mount
umount /mnt/boot 2>/dev/null || true
mkdir -p /mnt/boot 2>/dev/null || true
mkfs.vfat -n EFI $DISK""2
mount -t vfat $DISK""2 /mnt/boot

# get zfsbootmenu
wget $ZFSBOOTMENU_BIOS -O zfsbootmenu.tar.gz
wget $ZFSBOOTMENU_EFI -O zfsbootmenu.EFI
tar -xvzf zfsbootmenu.tar.gz

# EFI version:
mkdir -p /mnt/boot/EFI/BOOT/
cp zfsbootmenu.EFI /mnt/boot/EFI/BOOT/BOOTX64.EFI

#BIOS version:
mkdir -p /mnt/boot/syslinux

cp zfsbootmenu-*/* /mnt/boot/syslinux
cp /usr/share/syslinux/*c32 /mnt/boot/syslinux
cp syslinux.cfg /mnt/boot/syslinux
extlinux --install /mnt/boot/syslinux
dd bs=440 count=1 conv=notrunc if=/usr/share/syslinux/gptmbr.bin  of=$DISK


umount /mnt/boot

echo "ALPINEBOX: done"
