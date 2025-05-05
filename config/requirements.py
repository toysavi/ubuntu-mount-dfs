# config/requirements.py

import subprocess

def install_dependencies():
    print("\nPreparing dependencies ...")
    try:
        subprocess.run(["dpkg", "-s", "cifs-utils"], check=True, stdout=subprocess.DEVNULL)
        print("✅ cifs-utils is already installed.")
    except subprocess.CalledProcessError:
        print("Installing cifs-utils ...")
        subprocess.run(["apt", "update"], check=True)
        subprocess.run(["apt", "install", "-y", "cifs-utils"], check=True)
        print("✅ cifs-utils installed successfully.")
