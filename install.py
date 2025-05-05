# install.py

import os
import subprocess
from config.requirements import install_dependencies
from config.mount_point import create_mount_script
from credentials.credentials import setup_credentials

# === Common Variables ===
SERVER = "amkcambodia.com"
CREDENTIALS_FILE = "/etc/smb-credentials"
USERNAME = os.getlogin()
MOUNT_SCRIPT = "/usr/local/bin/mount-amkdfs.sh"
UNMOUNT_SCRIPT = "/usr/local/bin/unmount-amkdfs.sh"
SERVICE_FILE = "/etc/systemd/system/mount-amkdfs.service"

def prompt_share_paths():
    collab = input("Enter Collaboration Share path (e.g. amkdfs/Collaboration/AHO/ITI): ")
    dept = input("Enter Department Share path (e.g. amkdfs/Dept_Doc/CIO/ITI): ")
    home = input("Enter Home Drive base path (e.g. amkdfs/StaffDoc/ITD): ")
    return collab, dept, home

def main():
    if os.geteuid() != 0:
        print("\n❌ Please run as root (sudo python3 install.py)")
        exit(1)

    print("==== Initial DFS Mount Script Setup ====")

    # Install dependencies
    install_dependencies()

    # Backup pam_mount.conf.xml
    print("\n--- Backing up pam_mount.conf.xml ---")
    subprocess.run(["cp", "/etc/security/pam_mount.conf.xml", f"/etc/security/pam_mount.conf.xml.bak"], check=True)

    # Set up credentials
    print("\n--- Setting up credentials ---")
    setup_credentials(CREDENTIALS_FILE, SERVER)

    # Prompt for share paths
    print("\n--- Prompting for share paths ---")
    collab_path, dept_path, home_path = prompt_share_paths()

    # Create mount script
    print("\n--- Creating mount script ---")
    create_mount_script(MOUNT_SCRIPT, SERVER, CREDENTIALS_FILE, collab_path, dept_path, home_path, USERNAME)

    os.chmod(MOUNT_SCRIPT, 0o755)
    print(f"✅ Mount script created at {MOUNT_SCRIPT}")

if __name__ == "__main__":
    main()
