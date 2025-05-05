# config/mount_point.py

def create_mount_script(mount_script_path, server, credentials_file, collab_path, dept_path, home_path, username):
    print("Creating the mount script ...")
    mount_script_content = f"""#!/bin/bash

COLLAB_SHARE_PATH="{collab_path}"
DEPT_SHARE_PATH="{dept_path}"
HOME_SHARE_PATH="{home_path}/$USERNAME"

COLLAB_MOUNTPOINT="/media/Collaboration-Q"
DEPT_MOUNTPOINT="/media/Department-N"
HOME_MOUNTPOINT="/media/Home-H"

sudo mkdir -p "$COLLAB_MOUNTPOINT" "$DEPT_MOUNTPOINT" "$HOME_MOUNTPOINT"

sudo mount -t cifs "//{server}/$COLLAB_SHARE_PATH" "$COLLAB_MOUNTPOINT" \\
  -o credentials=$CREDENTIALS_FILE,sec=ntlmssp,uid=$(id -u),gid=$(id -g),vers=3.0

sudo mount -t cifs "//{server}/$DEPT_SHARE_PATH" "$DEPT_MOUNTPOINT" \\
  -o credentials=$CREDENTIALS_FILE,sec=ntlmssp,uid=$(id -u),gid=$(id -g),vers=3.0

sudo mount -t cifs "//{server}/$HOME_SHARE_PATH" "$HOME_MOUNTPOINT" \\
  -o credentials=$CREDENTIALS_FILE,sec=ntlmssp,uid=$(id -u),gid=$(id -g),vers=3.0

mountpoint -q "$COLLAB_MOUNTPOINT" && echo "✅ Collaboration mounted at $COLLAB_MOUNTPOINT" || echo "❌ Collaboration mount failed"
mountpoint -q "$DEPT_MOUNTPOINT" && echo "✅ Department mounted at $DEPT_MOUNTPOINT" || echo "❌ Department mount failed"
mountpoint -q "$HOME_MOUNTPOINT" && echo "✅ Home Drive mounted at $HOME_MOUNTPOINT" || echo "❌ Home Drive mount failed"
"""
    
    with open(mount_script_path, "w") as file:
        file.write(mount_script_content)
    print(f"✅ Mount script created at {mount_script_path}")
