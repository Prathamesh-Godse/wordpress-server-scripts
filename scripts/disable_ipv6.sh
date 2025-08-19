#!/bin/bash

# Script to disable IPv6 via GRUB

GRUB_FILE="/etc/default/grub"
DISABLE_STRING='ipv6.disable=1'

echo "Checking if IPv6 is enabled..."
ip a | grep inet6 && echo "IPv6 currently enabled" || echo "IPv6 not found"

echo "Backing up grub config..."
sudo cp $GRUB_FILE ${GRUB_FILE}.bak.$(date +%F-%H%M%S)

echo "Updating GRUB_CMDLINE_LINUX..."
if grep -q "$DISABLE_STRING" $GRUB_FILE; then
    echo "IPv6 disable flag already present."
else
    sudo sed -i "s/^\(GRUB_CMDLINE_LINUX=\".*\)\"/\1 $DISABLE_STRING\"/" $GRUB_FILE
fi

echo "Updating grub..."
sudo update-grub

echo "Done ✅ Please reboot the system for changes to take effect."
