# Filename: php_fpm_tmp_wp_cleanup.sh
#!/bin/bash
set -e

USER="example"
DOMAIN="example.com"
WEBROOT="/var/www/$DOMAIN/public_html"
PHP_VERSION="8.3"
FPM_POOL_CONF="/etc/php/$PHP_VERSION/fpm/pool.d/$DOMAIN.conf"
TMP_DIR="/var/www/$DOMAIN/tmp"

# --- Create temporary directory for uploads ---
sudo mkdir -p "$TMP_DIR"
sudo chown "$USER:$USER" "$TMP_DIR"
sudo chmod 770 "$TMP_DIR"

echo "✅ Temporary upload directory created at $TMP_DIR"

# --- Update PHP-FPM pool configuration ---
sudo sed -i "/upload_tmp_dir/d" "$FPM_POOL_CONF"
sudo sed -i "/sys_temp_dir/d" "$FPM_POOL_CONF"
sudo sed -i "/open_basedir/d" "$FPM_POOL_CONF"

sudo tee -a "$FPM_POOL_CONF" > /dev/null <<EOF
php_admin_value[upload_tmp_dir] = $TMP_DIR
php_admin_value[sys_temp_dir] = $TMP_DIR
php_admin_value[open_basedir] = $WEBROOT/:$TMP_DIR/
EOF

echo "✅ PHP-FPM pool configuration updated for tmp directories and open_basedir"

# --- Reload PHP-FPM ---
sudo systemctl reload php"$PHP_VERSION"-fpm

# --- WordPress cleanup using WP-CLI ---
cd "$WEBROOT"

# Delete all posts
POSTS=$(wp post list --field=ID --allow-root)
if [ -n "$POSTS" ]; then
    wp post delete $POSTS --force --allow-root
fi

# Delete all pages
PAGES=$(wp post list --post_type=page --field=ID --allow-root)
if [ -n "$PAGES" ]; then
    wp post delete $PAGES --force --allow-root
fi

# Delete all plugins
PLUGINS=$(wp plugin list --field=name --status=inactive --allow-root)
if [ -n "$PLUGINS" ]; then
    wp plugin delete $PLUGINS --allow-root
fi

# Keep only Twenty Twenty-Four theme, delete the rest
THEMES=$(wp theme list --field=name --status=inactive --allow-root)
for theme in $THEMES; do
    if [ "$theme" != "twentytwentyfour" ]; then
        wp theme delete "$theme" --allow-root
    fi
done

echo "✅ WordPress cleanup done. You can now upgrade WP from browser if needed."
