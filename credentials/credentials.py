# credentials/credentials.py

import getpass
import os

def setup_credentials(credentials_file, server):
    print("\nSetting up credentials ...")
    
    # Prompt for username
    username = input("Enter your username (e.g. trn.mobile01): ")

    # Prompt for password (input hidden)
    password = getpass.getpass("Enter your password (the AD password): ")

    # Optional confirmation
    password_confirm = getpass.getpass("Confirm your password: ")

    if password != password_confirm:
        print("❌ Passwords do not match. Aborting.")
        exit(1)

    if not username or not password:
        print("❌ Username or password cannot be empty.")
        exit(1)

    # Save credentials to file
    with open(credentials_file, "w") as file:
        file.write(f"username={username}\n")
        file.write(f"password={password}\n")
        file.write(f"domain={server}\n")

    # Secure the file
    os.chmod(credentials_file, 0o600)
    print(f"✅ Credentials saved to {credentials_file} with secure permissions")
