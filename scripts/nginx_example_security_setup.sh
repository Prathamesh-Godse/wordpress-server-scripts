#!/bin/bash
# Script to include Nginx security directives for a site and reload Nginx

SITE_CONF="/etc/nginx/sites-available/example.com.conf"
SECURITY_CONF="/etc/nginx/includes/nginx_security_directives.conf"

# Ensure the security config exists
if [ ! -f "$SECURITY_CONF" ]; then
    echo "Error: Security config not found at $SECURITY_CONF"
    exit 1
fi

# Backup existing site config
sudo cp "$SITE_CONF" "${SITE_CONF}.bak"

# Check if include line already exists, add if not
if ! grep -qF "$SECURITY_CONF" "$SITE_CONF"; then
    # Insert the include above the location ~ \.php$ block
    sudo sed -i "/location ~ \\\.php\$/i include $SECURITY_CONF;" "$SITE_CONF"
    echo "Included $SECURITY_CONF in $SITE_CONF"
else
    echo "Security include already present in $SITE_CONF"
fi

# Test Nginx configuration
sudo nginx -t
if [ $? -ne 0 ]; then
    echo "Nginx configuration test failed. Aborting reload."
    exit 1
fi

# Reload Nginx
sudo systemctl reload nginx
echo "Nginx reloaded successfully."

# Optional: verify restricted file
echo "Verify in browser: https://example.com/readme.html (should return 403 or Not Found)"
