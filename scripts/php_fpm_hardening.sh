# Filename: php_fpm_hardening.sh
#!/bin/bash
set -e

# Go to php-fpm conf.d directory
cd /etc/php/8.3/fpm/conf.d

# Create or overwrite server_override.ini with hardened and optimized settings
cat <<EOF | sudo tee server_override.ini > /dev/null
# HARDEN PHP
allow_url_fopen = Off
cgi.fix_pathinfo = 0
expose_php = 0ff

# OPTIMIZE PHP
upload_max_filesize = 100M
post_max_size = 125M
max_input_vars = 3000
memory_limit = 256M
#max_execution_time = 90
#max_input_time= 60
EOF

# Reload PHP-FPM service (alias 'fpmr' assumed to mean restart/reload)
sudo systemctl reload php8.3-fpm || sudo systemctl restart php8.3-fpm

# Go to php-fpm main directory
cd /etc/php/8.3/fpm

# Backup the php-fpm.conf before editing
sudo cp php-fpm.conf php-fpm.conf.bak

# Insert rlimit changes into php-fpm.conf if not already present
sudo sed -i '/^;*rlimit_files/c\rlimit_files = 32768' php-fpm.conf
sudo sed -i '/^;*rlimit_core/c\rlimit_core = unlimited' php-fpm.conf

# Restart PHP-FPM to apply new limits
sudo systemctl restart php8.3-fpm

# Show running php-fpm processes
ps aux | grep php-fpm

# Display master process limits
MASTER_PID=$(pgrep -o php-fpm)
if [ -n "$MASTER_PID" ]; then
  echo "=== Master process ($MASTER_PID) limits ==="
  cat /proc/$MASTER_PID/limits
fi

# Display one www pool worker process limits
POOL_PID=$(pgrep -n php-fpm)
if [ -n "$POOL_PID" ]; then
  echo "=== Pool www process ($POOL_PID) limits ==="
  cat /proc/$POOL_PID/limits
fi
