# Filename: nginx_vhost_example.sh
#!/bin/bash
set -e

DOMAIN="example.com"
WWW_DOMAIN="www.example.com"
SITES_AVAILABLE="/etc/nginx/sites-available"
SITES_ENABLED="/etc/nginx/sites-enabled"
WEBROOT="/var/www/$DOMAIN/public_html"
CONF_FILE="$SITES_AVAILABLE/$DOMAIN.conf"

# Go to sites-available directory
cd "$SITES_AVAILABLE"

# Test DNS resolution
ping -c2 "$DOMAIN" || true
ping -c2 "$WWW_DOMAIN" || true

# Create web root directory if not exists
sudo mkdir -p "$WEBROOT"

# Create Nginx configuration file
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
    }

    access_log /var/log/nginx/access.log.$DOMAIN.log combined buffer=256k flush=60m;
    error_log /var/log/nginx/error.log.$DOMAIN.log;
}
EOF

# Enable site by creating symlink
if [ ! -f "$SITES_ENABLED/$DOMAIN.conf" ]; then
    sudo ln -s "$CONF_FILE" "$SITES_ENABLED/$DOMAIN.conf"
fi

# Test Nginx configuration
sudo nginx -t

# Reload Nginx to apply changes
sudo systemctl reload nginx
