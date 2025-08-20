# Filename: nginx_fastcgi_optimize.sh
#!/bin/bash
set -e

INCLUDES_DIR="/etc/nginx/includes"
CONF_FILE="$INCLUDES_DIR/fastcgi_optimize.conf"

# Ensure the includes directory exists
sudo mkdir -p "$INCLUDES_DIR"

# Create or overwrite the fastcgi_optimize.conf file
cat <<'EOF' | sudo tee "$CONF_FILE" > /dev/null
fastcgi_connect_timeout 60;
fastcgi_send_timeout 180;
fastcgi_read_timeout 180;
fastcgi_buffer_size 512k;
fastcgi_buffers 512 16k;
fastcgi_busy_buffers_size 1m;
fastcgi_temp_file_write_size 4m;
fastcgi_max_temp_file_size 4m;
fastcgi_intercept_errors on;
EOF

# Test Nginx configuration
sudo nginx -t

# Reload Nginx to apply changes
sudo systemctl reload nginx
