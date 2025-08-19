#!/bin/bash

# Create & Enable Swapfile Script (2GB)

echo "-----------------------------------"
echo "Checking current swap status..."
sudo swapon -s
echo "-----------------------------------"

echo "Creating 2GB swapfile..."
sudo dd if=/dev/zero of=/swapfile bs=1024 count=2097152 status=progress

echo "Setting correct permissions..."
sudo chmod 600 /swapfile

echo "Making swap space..."
sudo mkswap /swapfile

echo "Enabling swapfile..."
sudo swapon /swapfile

echo "-----------------------------------"
echo "New swap status:"
sudo swapon -s

echo "-----------------------------------"
echo "Adding swapfile entry to /etc/fstab..."
SWAP_ENTRY="/swapfile swap swap defaults 0 0"

# Backup fstab
sudo cp /etc/fstab /etc/fstab.bak.$(date +%F-%H%M%S)

# Only add if not already present
if ! grep -q "^/swapfile" /etc/fstab; then
    echo "$SWAP_ENTRY" | sudo tee -a /etc/fstab
    echo "Swap entry added to /etc/fstab"
else
    echo "Swap entry already exists in /etc/fstab"
fi

echo "-----------------------------------"
echo "Swapfile setup complete. Rebooting..."
sudo reboot
