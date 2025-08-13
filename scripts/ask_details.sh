#!/bin/bash

# Function to generate a random string
generate_random_string() {
  tr -dc 'a-zA-Z0-9' </dev/urandom | head -c 12
}

generate_random_name() {
	tr -dc 'a-z' </dev/urandom | head -c 12
}
generate_random_salt() {
	tr -dc 'a-zA-Z0-9!@#$%^&*()-_=+[]{}|;:,.<>?/' </dev/urandom | head -c 64
}

# Ask SSH info
read -p "Enter SSH user: " ssh_user
read -p "Enter Server IP: " server_ip
read -p "Enter SSH port (default 22): " ssh_port
ssh_port=${ssh_port:-22}

# Ask if key-based authentication
read -p "Is this SSH key-based authentication? (y/n): " key_based
if [[ "$key_based" =~ ^[Yy]$ ]]; then
    read -p "Enter SSH key path: " ssh_key_path
    ssh_password=""
else
    read -s -p "Enter SSH password: " ssh_password
    echo
    ssh_key_path=""
fi

read -p "Enter Domain name: " domain_name

# Generate WordPress and database credentials
wp_user=$(generate_random_string)
wp_password=$(generate_random_string)
db_name=$(generate_random_string)
db_user=$(generate_random_string)
db_password=$(generate_random_string)

# Generate new server user credentials
new_server_user=$(generate_random_name)
new_server_password=$(generate_random_string)

# Fetch WordPress salts
salts=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

output_file="config.txt"

cat > "$output_file" <<EOF
SSH_USER=$ssh_user
SERVER_IP=$server_ip
SSH_PORT=$ssh_port
SSH_KEY_PATH=$ssh_key_path
SSH_PASSWORD=$ssh_password
DOMAIN_NAME=$domain_name
WP_USER=$wp_user
WP_PASSWORD=$wp_password
DB_NAME=$db_name
DB_USER=$db_user
DB_PASSWORD=$db_password
SALTS=$salts
NEW_SERVER_USER=$new_server_user
NEW_SERVER_PASSWORD=$new_server_password
EOF

echo "Configuration saved to $output_file."

while true; do
  read -p "Please note down these details as backup. Type 'y' to proceed: " confirm
  case "$confirm" in
    [Yy]) break ;;
    *) echo "Type 'y' to proceed." ;;
  esac
done

echo "Proceeding..."
