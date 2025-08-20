#!/bin/bash
# Script to temporarily include WP Super Cache exclusions and revert after use

SITE_CONF="/etc/nginx/sites-available/prathameshgodse.com.conf"
INCLUDE_FILE="/etc/nginx/includes/wp_super_cache_excludes.conf"

echo "Backing up site config..."
sudo cp "$SITE_CONF" "${SITE_CONF}.bak"

echo "Commenting original location / block and adding WP Super Cache include..."
sudo sed -i '/location \/ {/,/}/ s/^/##/' "$SITE_CONF"
sudo sed -i "/location ~ \\\.php\$/i include $INCLUDE_FILE;" "$SITE_CONF"

echo "Testing Nginx config..."
sudo nginx -t

echo "Reloading Nginx..."
sudo systemctl reload nginx

echo "WP Super Cache exclusions included. Perform WP Super Cache setup in WordPress dashboard manually now."

read -p "Press Enter after completing WP Super Cache setup to revert changes..." temp

echo "Reverting site config..."
sudo sed -i "/include $INCLUDE_FILE;/d" "$SITE_CONF"
sudo sed -i 's/^##//' "$SITE_CONF"

echo "Testing Nginx config..."
sudo nginx -t

echo "Reloading Nginx..."
sudo systemctl reload nginx

echo "WP Super Cache setup reverted to original state. Backup of original config: ${SITE_CONF}.bak"
