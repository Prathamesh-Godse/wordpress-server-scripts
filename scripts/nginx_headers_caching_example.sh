# Filename: nginx_headers_caching_example.sh
#!/bin/bash
set -e

DOMAIN="example.com"
NGINX_INCLUDES="/etc/nginx/includes"
SITE_CONF="/etc/nginx/sites-available/$DOMAIN.conf"

# --- Check HTTPS headers ---
curl -I "https://$DOMAIN"

# --- Create http_headers.conf ---
sudo tee "$NGINX_INCLUDES/http_headers.conf" > /dev/null <<'EOF'
# -------------------------------------------------------
# Add Header Referrer-Policy - Uncomment desired directive
# -------------------------------------------------------
#add_header Referrer-Policy "no-referrer";
add_header Referrer-Policy "strict-origin-when-cross-origin";
#add_header Referrer-Policy "unsafe-url";
# ------------------------------------------------------
add_header X-Content-Type-Options "nosniff";
add_header X-Frame-Options "sameorigin";
add_header X-XSS-Protection "1; mode=block";
add_header Permissions-Policy "geolocation=(),midi=(),sync-xhr=(),microphone=(),camera=(),magnetometer=(),gyroscope=(),fullscreen=self https://www.youtube.com, payment=()";
EOF

echo "✅ HTTP security headers configured at $NGINX_INCLUDES/http_headers.conf"

# --- Include http_headers.conf in site config above PHP block ---
sudo sed -i "/location ~ \\\.php\$/i include $NGINX_INCLUDES/http_headers.conf;" "$SITE_CONF"

# --- Update browser_caching.conf ---
for block in "$NGINX_INCLUDES/browser_caching.conf"; do
sudo sed -i 's|expires 365d;.*|expires 30d;\netag on;\nif_modified_since exact;\nadd_header Pragma "public";\nadd_header Cache-Control "public, no-transform";\ntry_files $uri $uri/ /index.php?$args;\ninclude /etc/nginx/includes/http_headers.conf;\naccess_log off;|' "$block"
done

echo "✅ Nginx browser caching updated with headers and proper caching"

# --- Test and reload Nginx ---
sudo nginx -t
sudo systemctl reload nginx

# --- Test CSS file headers ---
curl -I "https://$DOMAIN/wp-content/plugins/maintenance/load/css/style.css"

echo "✅ Nginx headers and caching applied for $DOMAIN"
