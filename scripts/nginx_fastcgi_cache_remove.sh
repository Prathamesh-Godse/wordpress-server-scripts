#!/bin/bash
# Script to remove FastCGI caching configuration for prathameshgodse.com

SITE_CONF="/etc/nginx/sites-available/prathameshgodse.com.conf"
INCLUDE_DIR="/etc/nginx/includes"
CACHE_EXCLUDE_CONF="$INCLUDE_DIR/fastcgi_cache_excludes.conf"
NGINX_CONF="/etc/nginx/nginx.conf"

echo "Backing up current configs..."
sudo cp "$SITE_CONF" "$SITE_CONF.bak"
sudo cp "$NGINX_CONF" "$NGINX_CONF.bak"
[ -f "$CACHE_EXCLUDE_CONF" ] && sudo cp "$CACHE_EXCLUDE_CONF" "$CACHE_EXCLUDE_CONF.bak"

echo "Removing FastCGI cache lines from site config..."
sudo sed -i '/# FASTCGI CACHING DIRECTIVES/,+4d' "$SITE_CONF"
sudo sed -i '/include.*fastcgi_cache_excludes.conf/d' "$SITE_CONF"
sudo sed -i '/add_header X-FastCGI-Cache/d' "$SITE_CONF"

echo "Removing fastcgi_cache_excludes.conf..."
sudo rm -f "$CACHE_EXCLUDE_CONF"

echo "Removing FastCGI directives from nginx.conf..."
sudo sed -i '/### FASTCGI CACHING/,/# virtual host configs/d' "$NGINX_CONF"

echo "Testing Nginx config..."
sudo nginx -t

echo "Reloading Nginx..."
sudo systemctl reload nginx

echo "FastCGI caching has been removed successfully."
