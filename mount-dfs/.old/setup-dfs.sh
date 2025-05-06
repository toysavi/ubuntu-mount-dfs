#!/bin/bash

# === Common Variables ===
SERVER="amkcambodia.com"
CREDENTIALS_FILE="/etc/smb-credentials"
USERNAME="$(whoami)"

echo "==== Initial DFS Mount Script Setup ===="

# --- Prompt for Share Paths ---
read -p "Enter Collaboration Share path (e.g. amkdfs/Collaboration/AHO/ITI): " COLLAB_SHARE_PATH
read -p "Enter Department Share path (e.g. amkdfs/Dept_Doc/CIO/ITI): " DEPT_SHARE_PATH
read -p "Enter Home Drive base path (e.g. amkdfs/StaffDoc/ITD): " HOME_BASE_PATH

# --- Create the mount script ---
MOUNT_SCRIPT="/usr/local/bin/mount-amkdfs.sh"

sudo tee "$MOUNT_SCRIPT" > /dev/null <<EOF
#!/bin/bash

SERVER="amkcambodia.com"
CREDENTIALS_FILE="/etc/smb-credentials"
USERNAME="\$(whoami)"

COLLAB_SHARE_PATH="$COLLAB_SHARE_PATH"
DEPT_SHARE_PATH="$DEPT_SHARE_PATH"
HOME_SHARE_PATH="$HOME_BASE_PATH"

COLLAB_MOUNTPOINT="/media/Collaboration"
DEPT_MOUNTPOINT="/media/Department"
HOME_MOUNTPOINT="/media/Home"

sudo mkdir -p "\$COLLAB_MOUNTPOINT" "\$DEPT_MOUNTPOINT" "\$HOME_MOUNTPOINT"

sudo mount -t cifs "//$SERVER/\$COLLAB_SHARE_PATH" "\$COLLAB_MOUNTPOINT" \\
  -o credentials=\$CREDENTIALS_FILE,sec=ntlmssp,uid=\$(id -u),gid=\$(id -g),vers=3.0

sudo mount -t cifs "//$SERVER/\$DEPT_SHARE_PATH" "\$DEPT_MOUNTPOINT" \\
  -o credentials=\$CREDENTIALS_FILE,sec=ntlmssp,uid=\$(id -u),gid=\$(id -g),vers=3.0

sudo mount -t cifs "//$SERVER/\$HOME_SHARE_PATH" "\$HOME_MOUNTPOINT" \\
  -o credentials=\$CREDENTIALS_FILE,sec=ntlmssp,uid=\$(id -u),gid=\$(id -g),vers=3.0

mountpoint -q "\$COLLAB_MOUNTPOINT" && echo "✅ Collaboration mounted at \$COLLAB_MOUNTPOINT" || echo "❌ Collaboration mount failed"
mountpoint -q "\$DEPT_MOUNTPOINT" && echo "✅ Department mounted at \$DEPT_MOUNTPOINT" || echo "❌ Department mount failed"
mountpoint -q "\$HOME_MOUNTPOINT" && echo "✅ Home Drive mounted at \$HOME_MOUNTPOINT" || echo "❌ Home Drive mount failed"
EOF

sudo chmod +x "$MOUNT_SCRIPT"

# --- Create the unmount script ---
UNMOUNT_SCRIPT="/usr/local/bin/unmount-amkdfs.sh"

sudo tee "$UNMOUNT_SCRIPT" > /dev/null <<EOF
#!/bin/bash
echo "Unmounting AMK DFS Shares..."
sudo umount /media/Collaboration 2>/dev/null
sudo umount /media/Department 2>/dev/null
sudo umount /media/Home 2>/dev/null
EOF

sudo chmod +x "$UNMOUNT_SCRIPT"

# --- Create the systemd service ---
SERVICE_FILE="/etc/systemd/system/mount-amkdfs.service"

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
echo "✅ Mount and unmount scripts created"
echo "✅ Service enabled: mount-amkdfs.service"
echo "👉 You can now run: sudo systemctl start mount-amkdfs.service"
echo "👉 And stop/unmount with: sudo systemctl stop mount-amkdfs.service"
