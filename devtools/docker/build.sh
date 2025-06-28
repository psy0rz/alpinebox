#!/bin/bash


set -e

REPO=$(
    cd ../..
    pwd
)

source $REPO/install/versions

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
