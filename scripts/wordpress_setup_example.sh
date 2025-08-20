# Filename: wordpress_setup_example.sh
#!/bin/bash
set -e

# Variables
DOMAIN="example.com"
WEBROOT="/var/www/$DOMAIN/public_html"
DB_NAME="${DOMAIN//./_}"  # example_com

# Prompt for DB credentials and salts
read -p "Enter DB User: " DB_USER
read -sp "Enter DB Password: " DB_PASS
echo
echo "Fetching WordPress salts..."
WP_SALTS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

# Download latest WordPress
cd ~
wget https://wordpress.org/latest.tar.gz
tar xf latest.tar.gz
cd wordpress

# Setup wp-config.php
mv wp-config-sample.php wp-config.php

# Replace database info and insert salts
sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sed -i "s/username_here/$DB_USER/" wp-config.php
sed -i "s/password_here/$DB_PASS/" wp-config.php

# Remove existing salt lines and insert generated salts
sed -i '/AUTH_KEY/d;/SECURE_AUTH_KEY/d;/LOGGED_IN_KEY/d;/NONCE_KEY/d;/AUTH_SALT/d;/SECURE_AUTH_SALT/d;/LOGGED_IN_SALT/d;/NONCE_SALT/d' wp-config.php
sed -i "/#@-/a $WP_SALTS" wp-config.php

# Set custom table prefix
sed -i "s/\$table_prefix = 'wp_';/\$table_prefix = 'bF6_';/" wp-config.php

# Add custom WordPress constants
cat <<'EOF' >> wp-config.php

/** Allow Direct Updating Without FTP */
define('FS_METHOD', 'direct');
/** Disable Editing of Themes and Plugins Using the Built In Editor */
define('DISALLOW_FILE_EDIT', 'true');
/** TURN OFF AUTOMATIC UPDATES */
define('WP_AUTO_UPDATE_CORE', false );
define('AUTOMATIC_UPDATER_DISABLED', 'true');
EOF

# Sync WordPress files to web root
sudo mkdir -p "$WEBROOT"
sudo rsync -artv ~/wordpress/ "$WEBROOT/"

# Clean up
cd ~
sudo rm -rf latest.tar.gz wordpress

# Set proper ownership
sudo chown -R www-data:www-data "$WEBROOT"

# Verify
cd "$WEBROOT"
ls -la
