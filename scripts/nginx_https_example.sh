# Filename: nginx_https_example.sh
#!/bin/bash
set -e

DOMAIN="example.com"
NGINX_SITES_AVAILABLE="/etc/nginx/sites-available"
SITE_CONF="$NGINX_SITES_AVAILABLE/$DOMAIN.conf"
SSL_SITE_CONF="/etc/nginx/ssl/ssl_$DOMAIN.conf"
SSL_ALL_CONF="/etc/nginx/ssl/ssl_all_sites.conf"

# --- Backup existing Nginx config ---
sudo cp "$SITE_CONF" "$SITE_CONF.bak"
echo "✅ Backup created at $SITE_CONF.bak"

# --- Insert HTTP to HTTPS redirect at the top ---
sudo sed -i "1i server {\n    listen 80;\n    server_name $DOMAIN www.$DOMAIN;\n    return 301 https://$DOMAIN\$request_uri;\n}" "$SITE_CONF"

# --- Alter existing server block to listen on SSL/HTTP2/HTTP3 ---
sudo sed -i "s/listen 80;/listen 443 ssl;\n    http2 on;\n    listen 443 quic reuseport;\n    http3 on;/" "$SITE_CONF"

# --- Add Cache-Control header in location / block ---
sudo sed -i "/location \/ {/a\    add_header Cache-Control 'no-cache,no-store';" "$SITE_CONF"

# --- Include SSL config files after closing bracket of location / ---
sudo sed -i "/location \/ {/a\    include $SSL_SITE_CONF;\n    include $SSL_ALL_CONF;" "$SITE_CONF"

# --- Add fastcgi_param HTTP_HOST $host; in location ~ \.php$ block ---
sudo sed -i "/location ~ \\\.php\$ {/a\    fastcgi_param HTTP_HOST \$host;" "$SITE_CONF"

# --- Test and reload Nginx ---
sudo nginx -t
sudo systemctl reload nginx

echo "✅ Nginx SSL/HTTPS configuration applied for $DOMAIN"
