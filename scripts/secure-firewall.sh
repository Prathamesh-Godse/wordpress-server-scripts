#!/bin/bash

ufw_status=$(sudo ufw status | grep -i "Status:" | awk '{print $2}')

if [[ "$ufw_status" == "active" ]]; then
    echo "UFW is enabled (active)."
    
    echo "Allowing HTTP (port 80)..."
    sudo ufw allow http

    echo "Allowing HTTPS over TCP (port 443)..."
    sudo ufw allow https/tcp

    echo "Allowing HTTPS over UDP (port 443)..."
    sudo ufw allow https/udp

    echo "Allowing SSH (port 22)"
    sudo ufw allow ssh

    echo "Checking updated UFW status..."
    sudo ufw status verbose
    sleep 5

    echo "Reloading UFW..."
    sudo ufw reload

    echo "Rebooting the system in 5 seconds. Press Ctrl+C to cancel."
    sleep 5
    sudo reboot
else
    echo "UFW is disabled (inactive). Enabling UFW..."

    echo "All incomming connections will be blocked..."
    sudo ufw default deny incoming

    echo "The system is being allowed to initiate the connection..."
    sudo ufw default allow outgoing

    echo "Allowing HTTP (port 80)..."
    sudo ufw allow http

    echo "Allowing HTTPS over TCP (port 443)..."
    sudo ufw allow https/tcp

    echo "Allowing HTTPS over UDP (port 443)..."
    sudo ufw allow https/udp

    echo "Allowing SSH (port 22)..."
    sudo ufw allow ssh

    echo "Activating the firewall with new rules..."
    sudo ufw enable

    echo "Checking updated UFW status..."
    sudo ufw status verbose
    sleep 5

    echo "Rebooting the system in 5 seconds. Press Ctrl+C to cancel."
    sudo reboot
fi
