#!/bin/bash

sudo tee /etc/nginx/includes/gzip.conf > /dev/null <<EOF
##
# GZIP
##
gzip on;
gzip_vary on;
gzip_disable "MSIE [1-6]\.";
gzip_static on;
gzip_min_length 1400;
gzip_buffers 32 8k;
gzip_http_version 1.0;
gzip_comp_level 5;
gzip_proxied any;
gzip_types text/plain text/css text/xml application/javascript application/x-javascript application/xml application/xml+rss application/ecmascript application/json image/svg+xml;
EOF
