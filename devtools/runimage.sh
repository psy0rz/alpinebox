#!/bin/bash

#boot the generated image in qemu to test it

set -e 

qemu-system-x86_64 \
    -enable-kvm \
    -smp 4 \
    -m 4096 \
    -device virtio-blk-pci,drive=drive0,id=virtblk0,num-queues=4 \
    -drive file=/tmp/alpine.img,format=raw,if=none,id=drive0 \
    -boot order=c 

