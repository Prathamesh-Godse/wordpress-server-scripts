#!/bin/bash

sudo tee /etc/nginx/includes/timeouts.conf > /dev/null <<EOF
##
# TIMEOUTS
##
keepalive_timeout 5;
keepalive_requests 500;
lingering_time 20s;
lingering_timeout 5s;
keepalive_disable msie6;
reset_timedout_connection on;
send_timeout 15s;
client_header_timeout 8s;
client_body_timeout 10s;
EOF
