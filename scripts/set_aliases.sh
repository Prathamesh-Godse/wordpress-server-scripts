#!/bin/bash

cd ~

tee -a .bash_aliases > /dev/null <<EOF
alias ngt='sudo nginx -t'
alias ngr='sudo systemctl reload nginx'
alias fpmr='sudo systemctl reload php8.3-fpm'
EOF
