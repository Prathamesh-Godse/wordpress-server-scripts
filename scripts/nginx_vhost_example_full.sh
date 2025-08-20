# Filename: nginx_vhost_example_full.sh
#!/bin/bash
set -e

DOMAIN="example.com"
WWW_DOMAIN="www.example.com"
SITES_AVAILABLE="/etc/nginx/sites-available"
SITES_ENABLED="/etc/nginx/sites-enabled"
WEBROOT="/var/www/$DOMAIN/public_html"
CONF_FILE="$SITES_AVAILABLE/$DOMAIN.conf"
INCLUDES_DIR="/etc/nginx/includes"

# Ensure web root exists
sudo mkdir -p "$WEBROOT"

# Ensure includes directory exists
sudo mkdir -p "$INCLUDES_DIR"

# Create Nginx configuration file for the site
cat <<EOF | sudo tee "$CONF_FILE" > /dev/null
server {
    listen 80;
    server_name $DOMAIN $WWW_DOMAIN;

    root $WEBROOT;
    index index.php;

    location / {
        try_files \$uri \$uri/ /index.php\$is_args\$args;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        include $INCLUDES_DIR/fastcgi_optimize.conf;
    }

    include $INCLUDES_DIR/browser_caching.conf;
    access_log /var/log/nginx/access.log.$DOMAIN.log combined buffer=256k flush=60m;
    error_log /var/log/nginx/error.log.$DOMAIN.log;
}
EOF

# Enable the site by creating a symlink if it doesn't exist
if [ ! -f "$SITES_ENABLED/$DOMAIN.conf" ]; then
    sudo ln -s "$CONF_FILE" "$SITES_ENABLED/$DOMAIN.conf"
fi

# List sites-available and sites-enabled
ls -l "$SITES_AVAILABLE"
ls -l "$SITES_ENABLED"

# Test Nginx configuration
sudo nginx -t

# Reload Nginx to apply changes
sudo systemctl reload nginx
