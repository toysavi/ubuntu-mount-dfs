#!/bin/bash

sudo tee "$MOUNT_SCRIPT" > /dev/null <<EOF
#!/bin/bash

COLLAB_SHARE_PATH="$COLLAB_SHARE_PATH"
DEPT_SHARE_PATH="$DEPT_SHARE_PATH"
HOME_SHARE_PATH="$HOME_BASE_PATH/\$USERNAME"

COLLAB_MOUNTPOINT="/media/Collaboration-Q"
DEPT_MOUNTPOINT="/media/Department-N"
HOME_MOUNTPOINT="/media/Home-H"

mkdir -p "\$COLLAB_MOUNTPOINT" "\$DEPT_MOUNTPOINT" "\$HOME_MOUNTPOINT"

mount -t cifs "//$SERVER/\$COLLAB_SHARE_PATH" "\$COLLAB_MOUNTPOINT" \\
  -o credentials=$CREDENTIALS_FILE,sec=ntlmssp,uid=\$(id -u),gid=\$(id -g),vers=3.0

mount -t cifs "//$SERVER/\$DEPT_SHARE_PATH" "\$DEPT_MOUNTPOINT" \\
  -o credentials=$CREDENTIALS_FILE,sec=ntlmssp,uid=\$(id -u),gid=\$(id -g),vers=3.0

mount -t cifs "//$SERVER/\$HOME_SHARE_PATH" "\$HOME_MOUNTPOINT" \\
  -o credentials=$CREDENTIALS_FILE,sec=ntlmssp,uid=\$(id -u),gid=\$(id -g),vers=3.0

mountpoint -q "\$COLLAB_MOUNTPOINT" && echo "✅ Collaboration mounted at \$COLLAB_MOUNTPOINT" || echo "❌ Collaboration mount failed"
mountpoint -q "\$DEPT_MOUNTPOINT" && echo "✅ Department mounted at \$DEPT_MOUNTPOINT" || echo "❌ Department mount failed"
mountpoint -q "\$HOME_MOUNTPOINT" && echo "✅ Home Drive mounted at \$HOME_MOUNTPOINT" || echo "❌ Home Drive mount failed"
EOF
sudo chmod +x "$MOUNT_SCRIPT"
echo "✅ Done. Run with: sudo $MOUNT_SCRIPT"