#!/bin/bash
source .env/mount_script
source .env/umount_script
source .env/services_file

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