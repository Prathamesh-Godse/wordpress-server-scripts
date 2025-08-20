#!/bin/bash

# Script to configure sysctl settings and apply them

CONFIG_FILE="/etc/sysctl.d/custom_overrides.conf"

echo "Creating sysctl configuration file at $CONFIG_FILE ..."

# Write configuration into the file
sudo tee "$CONFIG_FILE" > /dev/null <<EOF
# SWAPPINESS AND CACHE PRESSURE
vm.swappiness = 1
vm.vfs_cache_pressure = 50

# IP SPOOFING
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1

# SYN FLOOD
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5

# SOURCE PACKET ROUTING
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# Increase number of usable ports
net.ipv4.ip_local_port_range = 1024 65535

# Increase the size of file handles and inode cache and restrict core dumps
fs.file-max = 2097152
fs.suid_dumpable = 0

# Change the number of incoming connections and backlog
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 262144

# Increase the maximum amount of memory buffers
net.core.optmem_max = 25165824

# Increase the default and maximum send/receive buffers
net.core.rmem_default = 31457280
net.core.rmem_max = 67108864
net.core.wmem_default = 31457280
net.core.wmem_max = 67108864
EOF

echo "Applying sysctl changes..."
sudo sysctl --system

echo "Rebooting system..."
sudo reboot
