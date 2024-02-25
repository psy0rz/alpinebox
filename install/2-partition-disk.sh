#!/bin/sh
set -e


echo "ALPINEBOX: Partitioning $INSTALL_DISK"

sgdisk --zap-all $INSTALL_DISK

### 1: legacy bios boot mode partition
# (will not be formatted but used by extlinux)
sgdisk -a1 -n1:24K:+1000K -t1:EF02 $INSTALL_DISK

### 2: EFI partition (minimum=100M)
sgdisk -n2:1M:+256M -t2:EF00 $INSTALL_DISK

#enable legacy boot via bios mode as well:
sgdisk -A 2:set:2 $INSTALL_DISK

### 3: swap
sgdisk -n3:0:+${SWAP_SIZE:-1G} -t3:8200 $INSTALL_DISK

# 4: zpool
sgdisk -n4:0:0 -t4:BF00 $INSTALL_DISK

sync
mdev -s
mkswap $INSTALL_SWAP_DEV

echo "ALPINEBOX: Done, please run install-bootloader.sh next."
