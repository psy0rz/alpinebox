#!/bin/sh
set -e

DISK=$1
if ! [ "$DISK" ]; then
    echo "Usage: $0 <disk>"
    echo "Will install Alpine Box on your system."

    echo "Will WIPE existing DATA!"
    exit 1
fi

echo "ALPINEBOX: starting"

ALPINE_RELEASE=v3.19

cat >/etc/apk/repositories <<EOF
http://dl-cdn.alpinelinux.org/alpine/$ALPINE_RELEASE/main
http://dl-cdn.alpinelinux.org/alpine/$ALPINE_RELEASE/community
EOF

apk update
apk add git 

git clone --depth 1 https://github.com/psy0rz/alpinebox.git
cd alpinebox/install
./install.sh $DISK
