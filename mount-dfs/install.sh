#!/bin/bash

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
export REQUIREMENTS_FILE=".env/requirement"

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
        echo "✅ HQ Staff setup selected."

        # Backup old scripts if they exist
        timestamp=$(date +%Y%m%d_%H%M)
        [ -f "$MOUNT_SCRIPT" ] && cp "$MOUNT_SCRIPT" "$MOUNT_SCRIPT.bak.$timestamp"
        [ -f "$UMOUNT_SCRIPT" ] && cp "$UMOUNT_SCRIPT" "$UMOUNT_SCRIPT.bak.$timestamp"

        # Load mount and unmount logic if needed
        source .env/mount_script
        source .env/umount_script

        # Copy new scripts
        echo ""
        echo "🔧 Creating mount and unmount scripts..."
        cp ./config/hq/hq-install.sh "$MOUNT_SCRIPT"
        cp ./scripts/umount-hq.sh "$UMOUNT_SCRIPT"

        # Make them executable
        sudo chmod +x "$MOUNT_SCRIPT"
        sudo chmod +x "$UMOUNT_SCRIPT"

        echo "✅ Mount script installed at: $MOUNT_SCRIPT"
        echo "✅ Unmount script installed at: $UMOUNT_SCRIPT"

        # --- Create the systemd service ---
        echo ""
        echo "🔧 Creating auto mount services ..."
        source ./script/services_file.sh

        source .env/services_file
        
        # Make them executable
        sudo chmod +x "$SERVICE_FILE"

        # --- Reload and enable the service ---
        sudo systemctl daemon-reload
        sudo systemctl enable mount-amkdfs.service

        echo ""
        echo "✅ Mount and unmount scripts created at /usr/local/bin/"
        echo "✅ Systemd service created: mount-amkdfs.service"
        echo "👉 Run:   sudo systemctl start mount-amkdfs.service"
        echo "👉 Run:   sudo systemctl status mount-amkdfs.service"
        echo "👉 Stop:  sudo systemctl stop mount-amkdfs.service"
        ;;
    2)
        echo "✅ Branch Staff setup selected."
        source .env/branchs_mount_path
        BRANCHS_COLLAB_SHARE_PATH="$BRANCHS_COLLAB_SHARE_PATH"
        BRANCHS_DEPT_SHARE_PATH="$BRANCHS_CUD_SHARE_PATH"
        BRANCHS_HOME_BASE_PATH="$BRANCHS_BPR_SHARE_PATH"
        source ./config/branch/branchs-install.sh
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













