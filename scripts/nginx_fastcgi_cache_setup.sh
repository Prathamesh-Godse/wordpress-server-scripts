#!/bin/bash
# Script to configure Nginx FastCGI caching for prathameshgodse.com

NGINX_CONF="/etc/nginx/nginx.conf"
SITE_CONF="/etc/nginx/sites-available/prathameshgodse.com.conf"
INCLUDE_DIR="/etc/nginx/includes"
CACHE_EXCLUDE_CONF="$INCLUDE_DIR/fastcgi_cache_excludes.conf"
CACHE_PATH="/var/run/prathameshgodse"
CACHE_ZONE="prathameshgodse"

# 1. Add FastCGI cache path to nginx.conf if not already present
if ! grep -q "fastcgi_cache_path $CACHE_PATH" "$NGINX_CONF"; then
    sudo bash -c "cat >> $NGINX_CONF <<EOF

### FASTCGI CACHING
fastcgi_cache_path $CACHE_PATH levels=1:2 keys_zone=$CACHE_ZONE:100m inactive=60m;
fastcgi_cache_key \"\$scheme\$request_method\$host\$request_uri\";
fastcgi_cache_use_stale error timeout invalid_header http_500;
fastcgi_ignore_headers Cache-Control Expires Set-Cookie;
EOF"
    echo "FastCGI cache path added to $NGINX_CONF"
else
    echo "FastCGI cache path already exists in $NGINX_CONF"
fi

# 2. Create fastcgi_cache_excludes.conf if not exists
sudo mkdir -p "$INCLUDE_DIR"
if [ ! -f "$CACHE_EXCLUDE_CONF" ]; then
    sudo bash -c "cat > $CACHE_EXCLUDE_CONF <<'EOF'
# NGINX SKIP CACHE INCLUDE FILE
set \$skip_cache 0;
if (\$request_method = POST) { set \$skip_cache 1; }
if (\$query_string != '') { set \$skip_cache 1; }
if (\$request_uri ~* '/wp-admin/|/xmlrpc.php|wp-.*.php|/feed/|index.php|sitemap(_index)?.xml') { set \$skip_cache 1; }
if (\$http_cookie ~* 'comment_author|wordpress_[a-f0-9]+|wp-postpass|wordpress_no_cache|wordpress_logged_in') { set \$skip_cache 1; }
EOF"
    echo "Created $CACHE_EXCLUDE_CONF"
fi

# 3. Update site config with caching directives
if ! grep -q "fastcgi_cache_bypass" "$SITE_CONF"; then
    sudo sed -i "/location ~ \\\.php\$/a \    # FASTCGI CACHING DIRECTIVES\n    fastcgi_cache_bypass \$skip_cache;\n    fastcgi_no_cache \$skip_cache;\n    fastcgi_cache $CACHE_ZONE;\n    fastcgi_cache_valid 60m;" "$SITE_CONF"
fi

if ! grep -q "include.*fastcgi_cache_excludes.conf" "$SITE_CONF"; then
    sudo sed -i "/location \/ {/a \    include $CACHE_EXCLUDE_CONF;\n    add_header X-FastCGI-Cache \$upstream_cache_status;" "$SITE_CONF"
fi

# 4. Test and reload Nginx
sudo nginx -t && sudo systemctl reload nginx

echo "FastCGI caching configuration applied successfully."
