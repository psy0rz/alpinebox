#!/bin/sh

set -e

DISK=$1
RELEASE=${2:-latest}

if [ "$RELEASE" = "latest" ]; then
    echo "ALPINEBOX: Getting latest stable version..."
    URL="https://github.com/psy0rz/alpinebox/releases/latest/download/alpine.img.gz"
else
    echo "ALPINEBOX: Getting release $RELEASE..."
    URL="https://github.com/psy0rz/alpinebox/releases/download/$RELEASE/alpine.img.gz"
fi

if [ -z "$DISK" ]; then
    echo "Usage: $0 <disk> [release]"
    echo "Will install Alpine Box on your system from a image."
    echo "You should be able to run this from any Linux distro or environment."
    echo "Will WIPE existing DATA!"
    exit 1
fi

echo "ALPINEBOX: Writing $URL to disk $DISK ..."

if command -v wget >/dev/null 2>&1; then
    wget "$URL" -O - | gunzip > "$DISK"
elif command -v curl >/dev/null 2>&1; then
    curl -L "$URL" | gunzip > "$DISK"
else
    echo "Need curl or wget to continue!"
    exit 1
fi

eject -s /dev/sr0 2>/dev/null || true

echo "ALPINEBOX: All done. You can now reboot your system."
