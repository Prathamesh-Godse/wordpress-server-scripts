#!/bin/bash

cd /etc/mysql/mariadb.conf.d

sudo sed -i.bak '/^\[mysqld\]/a \
#user          = mysql\npid-file       = /run/mysqld/mysqld.pid\nbasedir        = /usr\n#datadir       = /var/lib/mysql\n#tmpdir        = /tmp\n\n# Performance Schema\nperformance_schema=ON\nperformance-schema-instrument='"'"'stage/%=ON'"'"'\nperformance-schema-consumer-events-stages-current=ON\nperformance-schema-consumer-events-stages-history=ON\nperformance-schema-consumer-events-stages-history-long=ON\n' 50-server.cnf

sudo systemctl restart mariadb

tee -a ~/.bash_aliases > /dev/null <<EOF
alias mariare='sudo systemctl restart mariadb'
EOF

sudo reboot
