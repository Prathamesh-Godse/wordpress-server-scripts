#!/bin/bash
# Filename: setup_mysql_tuner.sh

set -e

echo "=== Cleaning up old files ==="
cd ~
rm -f fail2ban.deb

echo "=== Creating MySqlTuner directory ==="
mkdir -p MySqlTuner
cd MySqlTuner

echo "=== Downloading MySQLTuner ==="
wget http://mysqltuner.pl/ -O mysqltuner.pl

echo "=== Making mysqltuner.pl executable ==="
chmod +x mysqltuner.pl

echo "=== Running MySQLTuner ==="
sudo ./mysqltuner.pl

echo "=== Checking MySQL processes ==="
ps aux | grep mysql

# Get MariaDB PID dynamically
MARIADB_PID=$(pgrep -x mariadbd || pgrep -x mysqld)

if [[ -n "$MARIADB_PID" ]]; then
    echo "=== Showing limits for MariaDB (PID: $MARIADB_PID) ==="
    cat /proc/$MARIADB_PID/limits
else
    echo "MariaDB is not running, skipping limits check."
fi

echo "=== Creating systemd override directory for MariaDB ==="
sudo mkdir -p /etc/systemd/system/mariadb.service.d

echo "=== Writing limits.conf override ==="
cat <<EOF | sudo tee /etc/systemd/system/mariadb.service.d/limits.conf
[Service]
LimitNOFILE=40000
EOF

echo "=== Reloading systemd and restarting MariaDB ==="
sudo systemctl daemon-reload
sudo systemctl restart mariadb

echo "=== Checking MySQL processes again ==="
ps aux | grep mysql

if [[ -n "$MARIADB_PID" ]]; then
    echo "=== New limits for MariaDB (PID: $MARIADB_PID) ==="
    cat /proc/$MARIADB_PID/limits
fi

echo "=== Setup complete ==="
