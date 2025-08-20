#!/bin/bash

sudo tee /etc/nginx/includes/buffers.conf > /dev/null <<EOF
##
# BUFFERS
##
client_body_buffer_size 256k;
client_body_in_file_only off;
client_header_buffer_size 64k;
# client max body size - reduce size to 8m after setting up site
# Large value is to allow theme, plugins or asset uploading.
client_max_body_size 100m;
connection_pool_size 512;
directio 4m;
ignore_invalid_headers on;
large_client_header_buffers 8 64k;
output_buffers 8 256k;
postpone_output 1460;
request_pool_size 32k;
EOF
