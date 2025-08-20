# Filename: php_fpm_pool_example.sh
#!/bin/bash
set -e

USER="example"
DOMAIN="example.com"
PHP_VERSION="8.3"
WEBROOT="/var/www/$DOMAIN"
FPM_POOL_DIR="/etc/php/$PHP_VERSION/fpm/pool.d"
FPM_LOG="/var/log/fpm-php.$DOMAIN.log"
FPM_SOCK="/run/php/php$PHP_VERSION-fpm-$DOMAIN.sock"

# --- Create user and add to www-data group ---
sudo useradd -m "$USER" || true
sudo usermod -a -G "$USER" www-data
sudo usermod -a -G www-data "$USER"

# --- Check users' groups ---
id "$USER"
id ubuntu

# --- Create PHP-FPM pool config ---
cd "$FPM_POOL_DIR"
sudo cp www.conf "$DOMAIN.conf"

sudo sed -i "s/^\[www\]/\[$USER\]/" "$DOMAIN.conf"
sudo sed -i "s/^user = .*/user = $USER/" "$DOMAIN.conf"
sudo sed -i "s/^group = .*/group = $USER/" "$DOMAIN.conf"
sudo sed -i "s|^listen = /run/php/php$PHP_VERSION-fpm.sock|listen = $FPM_SOCK|" "$DOMAIN.conf"

# Update rlimits
sudo sed -i "s/^;*rlimit_files.*/rlimit_files = 15000/" "$DOMAIN.conf"
sudo sed -i "s/^;*rlimit_core.*/rlimit_core = 100/" "$DOMAIN.conf"

# Set PHP error logging
sudo sed -i "s/^;*php_flag\[display_errors\].*/php_flag[display_errors] = off/" "$DOMAIN.conf"
sudo sed -i "s|^;*php_admin_value\[error_log\].*|php_admin_value[error_log] = $FPM_LOG|" "$DOMAIN.conf"
sudo sed -i "s/^;*php_admin_flag\[log_errors\].*/php_admin_flag[log_errors] = on/" "$DOMAIN.conf"

# --- Create log file ---
sudo touch "$FPM_LOG"
sudo chown "$USER":www-data "$FPM_LOG"
sudo chmod 660 "$FPM_LOG"

# --- Reload PHP-FPM ---
sudo systemctl reload php"$PHP_VERSION"-fpm

# --- Verify pool socket ---
sudo grep "listen = /" "$DOMAIN.conf"

# --- Update Nginx site config to use new PHP-FPM socket ---
NGINX_CONF="/etc/nginx/sites-available/$DOMAIN.conf"
sudo sed -i "s|fastcgi_pass unix:.*|fastcgi_pass unix:$FPM_SOCK;|" "$NGINX_CONF"

# --- Test and reload Nginx ---
sudo nginx -t
sudo systemctl reload nginx

# --- Go to site web root ---
cd "$WEBROOT" || true
ls -la
