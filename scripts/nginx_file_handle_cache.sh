#!/bin/bash

sudo tee /etc/nginx/includes/file_handle_cache.conf > /dev/null <<EOF
##
# FILE HANDLE CACHE
##
open_file_cache max=50000 inactive=60s;
open_file_cache_valid 120s;
open_file_cache_min_uses 2;
open_file_cache_errors off;
EOF
