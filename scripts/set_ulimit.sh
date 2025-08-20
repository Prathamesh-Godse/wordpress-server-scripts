#!/bin/bash

ulimit -Hn
ulimit -Sn

cd /etc/security/limits.d

sudo tee custom_directives.conf > /dev/null <<EOF
#<domain>       <type>  <item>  <value>
*               soft    nofile  120000
*               hard    nofile  120000
root            soft    nofile  120000
root            hard    nofile  120000
EOF

sudo reboot
