#!/bin/bash

# === Common Variables ===
SERVER="amkcambodia.com"
CREDENTIALS_FILE="/etc/smb-credentials"
USERNAME="$(whoami)"      # Current Linux login username

# === Mount Collaboration Share ===
COLLAB_SHARE_PATH="amkdfs/Collaboration/AHO/ITI"
COLLAB_MOUNTPOINT="/media/Collaboration"

# Create mount point for Collaboration
sudo mkdir -p "$COLLAB_MOUNTPOINT"

# Mount Collaboration Share
sudo mount -t cifs "//$SERVER/$COLLAB_SHARE_PATH" "$COLLAB_MOUNTPOINT" \
  -o credentials=$CREDENTIALS_FILE,sec=ntlmssp,uid=$(id -u),gid=$(id -g),vers=3.0,iocharset=utf8,mfsymlinks,nounix

# Check Collaboration mount
if mountpoint -q "$COLLAB_MOUNTPOINT"; then
  echo "✅ Collaboration Share mounted at $COLLAB_MOUNTPOINT"
else
  echo "❌ Failed to mount Collaboration Share"
fi

# === Mount Home Drive ===
HOME_SHARE_PATH="amkdfs/StaffDoc/ITD/$USERNAME"
HOME_MOUNTPOINT="/media/home_${USERNAME}"

# Create mount point for Home Drive
sudo mkdir -p "$HOME_MOUNTPOINT"

# Mount Home Drive
sudo mount -t cifs "//$SERVER/$HOME_SHARE_PATH" "$HOME_MOUNTPOINT" \
  -o credentials=$CREDENTIALS_FILE,sec=ntlmssp,uid=$(id -u),gid=$(id -g),vers=3.0,iocharset=utf8,mfsymlinks,nounix

# Check Home Drive mount
if mountpoint -q "$HOME_MOUNTPOINT"; then
  echo "✅ Home Drive mounted at $HOME_MOUNTPOINT"
else
  echo "❌ Failed to mount Home Drive"
fi
