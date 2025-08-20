#!/bin/bash
# Script to disable WordPress post revisions in wp-config.php

WP_CONFIG="/var/www/example.com/public_html/wp-config.php"

# Check if wp-config.php exists
if [ ! -f "$WP_CONFIG" ]; then
    echo "Error: wp-config.php not found at $WP_CONFIG"
    exit 1
fi

# Add the disable post revisions line if it doesn't already exist
if ! grep -q "WP_POST_REVISIONS" "$WP_CONFIG"; then
    # Insert after the line containing 'AUTOMATIC_UPDATER_DISABLED'
    sudo sed -i "/AUTOMATIC_UPDATER_DISABLED/a \
/** DISABLE POST REVISIONS **/\
define('WP_POST_REVISIONS', false);" "$WP_CONFIG"
    echo "WP_POST_REVISIONS has been disabled."
else
    echo "WP_POST_REVISIONS is already set in wp-config.php"
fi
