#!/bin/bash
USERNAME="$(whoami)"
SERVER="amkcambodia.com"
HQ_COLLAB_SHARE_PATH="amkdfs/Collaboration/AHO/ITI"
HQ_DEPT_SHARE_PATH="amkdfs/Dept_Doc/CIO/ITI"
HQ_HOME_BASE_PATH="amkdfs/StaffDoc/ITD"

COLLAB_SHARE_PATH="$HQ_COLLAB_SHARE_PATH"
DEPT_SHARE_PATH="$HQ_DEPT_SHARE_PATH"
HOME_SHARE_PATH="$HQ_HOME_BASE_PATH/\$USERNAME"

source .env/credentials_file

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