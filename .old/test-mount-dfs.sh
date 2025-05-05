#!/bin/bash

# === Common Variables ===
SERVER="amkcambodia.com"
CREDENTIALS_FILE="/etc/smb-credentials"
USERNAME="$(whoami)"      # Current Linux login username

# === Mount Collaboration Share "Q" ===
COLLAB_SHARE_PATH="amkdfs/Collaboration/AHO/ITI"
COLLAB_MOUNTPOINT="/media/Collaboration"

# === Mount Department Share "N" ===
DEPT_SHARE_PATH="amkdfs/Dept_Doc/CIO/ITI"
DEPT_MOUNTPOINT="/media/Department"

# === Mount Home Drive "H" ===
HOME_SHARE_PATH="amkdfs/StaffDoc/ITD/$USERNAME"
HOME_MOUNTPOINT="/media/Home"

# ===============================================================================================================

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

# Create mount point for Department
sudo mkdir -p "$DEPT_MOUNTPOINT"

# Mount Department Share
sudo mount -t cifs "//$SERVER/$DEPT_SHARE_PATH" "$DEPT_MOUNTPOINT" \
  -o credentials=$CREDENTIALS_FILE,sec=ntlmssp,uid=$(id -u),gid=$(id -g),vers=3.0,iocharset=utf8,mfsymlinks,nounix

# Check Department mount
if mountpoint -q "$DEPT_MOUNTPOINT"; then
  echo "✅ Department Share mounted at $DEPT_MOUNTPOINT"
else
  echo "❌ Failed to mount Department Share"
fi

# === Mount Home Drive "H" ===

# Create mount point for Department
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
