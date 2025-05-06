# How to install/use the script(s)# 📁 SMB Auto-Mount Script

This script automates the setup of SMB (CIFS) network shares for **HQ Staff**, **Branch Staff**, or a **Custom Setup**. It creates mount/unmount scripts, sets up systemd services for automatic mounting, and handles user credentials securely.

---

## 📦 Features

- Interactive setup: choose from HQ Staff, Branch Staff, or Custom setup.
- Creates backup `.bak` files for existing mount/unmount scripts.
- Automatically configures systemd service for persistent mounting on boot.
- Modular structure with separate scripts for:
  - Credential loading
  - Dependency checks
  - Mount/unmount logic
  - Systemd service generation

---

## 🚀 How to Use

1. **Clone the repository** and make sure scripts are executable:

   ```bash
   chmod +x install.sh
    ```
2. Run the setup script:
    ```bash
    ./install.sh
    ```
3. Follow the prompt to choose setup type:
    ```bash
    1) HQ Staff
    2) Branch Staff
    3) Custom Setup
    ```
4. Once complete, use these commands:  
    ```bash
    # Start the mount service
    sudo systemctl start mount-amkdfs.service
    # Check service status
    sudo systemctl status mount-amkdfs.service  
    # Stop the service
    sudo systemctl stop mount-amkdfs.service   
    ```
## 🗂 Folder Structure
    

    ├── install.sh                  # Main installer script
    ├── lib/
    │   └── credentials.sh          # Sets user credentials
    ├── script/
    │   ├── dependency.sh           # Checks and installs dependencies
    │   └── services_file.sh        # Generates systemd service
    ├── config/
    │   ├── hq/hq-install.sh        # HQ-specific mount logic
    │   └── branchs/branchs-install.sh # Branch-specific mount logic
    ├── scripts/
    │   ├── umount-hq.sh            # HQ unmount logic
    │   └── umount-branchs.sh       # Branch unmount logic
    ├── .env/
    │   ├── mount_script            # Path to final mount script
    │   ├── umount_script           # Path to final unmount script
    │   └── services_file           # Path to systemd service
  
## ⚙️ Requirements
- Bash
- cifs-utils installed (handled via dependency.sh)
- sudo privileges

