#!/bin/sh
set -e

DISK=$1
if ! [ "$DISK" ]; then
    echo "Usage: $0 <disk>"
    echo "Prepares disk according to standard alpinebox layout."

    echo "Will WIPE existing DATA!"
    exit 1
fi

echo "ALPINEBOX: Partitioning $DISK"

sgdisk --zap-all $DISK

### 1: legacy bios boot mode partition
# (will not be formatted but used by extlinux)
sgdisk -a1 -n1:24K:+1000K -t1:EF02 $1

### 2: EFI partition (minimum=100M)
sgdisk -n2:1M:+256M -t2:EF00 $DISK

#enable legacy boot via bios mode as well:
sgdisk -A 2:set:2 $DISK

### 3: swap
sgdisk -n3:0:+${SWAP_SIZE:-1G} -t3:8200 $DISK

# 4: zpool
sgdisk -n4:0:0 -t4:BF00 $DISK

sync
mdev -s
mkswap $DISK""3

echo "ALPINEBOX: Done, please run install-bootloader.sh next."
