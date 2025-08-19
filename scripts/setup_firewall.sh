#!/bin/bash

# Firewall setup script
# Checks if UFW is enabled and configures accordingly

echo "Checking UFW status..."
ufw_status=$(sudo ufw status | grep -i "Status:" | awk '{print $2}')

if [ "$ufw_status" == "active" ]; then
    echo "UFW is already enabled. Applying rules..."
    sudo ufw status verbose

    sudo ufw allow http
    sudo ufw allow https/tcp
    sudo ufw allow https/udp
    sudo ufw allow ssh

    sudo ufw status verbose
    sudo ufw reload
    echo "Firewall rules updated. Rebooting..."
    sudo reboot
else
    echo "UFW is not enabled. Setting up and enabling..."
    sudo ufw status verbose

    sudo ufw default deny incoming
    sudo ufw default allow outgoing

    sudo ufw allow http
    sudo ufw allow https/tcp
    sudo ufw allow https/udp
    sudo ufw allow ssh

    echo "Enabling UFW..."
    sudo ufw enable

    sudo ufw status verbose
    echo "Firewall enabled and configured. Rebooting..."
    sudo reboot
fi
