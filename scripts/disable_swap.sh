#!/bin/bash

# Disable Swapfile Script

echo "-----------------------------------"
echo "Checking active swap:"
sudo swapon -s
echo "-----------------------------------"

echo "Showing running processes (htop)..."
echo "(Press q to quit htop and continue)"
sleep 2
htop

echo "-----------------------------------"
echo "Listing root directory:"
ls /

echo "-----------------------------------"
echo "Backing up /etc/fstab..."
cd /etc || exit 1
sudo cp fstab fstab.bak.$(date +%F-%H%M%S)

echo "Backup created: fstab.bak"
ls -la fstab*

echo "-----------------------------------"
echo "Disabling and removing swapfile..."
cd /
if [ -f swapfile ]; then
    echo "Removing swapfile..."
    sudo swapoff /swapfile 2>/dev/null || true
    sudo rm /swapfile
else
    echo "No swapfile found in /"
fi

echo "-----------------------------------"
echo "Verifying swap status:"
sudo swapon -s

echo "-----------------------------------"
echo "Rebooting system to apply changes..."
sudo reboot
