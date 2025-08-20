#!/bin/bash
# Script to restrict database privileges and note plugin activation

# Set variables
DB_NAME="example_com"
DB_USER=$(grep DB_USER wp-config.php | cut -d"'" -f4)
DB_PASS=$(grep DB_PASSWORD wp-config.php | cut -d"'" -f4)

echo "Database user detected: $DB_USER"

# Restrict DB privileges
sudo mysql -e "REVOKE ALL PRIVILEGES ON ${DB_NAME}.* FROM '${DB_USER}'@'localhost';"
sudo mysql -e "GRANT SELECT, INSERT, UPDATE, DELETE ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo mysql -e "SHOW GRANTS FOR '${DB_USER}'@'localhost';"

echo ""
echo "Database privileges for ${DB_USER} have been restricted to basic CRUD operations."
echo "Next step (manual in WordPress):"
echo "1. Install 'Disable REST API' plugin."
echo "2. Activate it and configure settings as needed."
