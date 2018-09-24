#!/bin/bash

set -e

cp 2.4/alpine/Dockerfile 2.4/alpine/Dockerfile.wodby

# Change basic image.
sed -i '/FROM alpine/i\ARG BASE_IMAGE_TAG\n' 2.4/alpine/Dockerfile.wodby
sed -i 's/FROM alpine.*/FROM wodby\/alpine:${BASE_IMAGE_TAG}/' 2.4/alpine/Dockerfile.wodby

fullVersion=$(grep -oP '(?<=^ENV HTTPD_VERSION )([0-9\.]+)' 2.4/alpine/Dockerfile.wodby)
minorVersion=$(echo "${fullVersion}" | grep -oE '^[0-9]+\.[0-9]+')

# Update travis.yml
sed -i -E "s/(APACHE_VER)=${minorVersion//\./\\.}\.[0-9]+/\1=${fullVersion}/" .travis.yml
sed -i -E "s/(TAGS)=${minorVersion//\./\\.}\.[0-9]+/\1=${fullVersion}/" .travis.yml
# Update README.
sed -i -E "s/\`${minorVersion//\./\\.}\.[0-9]+\`/\`${fullVersion}\`/" README.md
