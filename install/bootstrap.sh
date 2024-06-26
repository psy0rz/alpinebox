#!/bin/sh

# Run this from the alpine installer ISO.
# This is the initial bootstrap that will git clone the actual installer.
# Use https://boot.datux.nl/install as a short url to get it.

set -e

DISK=$1
if ! [ "$DISK" ]; then
    echo "Usage: $0 <disk>"
    echo "Will install Alpine Box on your system."

    echo "Will WIPE existing DATA!"
    exit 1
fi

echo "ALPINEBOX: starting"

setup-apkrepos -1

apk update
apk add git 

if ! [ -e alpinebox ]; then 
    git clone --depth 1 https://github.com/psy0rz/alpinebox.git
    cd alpinebox
else
    cd alpinebox
    git pull
fi

cd install
./install.sh $DISK
