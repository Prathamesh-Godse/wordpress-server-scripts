#!/bin/bash

cd /etc/nginx/

sudo cp nginx.conf nginx.conf.bak

sudo tee nginx.conf > /dev/null <<EOF
user www-data;
worker_processes auto;
pid /run/nginx.pid;
error_log /var/log/nginx/error.log;
include /etc/nginx/modules-enabled/*.conf;
worker_rlimit_nofile 30000;
worker_priority -10;
timer_resolution 100ms;
pcre_jit on;

events {
    worker_connections 4096;
    accept_mutex on;
    accept_mutex_delay 200ms;
    use epoll;
}
EOF

sudo mkdir -p includes

cd includes

sudo touch basic_settings.conf buffers.conf timeouts.conf gzip.conf brotli.conf file_handle_cache.conf
