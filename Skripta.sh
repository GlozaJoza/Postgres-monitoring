#!/bin/bash
set -e  # Exit immediately if any command fails

# ==== CONFIG ====
USERNAME="$USER"      
FILE_TO_MOVE="keepalived/keepalived.conf"
DEST_FOLDER="/etc/keepalived/"
SERVICE_NAME="keepalived"
BROWSER="firefox"
URL1="http://localhost:3000"
URL2="http://localhost:5601"

# ==== FUNCTIONS ====

install_packages() {
    echo "[INFO] Installing required packages..."
    sudo apt install -y keepalived docker docker-compose
}


copy_file() {
    echo "[INFO] Moving $FILE_TO_MOVE to $DEST_FOLDER..."
    sudo mkdir -p "$DEST_FOLDER"
    sudo cp -f "$FILE_TO_MOVE" "$DEST_FOLDER"
}

start_service() {
    echo "[INFO] Starting $SERVICE_NAME..."
    sudo systemctl start "$SERVICE_NAME" 
}

start_docker_compose() {
    echo "[INFO] Starting Docker Compose..."
    sudo systemctl start docker
    docker-compose up -d
}

open_browser_tabs() {
    echo "[INFO] Opening browser tabs..."
    nohup "$BROWSER" "$URL1" "$URL2" >/dev/null 2>&1 &
}

# ==== MAIN ====
echo "====================================="
echo " Starting setup as user: $USERNAME"
echo "====================================="

install_packages
copy_file
start_service
start_docker_compose
open_browser_tabs

echo
echo "[DONE] Setup completed successfully!"
echo "User '$USERNAME' now has sudo + docker access without logout or password prompts."
