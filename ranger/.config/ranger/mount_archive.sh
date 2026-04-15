#!/bin/bash

ARCHIVE="$1"
BASENAME="$(basename "$ARCHIVE")"
MOUNTPOINT="/tmp/ranger_archive/$BASENAME"

# Skip if already mounted
if mountpoint -q "$MOUNTPOINT"; then
    exit 0
fi

mkdir -p "$MOUNTPOINT"

# Mount and wait briefly
archivemount "$ARCHIVE" "$MOUNTPOINT" &
sleep 0.5

