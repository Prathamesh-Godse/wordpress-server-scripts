#!/bin/bash
# Script to disable WordPress cron and set up a system cron

WP_CONFIG="/var/www/example.com/public_html/wp-config.php"

# Disable WP cron
if [ -f "$WP_CONFIG" ]; then
    if ! grep -q "DISABLE_WP_CRON" "$WP_CONFIG"; then
        sudo sed -i "/\/\*\* MEMORY LIMIT \*\//a \
/** DISABLE WORDPRESS CRONS */\
define('DISABLE_WP_CRON', true);" "$WP_CONFIG"
        echo "DISABLE_WP_CRON added to wp-config.php"
    else
        echo "DISABLE_WP_CRON already exists in wp-config.php"
    fi
else
    echo "Error: $WP_CONFIG not found."
    exit 1
fi

# Add system cron to run WP cron every 15 minutes
(crontab -l 2>/dev/null; echo "*/15 * * * * wget -q -O - https://example.com/wp-cron.php?doing_wp_cron >/dev/null 2>&1") | crontab -

echo "System cron for wp-cron.php set every 15 minutes."
