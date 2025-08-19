#!/bin/bash

# Fail2Ban Setup Script

# Download the Fail2Ban .deb package
echo "Downloading Fail2Ban..."
wget -O fail2ban.deb https://github.com/fail2ban/fail2ban/releases/download/1.1.0/fail2ban_1.1.0-1.upstream1_all.deb

# Install Fail2Ban
echo "Installing Fail2Ban..."
sudo dpkg -i fail2ban.deb || true
sudo apt -f install -y

# Check status
echo "Checking Fail2Ban status..."
sudo systemctl status fail2ban --no-pager

# Configure jail.local
echo "Configuring Fail2Ban..."
cd /etc/fail2ban || exit 1

# Backup if jail.local already exists
if [ -f jail.local ]; then
    sudo cp jail.local jail.local.bak.$(date +%F-%H%M%S)
    echo "Existing jail.local backed up."
else
    sudo cp jail.conf jail.local
fi

# Apply settings (replace or append)
sudo sed -i 's/^bantime\s*=.*/bantime = 7d/' jail.local
sudo sed -i 's/^findtime\s*=.*/findtime = 3h/' jail.local
sudo sed -i 's/^maxretry\s*=.*/maxretry = 3/' jail.local

# Ensure [sshd] jail is enabled
sudo bash -c 'cat >> jail.local <<EOF

[sshd]
mode = aggressive
port = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s
enabled = true
EOF'

# Restart Fail2Ban
echo "Restarting Fail2Ban..."
sudo systemctl restart fail2ban
sudo systemctl status fail2ban --no-pager

# Show logs
echo "Displaying logs..."
cd /var/log/ || exit 1
ls -lh | grep -E "auth.log|fail2ban.log"

sudo tail -n 20 auth.log
sudo tail -n 20 fail2ban.log

echo "Fail2Ban setup complete."
