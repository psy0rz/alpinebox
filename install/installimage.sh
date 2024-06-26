#!/bin/bash

set -e

DISK=$1
RELEASE=${2:-latest}

if [ "$RELEASE" == "latest" ]; then
    echo "ALPINEBOX: Getting latest stable version..."
    URL="https://github.com/psy0rz/alpinebox/releases/latest/download/alpine.img.gz"
else
    echo "ALPINEBOX: Getting release $RELEASE..."
    URL="https://github.com/psy0rz/alpinebox/releases/download/$RELEASE/alpine.img.gz"
fi


if ! [ "$DISK" ]; then
    echo "Usage: $0 <disk> [release]"
    echo "Will install Alpine Box on your system from a image."
    echo "You should be able to run this from any Linux distro or environment."

    echo "Will WIPE existing DATA!"
    exit 1
fi

echo "ALPINEBOX: Writing $URL to disk $DISK ..."

if  which wget &>/dev/null; then
    wget "$URL" -O - | gunzip > $DISK
elif which curl &>/dev/null; then
    curl -L "$URL" | gunzip > $DISK
else
    echo "Need curl or wget to continue!"
    exit 1
fi

eject -s /dev/sr0 || true

echo "ALPINEBOX: All done, will reboot in 5 seconds.."
sleep 5
reboot
