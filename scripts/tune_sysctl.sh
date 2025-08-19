#!/bin/bash

# Kernel parameter tuning: swappiness & cache pressure

echo "-----------------------------------"
echo "Checking current swap usage:"
sudo swapon -s
echo "-----------------------------------"

echo "Launching htop (press q to quit when ready)..."
sleep 2
htop

echo "-----------------------------------"
echo "Dumping current sysctl settings..."
sudo sysctl -a | grep -E 'swappiness|vfs_cache_pressure'
echo "-----------------------------------"

echo "Navigating to /etc/sysctl.d..."
cd /etc/sysctl.d || exit 1

# Create or overwrite custom_overrides.conf
echo "Applying kernel parameter overrides..."
sudo tee custom_overrides.conf > /dev/null <<EOF
# SWAPPINESS AND CACHE PRESSURE
vm.swappiness=1
vm.vfs_cache_pressure=50
EOF

echo "-----------------------------------"
echo "Verifying contents of /etc/sysctl.d/custom_overrides.conf:"
cat custom_overrides.conf
echo "-----------------------------------"

echo "Reloading sysctl parameters..."
sudo sysctl --system | grep -E 'swappiness|vfs_cache_pressure'

echo "-----------------------------------"
echo "Rebooting to apply changes permanently..."
sudo reboot
