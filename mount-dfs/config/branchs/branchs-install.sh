#!/bin/bash
USERNAME="$(whoami)"
SERVER="amkcambodia.com"
SERVER1="amkcrm1"
SERVER2="ho-databackup"

source .env/credentials_file

BRANCHS_COLLAB_SHARE_PATH="amkdfs/Collaboration/AHO/ITI"
BRANCHS_CUD_SHARE_PATH="CUD"
BRANCHS_BPR_SHARE_PATH="Branch"

COLLAB_MOUNTPOINT="/media/Collaboration-Q"
CUD_MOUNTPOINT="/media/CUD-U"
BPR_MOUNTPOINT="/media/Branch_Post_Report-P"

mkdir -p "\$COLLAB_MOUNTPOINT" "\$CUD_MOUNTPOINT" "\$BPR_MOUNTPOINT"

mount -t cifs "//$SERVER/\$BRANCHS_COLLAB_SHARE_PATH" "\$COLLAB_MOUNTPOINT" \\
  -o credentials=$CREDENTIALS_FILE,sec=ntlmssp,uid=\$(id -u),gid=\$(id -g),vers=3.0

mount -t cifs "//$SERVER1/\$BRANCHS_CUD_SHARE_PATH" "\$CUD_MOUNTPOINT" \\
  -o credentials=$CREDENTIALS_FILE,sec=ntlmssp,uid=\$(id -u),gid=\$(id -g),vers=3.0

mount -t cifs "//$SERVER2/\$BRANCHS_BPR_SHARE_PATH" "\$BPR_MOUNTPOINT" \\
  -o credentials=$CREDENTIALS_FILE,sec=ntlmssp,uid=\$(id -u),gid=\$(id -g),vers=3.0

mountpoint -q "\$COLLAB_MOUNTPOINT" && echo "✅ Collaboration mounted at \$COLLAB_MOUNTPOINT" || echo "❌ Collaboration mount failed"
mountpoint -q "\$CUD_MOUNTPOINT" && echo "✅ Department mounted at \$CUD_MOUNTPOINT" || echo "❌ Department mount failed"
mountpoint -q "\$BPR_MOUNTPOINT" && echo "✅ Home Drive mounted at \$BPR_MOUNTPOINT" || echo "❌ Home Drive mount failed"