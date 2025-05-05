#!/bin/bash

# === Common Variables ===
SERVER="amkcambodia.com"
CREDENTIALS_FILE="/etc/smb-credentials"
USERNAME="$(whoami)"
UNMOUNT_SCRIPT="/usr/local/bin/unmount-amkdfs.sh"

# --- Create the unmount script ---
sudo tee "$UNMOUNT_SCRIPT" > /dev/null <<EOF
#!/bin/bash
echo "Unmounting AMK DFS Shares..."
sudo umount /media/Collaboration-Q 2>/dev/null
sudo umount /media/Department-N 2>/dev/null
sudo umount /media/Home-H 2>/dev/null
EOF

sudo chmod +x "$UNMOUNT_SCRIPT"
