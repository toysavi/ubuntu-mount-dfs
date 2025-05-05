#!/bin/bash

# === Common Variables ===
SERVER="amkcambodia.com"
CREDENTIALS_FILE="/etc/smb-credentials"
USERNAME="$(whoami)"
# --- Define paths ---
MOUNT_SCRIPT="/usr/local/bin/mount-amkdfs.sh"
UNMOUNT_SCRIPT="/usr/local/bin/unmount-amkdfs.sh"
SERVICE_FILE="/etc/systemd/system/mount-amkdfs.service"
REQUIREMENTS_FILE="./config/requirements"

# ------------ Setup credentials ---------------------
echo ""
echo "Setup credential ..."
source ./credentials/credentials.sh

# ------------- Pepare dependency --------------------
echo ""
echo "Preparing dependency ..."
echo ""
# # --------------- Check for cifs-utils dependency -----
# if ! dpkg -s cifs-utils >/dev/null 2>&1; then
#     echo "Installing required package: cifs-utils"
#     sudo apt update && sudo apt install cifs-utils -y
# fi

if [ ! -f "$REQUIREMENTS_FILE" ]; then
    echo "❌ Requirements file not found: $REQUIREMENTS_FILE"
    exit 1
fi

echo "==== Installing required packages ===="

while IFS= read -r package || [ -n "$package" ]; do
    if dpkg -s "$package" >/dev/null 2>&1; then
        echo "✅ $package is already installed."
    else
        echo "📦 Installing $package..."
        if sudo apt install -y "$package"; then
            echo "✅ $package installed successfully."
        else
            echo "❌ Failed to install $package"
        fi
    fi
done < "$REQUIREMENTS_FILE"

# ------------- Prompt for Share Paths -------------------
echo ""
echo " Preparing SMB Share Paths ..."
echo ""
read -p "Enter Collaboration Share path (e.g. amkdfs/Collaboration/AHO/ITI): " COLLAB_SHARE_PATH
read -p "Enter Department Share path (e.g. amkdfs/Dept_Doc/CIO/ITI): " DEPT_SHARE_PATH
read -p "Enter Home Drive base path (e.g. amkdfs/StaffDoc/ITD): " HOME_BASE_PATH
source ./config/mount-point.sh

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






