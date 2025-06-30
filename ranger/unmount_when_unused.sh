#!/bin/bash

MOUNTPOINT="$1"

while true; do
    sleep 5
    if ! lsof +D "$MOUNTPOINT" > /dev/null 2>&1; then
        fusermount -u "$MOUNTPOINT"
        rmdir "$MOUNTPOINT"
        break
    fi
done

