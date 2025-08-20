# Filename: setup_ssl_example.sh
#!/bin/bash
set -e

DOMAIN="example.com"
WEBROOT="/var/www/$DOMAIN/public_html"
NGINX_DIR="/etc/nginx"
SSL_DIR="$NGINX_DIR/ssl"

# --- Update and upgrade system ---
sudo apt update
sudo apt upgrade -y

# --- Install Certbot with Cloudflare DNS plugin ---
sudo apt install -y certbot python3-certbot-dns-cloudflare

# --- Obtain SSL certificate using webroot method ---
sudo certbot certonly --webroot -w "$WEBROOT" -d "$DOMAIN" -d "www.$DOMAIN"

echo "✅ SSL certificate obtained for $DOMAIN and www.$DOMAIN"
echo "Please copy and save the output from Certbot as a note for future reference."

# --- Create SSL directory and DH parameters ---
sudo mkdir -p "$SSL_DIR"
cd "$SSL_DIR"
sudo openssl dhparam -out dhparam.pem 2048

echo "✅ Diffie-Hellman parameters generated at $SSL_DIR/dhparam.pem"
