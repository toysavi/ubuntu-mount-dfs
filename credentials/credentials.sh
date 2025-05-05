#!/bin/bash

CREDENTIALS_FILE="/etc/smb-credentials"
SERVER="amkcambodia.com"

# Prompt for username
read -r -p "Enter your username (e.g. trn.mobile01): " USER_NAME

# Prompt for password securely
read -rs -p "Enter your password (the AD password): " USER_PASS
echo
read -rs -p "Confirm your password: " USER_PASS_CONFIRM
echo

# Check for matching passwords
if [ "$USER_PASS" != "$USER_PASS_CONFIRM" ]; then
  echo "❌ Passwords do not match. Aborting."
  exit 1
fi

# Check inputs
if [[ -z "$USER_NAME" || -z "$USER_PASS" ]]; then
  echo "❌ Username or password cannot be empty."
  exit 1
fi

# Confirm before writing
echo "Saving credentials to $CREDENTIALS_FILE..."
sudo tee "$CREDENTIALS_FILE" > /dev/null <<EOF
username=$USER_NAME
password=$USER_PASS
domain=$SERVER
EOF

# Restrict access
sudo chmod 600 "$CREDENTIALS_FILE"
# Optionally, set ownership to user
# sudo chown $USER:$USER "$CREDENTIALS_FILE"

echo "✅ Credentials securely saved to $CREDENTIALS_FILE"
