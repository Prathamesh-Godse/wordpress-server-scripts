#!/bin/bash

echo "Starting main script..."

./script/ask_details.sh


setup_firewall.sh
setup_fail2ban.sh
setup_timezone.sh
disable_swap.sh
enable_swap.sh
tune_sysctl.sh
sysctl_info.sh
harden_shm.sh
check_shm.sh
disable_ipv6.sh
