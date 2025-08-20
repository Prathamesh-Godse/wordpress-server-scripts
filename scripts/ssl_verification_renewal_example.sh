# Filename: ssl_verification_renewal_example.sh
#!/bin/bash
set -e

DOMAIN="example.com"

echo "🔹 Checking HTTP headers for $DOMAIN and www.$DOMAIN"

curl -I "http://$DOMAIN"
curl -I "http://www.$DOMAIN"
curl -I "https://$DOMAIN"
curl -I "https://www.$DOMAIN"

echo
echo "✅ Check SSL at https://www.ssllabs.com/ssltest/ for $DOMAIN"
echo "✅ Check HTTP/3 at https://http3check.net/"

echo
echo "🔹 Reminder: In browser, go to WordPress Dashboard > Settings > General"
echo "Change 'WordPress Address (URL)' and 'Site Address (URL)' to https://$DOMAIN and save changes"

# --- List installed certificates ---
sudo certbot certificates

# --- Set up cron jobs for automatic renewal ---
# Backup existing crontab
sudo crontab -l > /tmp/crontab_backup || true

# Add renew and reload jobs if not already present
sudo crontab -l | { cat; echo "00 1 14,28 * * certbot renew --force-renewal >/dev/null 2>&1"; } | sudo crontab -
sudo crontab -l | { cat; echo "00 2 14,28 * * systemctl reload nginx >/dev/null 2>&1"; } | sudo crontab -

echo "✅ Cron jobs added for Certbot renewal and Nginx reload"

# --- List current crontab for verification ---
sudo crontab -l
