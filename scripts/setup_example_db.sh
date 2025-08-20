# Filename: setup_example_db.sh
#!/bin/bash
set -e

DOMAIN="example.com"
DB_NAME="${DOMAIN//./_}"  # example_com

# Generate random DB user and password
DB_USER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
DB_PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)

# Generate random admin credentials
ADMIN_USER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 30 | head -n 1)
ADMIN_PASS=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 30 | head -n 1)

# Show DNS resolution for domain
echo "Checking DNS for $DOMAIN and www.$DOMAIN..."
nslookup "$DOMAIN"
nslookup "www.$DOMAIN"

# List Nginx site configs
echo "Nginx site configs:"
cd /etc/nginx
ls -l sites-*

cd sites-available
echo "Content of $DOMAIN.conf:"
sudo cat "$DOMAIN.conf"

# Display generated credentials
echo -e "\n--- Generated Database & Admin Credentials ---"
echo "Database Name: $DB_NAME"
echo "Database User: $DB_USER"
echo "Database Password: $DB_PASS"
echo "Admin User: $ADMIN_USER"
echo "Admin Password: $ADMIN_PASS"
echo "-------------------------------------------"

# Create MySQL database and user
echo "Creating MySQL database and user..."
sudo mysql -e "CREATE DATABASE $DB_NAME;"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
sudo mysql -e "FLUSH PRIVILEGES;"

echo "Database setup completed!"
