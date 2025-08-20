#!/bin/bash

# Script Name: harden_php.sh
# Purpose: Harden PHP configuration and reload php8.3-fpm

CONF_DIR="/etc/php/8.3/fpm/conf.d"
CONF_FILE="$CONF_DIR/server_override.ini"

echo "HARDENING PHP CONFIGURATION..."

# Ensure the directory exists
if [ ! -d "$CONF_DIR" ]; then
    echo "Directory $CONF_DIR does not exist. Exiting..."
    exit 1
fi

# Write hardening settings
sudo tee "$CONF_FILE" > /dev/null <<EOL
; HARDEN PHP
allow_url_fopen = Off
cgi.fix_pathinfo = 0
expose_php = Off
EOL

echo "Configuration written to $CONF_FILE"

# Reload PHP-FPM service
echo "Reloading PHP 8.3 FPM..."
sudo systemctl reload php8.3-fpm

# Use your alias if available
if alias fpmr &>/dev/null; then
    echo "Running fpmr alias..."
    fpmr
fi

echo "PHP hardening complete!"
