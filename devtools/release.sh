#!/bin/sh

# create image for specified release tag and uploads image to github

set -e
source ../.env

TAG=$1
[ "TAG" ] || exit 1

apk add curl jq

#clone
cd /tmp
rm -rf alpinebox
git clone --branch $TAG --depth 1 'https://github.com/psy0rz/alpinebox.git'

#build
cd alpinebox/devtools
./createimage.sh

#upload
echo "Uploading to github..."

ID=`curl -s -H "Accept: application/vnd.github.v3+json"  https://api.github.com/repos/psy0rz/alpinebox/releases/tags/$TAG|jq .id`


curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -H "Content-Type: application/octet-stream" \
  "https://uploads.github.com/repos/psy0rz/alpinebox/releases/$ID/assets?name=alpine.img.gz" \
  --data-binary "@/tmp/alpine.img.gz"
