#!/bin/bash
# Script to add rate limiting for a WordPress site on Nginx

NGINX_CONF="/etc/nginx/nginx.conf"
SITE_CONF="/etc/nginx/sites-available/example.com.conf"
RATE_LIMIT_CONF="/etc/nginx/includes/rate_limiting_example.com.conf"

# Add global rate limit zone in nginx.conf
if ! grep -q "limit_req_zone.*zone=wp" "$NGINX_CONF"; then
    sudo sed -i "/gzip_types/a\\
\\
##\n# Rate Limiting\nlimit_req_zone \$binary_remote_addr zone=wp:10m rate=30r/m;\n" "$NGINX_CONF"
    echo "Added rate limiting zone to $NGINX_CONF"
else
    echo "Rate limiting zone already exists in $NGINX_CONF"
fi

# Create the rate limiting include file
sudo tee "$RATE_LIMIT_CONF" > /dev/null <<'EOF'
location = /wp-login.php {
    limit_req zone=wp burst=20 nodelay;
    limit_req_status 444;
    include snippets/fastcgi-php.conf;
    fastcgi_param HTTP_HOST $host;
    fastcgi_pass unix:/run/php/php8.3-fpm-example.sock;
    include /etc/nginx/includes/fastcgi_optimize.conf;
}

location = /xmlrpc.php {
    limit_req zone=wp burst=20 nodelay;
    limit_req_status 444;
    include snippets/fastcgi-php.conf;
    fastcgi_param HTTP_HOST $host;
    fastcgi_pass unix:/run/php/php8.3-fpm-example.sock;
    include /etc/nginx/includes/fastcgi_optimize.conf;
}
EOF

echo "Created rate limiting file at $RATE_LIMIT_CONF"

# Include the rate limiting file in the site config if not already included
if ! grep -qF "$RATE_LIMIT_CONF" "$SITE_CONF"; then
    sudo sed -i "/location ~ \\\.php\$/a include $RATE_LIMIT_CONF;" "$SITE_CONF"
    echo "Included rate limiting file in $SITE_CONF"
else
    echo "Rate limiting already included in $SITE_CONF"
fi

# Test Nginx configuration and reload
sudo nginx -t
if [ $? -eq 0 ]; then
    sudo systemctl reload nginx
    echo "Nginx reloaded successfully with rate limiting."
else
    echo "Nginx configuration test failed. Please check manually."
fi

echo "Next steps (manual in WordPress):"
echo "1. Login to WP admin."
echo "2. Install 'Ninja Firewall' plugin."
echo "3. Activate and set 'Full WAF mode'."
echo "4. Select HTTP server: Nginx + CGI/FastCGI or PHP-FPM."
echo "5. Finish installation."
