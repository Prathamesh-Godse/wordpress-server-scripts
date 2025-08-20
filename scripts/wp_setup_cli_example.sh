# Filename: wp_setup_cli_example.sh
#!/bin/bash
set -e

# --- User Inputs ---
read -p "Enter your domain URL (e.g., https://example.com): " SITE_URL
read -p "Enter admin username: " ADMIN_USER
read -sp "Enter admin password: " ADMIN_PASS
echo
read -p "Enter admin email: " ADMIN_EMAIL

# --- Paths ---
WEBROOT="/var/www/$(echo $SITE_URL | sed 's|https\?://||;s|/||')/public_html"
cd "$WEBROOT"

# --- Install WordPress if not installed ---
if ! wp core is-installed --allow-root; then
    wp core install \
        --url="$SITE_URL" \
        --title="Example Site" \
        --admin_user="$ADMIN_USER" \
        --admin_password="$ADMIN_PASS" \
        --admin_email="$ADMIN_EMAIL" \
        --skip-email \
        --allow-root
fi

# --- Permalinks: Post Name ---
wp rewrite structure '/%postname%/' --hard --allow-root

# --- Delete default posts ---
POSTS=$(wp post list --field=ID --allow-root)
if [ -n "$POSTS" ]; then
    wp post delete $POSTS --force --allow-root
fi

# --- Delete all pages ---
PAGES=$(wp post list --post_type=page --field=ID --allow-root)
if [ -n "$PAGES" ]; then
    wp post delete $PAGES --force --allow-root
fi

# --- Delete all plugins ---
PLUGINS=$(wp plugin list --field=name --status=inactive --allow-root)
if [ -n "$PLUGINS" ]; then
    wp plugin delete $PLUGINS --allow-root
fi

# --- Keep only 2024 theme, delete the rest ---
THEMES=$(wp theme list --field=name --status=inactive --allow-root)
for theme in $THEMES; do
    if [ "$theme" != "twentytwentyfour" ]; then
        wp theme delete "$theme" --allow-root
    fi
done

# --- Update admin nickname and display name ---
wp user update "$ADMIN_USER" --nickname="Admin" --display_name="Admin" --allow-root

# --- Install, activate, and configure Maintenance Mode plugin ---
MAINT_PLUGIN="wp-maintenance-mode"
wp plugin install "$MAINT_PLUGIN" --activate --allow-root

# Example: Enable Maintenance Mode (plugin-specific CLI may vary)
wp option update wmm_active 1 --allow-root

echo "✅ WordPress setup complete!"
echo "Admin URL: $SITE_URL/wp-admin/"
echo "Username: $ADMIN_USER"
echo "Password: $ADMIN_PASS"
