# Filename: set_permissions_example.sh
#!/bin/bash
set -e

DOMAIN="example.com"
WEBROOT="/var/www/$DOMAIN/public_html"

# Go to site directory
cd "/var/www/$DOMAIN"

# Set directory permissions to 770
sudo find "$WEBROOT" -type d -exec chmod 770 {} \;

# Set file permissions to 660
sudo find "$WEBROOT" -type f -exec chmod 660 {} \;

echo "✅ Permissions applied for $WEBROOT"
