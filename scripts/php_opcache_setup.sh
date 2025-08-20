#!/bin/bash
# Script to configure OPCache for PHP-FPM pool and count PHP files

FPM_POOL_CONF="/etc/php/8.3/fpm/pool.d/example.com.conf"
WEB_DIR="/var/www/"

# Add OPCache configuration if not already present
if ! grep -q "OPCACHE CONFIGURATION - DEVELOPMENT SERVER" "$FPM_POOL_CONF"; then
    sudo bash -c "cat >> $FPM_POOL_CONF <<'EOF'

; OPCACHE CONFIGURATION - DEVELOPMENT SERVER
php_admin_flag[opcache.enabled] = 1
php_admin_value[opcache.memory_consumption] = 256
php_admin_value[opcache.interned_strings_buffer] = 32
php_admin_value[opcache.max_accelerated_files] = 20000
php_admin_flag[opcache.validate_timestamps] = 1
php_admin_value[opcache.revalidate_freq] = 2
php_admin_flag[opcache.validate_permission] = 1

; OPCACHE CONFIGURATION - PRODUCTION SERVER
;php_admin_flag[opcache.enabled] = 1
;php_admin_value[opcache.memory_consumption] = 256
;php_admin_value[opcache.interned_strings_buffer] = 32
;php_admin_value[opcache.max_accelerated_files] = 20000
;php_admin_flag[opcache.validate_timestamps] = 0
;php_admin_flag[opcache.validate_permission] = 1
EOF"
    echo "OPCache configuration added to $FPM_POOL_CONF"
else
    echo "OPCache configuration already exists in $FPM_POOL_CONF"
fi

# Reload PHP-FPM
echo "Reloading PHP-FPM..."
sudo systemctl reload php8.3-fpm

# Count PHP files in web directory
PHP_FILE_COUNT=$(sudo find "$WEB_DIR" -type f -name "*.php" | wc -l)
echo "Total PHP files in $WEB_DIR: $PHP_FILE_COUNT"

echo "For more OPCache configuration options, visit: https://www.php.net/manual/en/opcache.configuration.php#ini.opcache.max-accelerated-files"
