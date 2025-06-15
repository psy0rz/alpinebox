#!/bin/bash

set -e

DISK=${1:-/dev/$(lsblk -e8 -o NAME,TYPE,SIZE | grep 'disk' | awk '{printf $1;}')}
RELEASE=${2:-latest}

if [ "$RELEASE" == "latest" ]; then
    echo "ALPINEBOX: Getting latest stable version..."
    URL="https://github.com/psy0rz/alpinebox/releases/latest/download/alpine.img.gz"
else
    echo "ALPINEBOX: Getting release $RELEASE..."
    URL="https://github.com/psy0rz/alpinebox/releases/download/$RELEASE/alpine.img.gz"
fi


echo "Will install Alpine Box on your system."

read -p "WARNING: installation will overwrite $DISK and all existing data will be lost! Proceed? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Exiting. No changes have been made to your device."
    exit
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

test -e /dev/sr0 && eject -s /dev/sr0 || true

echo "ALPINEBOX: All done, will reboot in 5 seconds.."
sleep 5
reboot
