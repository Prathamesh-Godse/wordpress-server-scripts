# Filename: nginx_browser_caching.sh
#!/bin/bash
set -e

INCLUDES_DIR="/etc/nginx/includes"
CONF_FILE="$INCLUDES_DIR/browser_caching.conf"

# Ensure the includes directory exists
sudo mkdir -p "$INCLUDES_DIR"

# Create or overwrite the browser_caching.conf file
cat <<'EOF' | sudo tee "$CONF_FILE" > /dev/null
location ~* \.(webp|3gp|gif|jpg|jpeg|png|ico|wmv|avi|asf|asx|mpg|mpeg|mp4|pls|mp3|mid|wav|swf|flv|exe|zip|tar|rar|gz|tgz|bz2|uha|7z|doc|docx|xls|xlsx|pdf|iso)$ {
    expires 365d;
    add_header Cache-Control "public, no-transform";
    access_log off;
}

location ~* \.(js)$ {
    expires 30d;
    add_header Cache-Control "public, no-transform";
    access_log off;
}

location ~* \.(css)$ {
    expires 30d;
    add_header Cache-Control "public, no-transform";
    access_log off;
}

location ~* \.(eot|svg|ttf|woff|woff2)$ {
    expires 30d;
    add_header Cache-Control "public, no-transform";
    access_log off;
}
EOF

# Test Nginx configuration
sudo nginx -t

# Reload Nginx to apply changes
sudo systemctl reload nginx
