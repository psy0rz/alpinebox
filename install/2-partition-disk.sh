#!/bin/sh
#Environment variables:
# INSTALL_DISK: The disk to install Alpine Box on (e.g. /dev/sda)
# SWAP_SIZE: Size of the swap partition (default: 1G)

set -e

echo "ALPINEBOX: Partitioning $INSTALL_DISK"

source config

sgdisk --zap-all $INSTALL_DISK

### Parition 1: legacy bios boot mode partition
# (will not be formatted but used by extlinux)
sgdisk -a1 -n1:24K:+1000K -t1:EF02 $INSTALL_DISK

### Partition 2: EFI partition (minimum=100M)
sgdisk -n2:1M:+256M -t2:EF00 $INSTALL_DISK

#enable legacy boot via bios mode as well:
sgdisk -A 2:set:2 $INSTALL_DISK

### Partition 3: swap
sgdisk -n3:0:+${SWAP_SIZE:-1G} -t3:8200 $INSTALL_DISK

### Partition 4: zpool
sgdisk -n4:0:0 -t4:BF00 $INSTALL_DISK

partx -u $INSTALL_DISK
sync
sleep 3
mdev -s

echo "ALPINEBOX: Done, please run install-bootloader.sh next."
