#!/bin/bash

sudo tee /etc/nginx/includes/basic_settings.conf > /dev/null <<EOF
##
# BASIC SETTINGS
##
charset utf-8;
sendfile on;
sendfile_max_chunk 512k;
tcp_nopush on;
tcp_nodelay on;
server_tokens off;
more_clear_headers 'Server';
more_clear_headers 'X-Powered';
server_name_in_redirect off;
server_names_hash_bucket_size 64;
variables_hash_max_size 2048;
types_hash_max_size 2048;
include /etc/nginx/mime.types;
default_type application/octet-stream;
EOF
