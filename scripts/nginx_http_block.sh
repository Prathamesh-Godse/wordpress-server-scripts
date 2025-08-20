#!/bin/bash

cd /etc/nginx

sudo sed -i.bak '/http {/,$d' nginx.conf

sudo tee -a nginx.conf > /dev/null <<EOF
http {
    ##
    # Basic Settings
    ##
    include /etc/nginx/includes/basic_settings.conf;
    ##
    # Buffer Settings
    include /etc/nginx/includes/buffers.conf;
    # Timeout Settings
    include /etc/nginx/includes/timeouts.conf;
    # File Handle Cache Settings
    include /etc/nginx/includes/file_handle_cache.conf;
    # Logging Settings
    ##
    access_log /var/log/nginx/access.log;
    ##
    # Gzip and Brotli Settings
    ##
    include /etc/nginx/includes/gzip.conf;
    include /etc/nginx/includes/brotli.conf;
    ##
    # Virtual Host Configs
    ##
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
EOF

sudo nginx -t
sudo systemctl reload nginx
