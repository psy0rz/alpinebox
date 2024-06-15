#!/bin/bash

#NOTE: use with INSTALL_ZPOOL=... to override rpool name

set -e

REPO=$(
    cd ../..
    pwd
)

source $REPO/install/config

#make sure host OS has zfs
modprobe zfs || true

docker run \
    -e SKIP_COMPRESS=$SKIP_COMPRESS \
    -e INSTALL_ZPOOL=$INSTALL_ZPOOL \
    --rm \
    --privileged \
    -w /repo/devtools \
    -i \
    -v /tmp:/tmp \
    -v $REPO:/repo \
    alpine:$ALPINE_RELEASE \
    ./createimage.sh
