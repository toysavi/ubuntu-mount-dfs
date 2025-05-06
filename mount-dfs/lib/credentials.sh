#!/bin/bash

CREDENTIALS_FILE="$HOME/.smbcredentials"
SERVER="amkcambodia.com"

# --- Check for existing Kerberos ticket ---
if klist 2>/dev/null | grep -q "krbtgt"; then
    echo "✅ Kerberos authentication successful. Skipping credential prompt."

    # Check if credentials file exists
    if [[ -f "$CREDENTIALS_FILE" ]]; then
        echo "🔍 Found existing credentials file at $CREDENTIALS_FILE."

        # Load credentials
        source <(grep '^username=' "$CREDENTIALS_FILE")
        source <(grep '^password=' "$CREDENTIALS_FILE")

        echo "🔐 Validating credentials with smbclient..."
        echo "$password" | smbclient -L //$SERVER/ -U "$username" --password-from-stdin &>/dev/null

        if [[ $? -eq 0 ]]; then
            echo "✅ Credentials are valid. Exiting."
            exit 0
        else
            echo "⚠️ Credentials may be expired or invalid. Will re-prompt."
        fi
    fi
fi

# --- Prompt for new credentials ---
read -r -p "Enter your username (e.g. trn.mobile01): " USER_NAME
read -rs -p "Enter your password (the AD password): " USER_PASS; echo
read -rs -p "Confirm your password: " USER_PASS_CONFIRM; echo

if [ "$USER_PASS" != "$USER_PASS_CONFIRM" ]; then
    echo "❌ Passwords do not match. Aborting."
    exit 1
fi

if [[ -z "$USER_NAME" || -z "$USER_PASS" ]]; then
    echo "❌ Username or password cannot be empty."
    exit 1
fi

# Save to credentials file
echo "💾 Saving credentials to $CREDENTIALS_FILE..."
tee "$CREDENTIALS_FILE" > /dev/null <<EOF
username=$USER_NAME
password=$USER_PASS
domain=$SERVER
EOF

chmod 600 "$CREDENTIALS_FILE"
echo "✅ Credentials securely saved to $CREDENTIALS_FILE"
