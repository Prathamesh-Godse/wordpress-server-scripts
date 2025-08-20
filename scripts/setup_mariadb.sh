#!/bin/bash
# setup_mariadb.sh
# This script configures MariaDB with performance schema settings and sets an alias.

set -e

# Backup original config
CONFIG_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"
BACKUP_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf.bak"

echo "Backing up MariaDB config..."
sudo cp "$CONFIG_FILE" "$BACKUP_FILE"

# Append performance schema config if not already present
echo "Updating MariaDB configuration..."
sudo tee -a "$CONFIG_FILE" > /dev/null <<EOL

# Custom MariaDB Performance Schema settings
#user          = mysql
pid-file       = /run/mysqld/mysqld.pid
basedir        = /usr
#datadir       = /var/lib/mysql
#tmpdir        = /tmp

# Performance Schema
performance_schema=ON
performance-schema-instrument='stage/%=ON'
performance-schema-consumer-events-stages-current=ON
performance-schema-consumer-events-stages-history=ON
performance-schema-consumer-events-stages-history-long=ON
EOL

# Restart MariaDB
echo "Restarting MariaDB..."
sudo systemctl restart mariadb

# Add alias for quick restart
ALIASES_FILE="$HOME/.bash_aliases"
echo "Adding alias to $ALIASES_FILE..."
echo "alias mariare='sudo systemctl restart mariadb'" >> "$ALIASES_FILE"

# Reboot system
echo "Rebooting system..."
sudo reboot
