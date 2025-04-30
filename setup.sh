#!/bin/bash

# Run as root
if [[ $EUID -ne 0 ]]; then
   echo "❌ Please run as root (sudo $0)"
   exit 1
fi

echo "==== AMK DFS pam_mount Auto-Mount Setup ===="

# --- Prompt user for paths ---
read -p "Enter Collaboration Drive Q Share (e.g. amkdfs/Collaboration/AHO/ITI): " COLLAB_PATH
read -p "Enter Department Drive N Share (e.g. amkdfs/Dept_Doc/CIO/ITI): " DEPT_PATH
read -p "Enter Home Drive Base Path (e.g. amkdfs/StaffDoc/ITD): " HOME_PATH

# Install required packages
echo "🔧 Installing required packages..."
apt update && apt install -y libpam-mount cifs-utils

# Backup and generate new pam_mount.conf.xml
PAM_CONF="/etc/security/pam_mount.conf.xml"
BACKUP_CONF="${PAM_CONF}.bak.$(date +%s)"
cp "$PAM_CONF" "$BACKUP_CONF"

echo "🔧 Generating pam_mount.conf.xml..."
cat > "$PAM_CONF" <<EOF
<?xml version="1.0" encoding="utf-8" ?>
<pam_mount>
    <debug enable="0" />

    <volume user="*" fstype="cifs" server="amkcambodia.com" path="$COLLAB_PATH" mountpoint="/media/Collaboration-Q" options="uid=%(USER),gid=%(USER),sec=ntlmssp,vers=3.0" />
    <volume user="*" fstype="cifs" server="amkcambodia.com" path="$DEPT_PATH" mountpoint="/media/Department-N" options="uid=%(USER),gid=%(USER),sec=ntlmssp,vers=3.0" />
    <volume user="*" fstype="cifs" server="amkcambodia.com" path="$HOME_PATH/%(USER)" mountpoint="/media/Home-H" options="uid=%(USER),gid=%(USER),sec=ntlmssp,vers=3.0" />

    <mntoptions require="nosuid,nodev" />
    <logout wait="0" hup="no" term="no" kill="no" />
</pam_mount>
EOF

# Ensure pam_mount is enabled in PAM
COMMON_SESSION="/etc/pam.d/common-session"
if ! grep -q "pam_mount.so" "$COMMON_SESSION"; then
    echo "session optional pam_mount.so" >> "$COMMON_SESSION"
    echo "✅ Added pam_mount to $COMMON_SESSION"
else
    echo "ℹ️ pam_mount already exists in $COMMON_SESSION"
fi

echo ""
echo "✅ Auto-mount configuration complete!"
echo "📂 Shares will be mounted under:"
echo "   - /media/Collaboration-Q"
echo "   - /media/Department-N"
echo "   - /media/Home-H"
echo "👤 Login using your domain credentials to test."
