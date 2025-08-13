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

# Generate salts
auth_key=$(generate_random_salt)
secure_auth_key=$(generate_random_salt)
logged_in_key=$(generate_random_salt)
nonce_key=$(generate_random_salt)
auth_salt=$(generate_random_salt)
secure_auth_salt=$(generate_random_salt)
logged_in_salt=$(generate_random_salt)
nonce_salt=$(generate_random_salt)

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
AUTH_KEY=$auth_key
SECURE_AUTH_KEY=$secure_auth_key
LOGGED_IN_KEY=$logged_in_key
NONCE_KEY=$nonce_key
AUTH_SALT=$auth_salt
SECURE_AUTH_SALT=$secure_auth_salt
LOGGED_IN_SALT=$logged_in_salt
NONCE_SALT=$nonce_salt
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
