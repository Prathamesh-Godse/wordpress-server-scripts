#!/bin/bash

sudo apt-cache search nginx
sudo apt-cache show njs

sudo apt update
sudo apt upgrade -y

sudo add-apt-repository -y ppa:ondrej/nginx

sudo apt install -y nginx libnginx-mod-http-cache-purge libnginx-mod-http-headers-more-filter libnginx-mod-http-brotli-filter libnginx-mod-http-brotli-static

sudo systemctl status nginx
sudo systemctl status nginx --no-pager -l

sudo sed -i.bak 's/^listen \[::\] 80 default_server;/# listen [::] 80 default_server;/' /etc/nginx/sites-available/default

sudo systemctl start nginx
sudo systemctl status nginx --no-pager -l
sudo systemctl is-enabled nginx

curl -I 127.0.0.1
curl -i 127.0.0.1

cd /var/www/html/
cat index.nginx-debian.html

nginx -v
