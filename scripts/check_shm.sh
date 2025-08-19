#!/bin/bash

# Check /dev/shm hardening

echo "-----------------------------------"
echo "Checking /dev/shm mount options..."
mount | grep shm

echo "-----------------------------------"
if mount | grep -q "/dev/shm"; then
    OPTIONS=$(mount | grep /dev/shm | awk -F'(' '{print $2}' | tr -d ')')

    echo "Current options: $OPTIONS"
    echo "-----------------------------------"

    if echo "$OPTIONS" | grep -q "noexec" && \
       echo "$OPTIONS" | grep -q "nosuid" && \
       echo "$OPTIONS" | grep -q "nodev"; then
        echo "✅ /dev/shm is hardened correctly (noexec,nosuid,nodev present)."
    else
        echo "⚠️  /dev/shm is missing one or more hardening options."
        echo "Expected: noexec,nosuid,nodev"
    fi
else
    echo "❌ /dev/shm is not mounted."
fi
