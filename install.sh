#!/bin/bash

# === Common Variables ===
SERVER="amkcambodia.com"
CREDENTIALS_FILE="/etc/smb-credentials"
USERNAME="$(whoami)"
# --- Define paths ---
MOUNT_SCRIPT="/usr/local/bin/mount-amkdfs.sh"
UNMOUNT_SCRIPT="/usr/local/bin/unmount-amkdfs.sh"
SERVICE_FILE="/etc/systemd/system/mount-amkdfs.service"

# ------------------------ Setup credentials ---------------
echo ""
echo "Setup credential ..."
source ./credentials/credentials.sh


# --- Prompt for Share Paths ---
read -p "Enter Collaboration Share path (e.g. amkdfs/Collaboration/AHO/ITI): " COLLAB_SHARE_PATH
read -p "Enter Department Share path (e.g. amkdfs/Dept_Doc/CIO/ITI): " DEPT_SHARE_PATH
read -p "Enter Home Drive base path (e.g. amkdfs/StaffDoc/ITD): " HOME_BASE_PATH










# ------------- Pepare dependency ----------------
echo ""
echo "Preparing dependency ..."
echo ""
source  
# ------------- Setup credentials ----------------
echo ""
echo "Preparing credential ..."
echo ""
source ./credentials/credentials.sh


echo "Preparing dependency ..."

