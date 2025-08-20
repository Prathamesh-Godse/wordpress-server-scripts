#!/bin/bash

sudo apt install -y mariadb-server

sudo systemctl status mariadb
sudo systemctl status mariadb --no-pager -l
sudo systemctl is-enabled mariadb

sudo add-apt-repository -y ppa:ondrej/php

sudo apt install -y php8.3-{fpm,gd,mbstring,mysql,xml,xmlrpc,opcache,cli,zip,soap,intl,bcmath,curl,imagick,ssh2}

sudo systemctl status php8.3-fpm
sudo systemctl is-enabled php8.3-fpm
