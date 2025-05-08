#!/bin/bash
# MOUNT_SCRIPT="/usr/local/bin/mount-amkdfs.sh"
# UMOUNT_SCRIPT="/usr/local/bin/unmount-amkdfs.sh"
# SERVICE_FILE="/etc/systemd/system/mount-amkdfs.service"

source .env/services_file
source .env/umount_script
source .env/mount_script

sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Mount DFS Shares
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

# Make them executable
sudo chmod +x "$SERVICE_FILE"