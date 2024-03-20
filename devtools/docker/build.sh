#docker build  -t alpinebox .

REPO=`cd ../..;pwd`

#make sure host OS has zfs
modprobe zfs || true

docker run --rm --privileged -w /repo/devtools -i -v /tmp:/tmp -v $REPO:/repo alpine:3.19 ./createimage.sh
# docker run --rm --privileged -w /repo/devtools -itv $REPO:/repo alpine:3.19 

