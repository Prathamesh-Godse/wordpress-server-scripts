#!/bin/bash

# Interactive Timezone Setup Script

echo "-----------------------------------"
echo "Current time and settings:"
sudo timedatectl
echo "-----------------------------------"

echo "Available timezones:"
sudo timedatectl list-timezones
echo "-----------------------------------"

# Ask user to enter timezone
read -rp "Please type the timezone you want to set (e.g., Asia/Kolkata): " TZ

# Validate timezone
if sudo timedatectl list-timezones | grep -qx "$TZ"; then
    echo "Setting timezone to $TZ..."
    sudo timedatectl set-timezone "$TZ"
else
    echo "❌ Invalid timezone: $TZ"
    echo "Run the script again and choose from the list above."
    exit 1
fi

echo "-----------------------------------"
echo "Updated time and settings:"
sudo timedatectl
echo "-----------------------------------"

echo "Current system date and time:"
date
