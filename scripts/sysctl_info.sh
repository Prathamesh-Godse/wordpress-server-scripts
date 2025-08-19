#!/bin/bash

# sysctl-info.sh
# A helper script to view kernel parameters

echo "-----------------------------------"
echo "Kernel Parameters via sysctl"
echo "-----------------------------------"

# If user passes "all", show everything
if [[ "$1" == "all" ]]; then
    echo "Showing ALL kernel parameters..."
    sudo sysctl -a
    exit 0
fi

# Otherwise, filter common tunables
echo "Showing common tunables (memory, cache, networking):"
sudo sysctl -a | grep -E "swappiness|vfs_cache_pressure|file-max|ip_forward|tcp_|udp_|net.core"

echo "-----------------------------------"
echo "Tip: Run './sysctl-info.sh all' to see the full list."
