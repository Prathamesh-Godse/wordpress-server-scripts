#!/bin/bash

# Harden /dev/shm by updating /etc/fstab

echo "-----------------------------------"
echo "Backing up /etc/fstab..."
sudo cp /etc/fstab /etc/fstab.bak.$(date +%F-%H%M%S)
echo "Backup saved as /etc/fstab.bak.<timestamp>"

# Entry to be added
FSTAB_ENTRY="none /dev/shm tmpfs defaults,noexec,nosuid,nodev 0 0"

# Check if entry already exists
if grep -q "/dev/shm" /etc/fstab; then
    echo "An entry for /dev/shm already exists in /etc/fstab."
    echo "Skipping duplicate entry. Please review manually if needed."
else
    echo "Adding hardened /dev/shm entry to /etc/fstab..."
    echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab
fi

echo "-----------------------------------"
echo "Verifying /etc/fstab entry:"
grep "/dev/shm" /etc/fstab

echo "-----------------------------------"
echo "Remounting /dev/shm with secure options..."
sudo mount -o remount /dev/shm

echo "-----------------------------------"
echo "New mount options for /dev/shm:"
mount | grep /dev/shm

echo "-----------------------------------"
echo "Rebooting to apply changes permanently..."
sudo reboot
