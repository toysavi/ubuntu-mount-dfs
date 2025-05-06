#!/bin/bash

# === Common Variables ===
SERVER="amkcambodia.com"
CREDENTIALS_FILE="~/.smbcredentials"
USERNAME="$(whoami)"
MOUNT_SCRIPT="/usr/local/bin/mount-amkdfs.sh"
UNMOUNT_SCRIPT="/usr/local/bin/unmount-amkdfs.sh"
SERVICE_FILE="/etc/systemd/system/mount-amkdfs.service"

# ------------ Setup credentials ---------------------
echo ""
echo "Setup credential ..."
echo ""
# User and password setup
source ./lib/credentials.sh

# ------------- Pepare dependency --------------------
echo ""
echo "Preparing dependency ..."
echo ""

# Export path for dependency.sh to use
export REQUIREMENTS_FILE=".evn/requirement"

# Run the dependency installer
source ./lib/dependency.sh


echo ""
echo "🔧 Preparing SMB Share Paths ..."
echo ""

echo "Select setup type:"
echo "  1) HQ Staff"
echo "  2) Branch Staff"
echo "  3) Custom Setup"
read -rp "Enter choice [1-3]: " SETUP_CHOICE

case "$SETUP_CHOICE" in
    1)
        COLLAB_SHARE_PATH="amkdfs/Collaboration/AHO/ITI"
        DEPT_SHARE_PATH="amkdfs/Dept_Doc/CIO/ITI"
        HOME_BASE_PATH="amkdfs/StaffDoc/ITD"
        echo "✅ HQ Staff setup selected."
        ;;
    2)
        COLLAB_SHARE_PATH="amkdfs/Collaboration/Branch"
        DEPT_SHARE_PATH="amkdfs/Dept_Doc/Branch"
        HOME_BASE_PATH="amkdfs/StaffDoc/Branch"
        echo "✅ Branch Staff setup selected."
        ;;
    3)
        read -rp "Enter Collaboration Share path (e.g. amkdfs/Collaboration/AHO/ITI): " COLLAB_SHARE_PATH
        read -rp "Enter Department Share path (e.g. amkdfs/Dept_Doc/CIO/ITI): " DEPT_SHARE_PATH
        read -rp "Enter Home Drive base path (e.g. amkdfs/StaffDoc/ITD): " HOME_BASE_PATH
        ;;
    *)
        echo "❌ Invalid choice. Exiting."
        exit 1
        ;;
esac

# Add HQ mount
sudo chmod +x "$MOUNT_SCRIPT"
echo "✅ Done. Run with: sudo $MOUNT_SCRIPT"

# # ------------- Prompt for Share Paths -------------------
# echo ""
# echo " 🔧 Preparing SMB Share Paths ..."
# echo ""
# read -p "Enter Collaboration Share path (e.g. amkdfs/Collaboration/AHO/ITI): " COLLAB_SHARE_PATH
# read -p "Enter Department Share path (e.g. amkdfs/Dept_Doc/CIO/ITI): " DEPT_SHARE_PATH
# read -p "Enter Home Drive base path (e.g. amkdfs/StaffDoc/ITD): " HOME_BASE_PATH
# # Add HQ mount 
# sudo chmod +x "$MOUNT_SCRIPT"
# echo "✅ Done. Run with: sudo $MOUNT_SCRIPT"

# -------------- Create the unmount script ---------------
sudo tee "$UNMOUNT_SCRIPT" > /dev/null <<EOF
#!/bin/bash
echo "Unmounting AMK DFS Shares..."
sudo umount /media/Collaboration-Q 2>/dev/null
sudo umount /media/Department-N 2>/dev/null
sudo umount /media/Home-H 2>/dev/null
EOF
sudo chmod +x "$UNMOUNT_SCRIPT"

# --- Create the systemd service ---
sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Mount AMK DFS Shares
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=$MOUNT_SCRIPT
ExecStop=$UNMOUNT_SCRIPT

[Install]
WantedBy=multi-user.target
EOF

# --- Reload and enable the service ---
sudo systemctl daemon-reload
sudo systemctl enable mount-amkdfs.service

echo ""
echo "✅ Mount and unmount scripts created at /usr/local/bin/"
echo "✅ Systemd service created: mount-amkdfs.service"
echo "👉 Run:   sudo systemctl start mount-amkdfs.service"
echo "👉 Stop:  sudo systemctl stop mount-amkdfs.service"






