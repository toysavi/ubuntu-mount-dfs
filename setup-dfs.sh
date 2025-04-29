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
HOME_SHARE_PATH="$HOME_BASE_PATH/\$USERNAME"

COLLAB_MOUNTPOINT="/media/Collaboration"
DEPT_MOUNTPOINT="/media/Department"
HOME_MOUNTPOINT="/media/Home"

# Create mount points
sudo mkdir -p "\$COLLAB_MOUNTPOINT" "\$DEPT_MOUNTPOINT" "\$HOME_MOUNTPOINT"

# Mount Collaboration
sudo mount -t cifs "//$SERVER/\$COLLAB_SHARE_PATH" "\$COLLAB_MOUNTPOINT" \\
  -o credentials=\$CREDENTIALS_FILE,sec=ntlmssp,uid=\$(id -u),gid=\$(id -g),vers=3.0

# Mount Department
sudo mount -t cifs "//$SERVER/\$DEPT_SHARE_PATH" "\$DEPT_MOUNTPOINT" \\
  -o credentials=\$CREDENTIALS_FILE,sec=ntlmssp,uid=\$(id -u),gid=\$(id -g),vers=3.0

# Mount Home Drive
sudo mount -t cifs "//$SERVER/\$HOME_SHARE_PATH" "\$HOME_MOUNTPOINT" \\
  -o credentials=\$CREDENTIALS_FILE,sec=ntlmssp,uid=\$(id -u),gid=\$(id -g),vers=3.0

# Show results
echo ""
mountpoint -q "\$COLLAB_MOUNTPOINT" && echo "✅ Collaboration mounted at \$COLLAB_MOUNTPOINT" || echo "❌ Collaboration mount failed"
mountpoint -q "\$DEPT_MOUNTPOINT" && echo "✅ Department mounted at \$DEPT_MOUNTPOINT" || echo "❌ Department mount failed"
mountpoint -q "\$HOME_MOUNTPOINT" && echo "✅ Home Drive mounted at \$HOME_MOUNTPOINT" || echo "❌ Home Drive mount failed"
EOF

# --- Make it executable
sudo chmod +x "$MOUNT_SCRIPT"

# --- Create the systemd service
SERVICE_FILE="/etc/systemd/system/mount-amkdfs.service"

sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Mount AMK DFS Shares
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/bin/mount-amkdfs.sh

[Install]
WantedBy=multi-user.target
EOF

# --- Reload systemd daemon and enable service
sudo systemctl daemon-reload
sudo systemctl enable mount-amkdfs.service

echo ""
echo "✅ Mount script created at $MOUNT_SCRIPT"
echo "✅ Systemd service created at $SERVICE_FILE"
echo "👉 You can now manually run: sudo systemctl start mount-amkdfs.service"
echo "🔄 It will also auto-mount at next reboot."
