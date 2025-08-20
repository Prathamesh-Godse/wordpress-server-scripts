# Filename: nginx_ssl_setup_example.sh
#!/bin/bash
set -e

DOMAIN="example.com"
NGINX_SSL_DIR="/etc/nginx/ssl"
LETSENCRYPT_DIR="/etc/letsencrypt/live/$DOMAIN"

# --- Verify Let's Encrypt directory exists ---
if [ ! -d "$LETSENCRYPT_DIR" ]; then
    echo "❌ Let's Encrypt directory $LETSENCRYPT_DIR does not exist."
    exit 1
fi

# --- Create SSL per-site config ---
SSL_SITE_CONF="$NGINX_SSL_DIR/ssl_$DOMAIN.conf"
sudo tee "$SSL_SITE_CONF" > /dev/null <<EOF
ssl_certificate $LETSENCRYPT_DIR/fullchain.pem;
ssl_certificate_key $LETSENCRYPT_DIR/privkey.pem;
ssl_trusted_certificate $LETSENCRYPT_DIR/chain.pem;
EOF

echo "✅ SSL per-site config created: $SSL_SITE_CONF"
readlink -f "$SSL_SITE_CONF"

# --- Create SSL all-sites config for strong security ---
SSL_ALL_CONF="$NGINX_SSL_DIR/ssl_all_sites.conf"
sudo tee "$SSL_ALL_CONF" > /dev/null <<'EOF'
# CONFIGURATION RESULTS IN A+ RATING AT SSLLABS.COM
# WILL UPDATE DIRECTIVES TO MAINTAIN A+ RATING - CHECK DATE
# DATE: MAY 2025

# SSL CACHING AND PROTOCOLS
ssl_session_cache shared:SSL:20m;
ssl_session_timeout 180m;
ssl_protocols TLSv1.2 TLSv1.3;
ssl_prefer_server_ciphers on;
# ssl_ciphers must be on a single line, do not split over multiple lines
ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:DHE-RSA-CHACHA20-POLY1305;
ssl_dhparam /etc/nginx/ssl/dhparam.pem;
# LETS ENCRYPT REMOVED SUPPORT 7 MAY 2025 FOR SSL STAPLING
# REMOVE OR COMMENT BOTH ssl_stapling directives
#ssl_stapling on;
#ssl_stapling_verify on;

# resolver set to Cloudflare
# timeout can be set up to 30s
resolver 1.1.1.1 1.0.0.1;
resolver_timeout 15s;
ssl_session_tickets off;
# HSTS HEADERS
add_header Strict-Transport-Security "max-age=31536000;" always;
# After setting up ALL of your sub domains - comment the above and uncomment the directive hereunder, then re
# add_header Strict-Transport-Security "max-age=31536000; includeSubDomains;" always;
# Enable QUIC and HTTP/3
ssl_early_data on;
add_header Alt-Svc 'h3=":$server_port"; ma=86400';
add_header x-quic 'H3' ;
quic_retry on;
EOF

echo "✅ SSL all-sites config created: $SSL_ALL_CONF"
