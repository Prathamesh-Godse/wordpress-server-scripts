#!/bin/bash
# Script to set PHP-FPM memory limit and WordPress memory limit

# Variables
POOL_CONF="/etc/php/8.3/fpm/pool.d/example.com.conf"
WP_CONFIG="/var/www/example.com/public_html/wp-config.php"

# Update PHP-FPM memory limit
if [ -f "$POOL_CONF" ]; then
    sudo sed -i "s/^\s*php_admin_value\[memory_limit\].*$/php_admin_value[memory_limit] = 256M/" "$POOL_CONF"
    echo "PHP-FPM memory_limit updated to 256M in $POOL_CONF"
else
    echo "Error: $POOL_CONF not found."
fi

# Update WordPress memory limit
if [ -f "$WP_CONFIG" ]; then
    if ! grep -q "WP_MEMORY_LIMIT" "$WP_CONFIG"; then
        sudo sed -i "/\/\*\* DISABLE POST REVISIONS/a \
/** MEMORY LIMIT */\
define('WP_MEMORY_LIMIT', '256M');" "$WP_CONFIG"
        echo "WP_MEMORY_LIMIT set to 256M in $WP_CONFIG"
    else
        echo "WP_MEMORY_LIMIT already exists in $WP_CONFIG"
    fi
else
    echo "Error: $WP_CONFIG not found."
fi

# Reload PHP-FPM
sudo systemctl reload php8.3-fpm
echo "PHP-FPM reloaded."
