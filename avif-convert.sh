#!/usr/bin/env bash

# Copyright (C) 2023, 2025  Dirk Stolle
#
# SPDX-License-Identifier: LGPL-3.0-or-later

IMAGE_NAME="avif-convert"

# Check whether Docker exists / daemon is running and user has permission to
# use it.
docker info > /dev/null 2>&1
if [[ $? -ne 0 ]]
then
    echo "Error: It looks like Docker is not installed or you do not have the"
    echo "required permissions to use Docker."
    exit 1
fi

# Does the image exist? (Redirect STDIN+STDERR to /dev/null.)
docker image inspect "$IMAGE_NAME" > /dev/null 2>&1
if [[ $? -ne 0 ]]
then
    echo "Info: Image $IMAGE_NAME does not exist, building it now."

    # Try to pull newer version of base image.
    docker pull debian:13-slim
    if [ $? -ne 0 ]
    then
        echo "Warning: Could not pull newer base image, but continuing anyway."
    fi

    # Build image and tag it.
    docker build . -t "avif-convert"
    if [ $? -ne 0 ]
    then
        echo "ERROR: Docker build failed!"
        cd "$ORIGIN_DIR"
        exit 1
    fi
fi

# 1st parameter = AVIF image path
if [ -z "$1" ]
then
    echo "First parameter must be an AVIF file!"
    echo " "
    echo "Usage:"
    echo "  avif-convert.sh /path/to/image.avif"
    exit 1
fi
if [ ! -f "$1" ]
then
    echo "First parameter must be an existing file!"
    exit 1
fi
AVIF_FILE="$1"
BASENAME=$(basename "$AVIF_FILE")

CONTAINER_ID=$(docker run --rm -d "$IMAGE_NAME")
CONTAINER_SH="script-$CONTAINER_ID.sh"
echo -n 'docker exec ' > ./"$CONTAINER_SH"
echo -n "$CONTAINER_ID" >> ./"$CONTAINER_SH"
echo    ' "$@";' >> ./"$CONTAINER_SH"
chmod +x ./"$CONTAINER_SH"

docker cp "$AVIF_FILE" "$CONTAINER_ID:/home/avif/$BASENAME" || exit 2
./"$CONTAINER_SH" avifdec -q 95 "/home/avif/$BASENAME" "/home/avif/$BASENAME.jpg"
docker cp "$CONTAINER_ID:/home/avif/$BASENAME.jpg" "$AVIF_FILE.jpg" || exit 4
docker stop -t 1 "$CONTAINER_ID"
unlink ./"$CONTAINER_SH"
