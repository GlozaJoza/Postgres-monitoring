#!/bin/bash
set -e  # Exit immediately if any command fails

# ==== CONFIG ====
USERNAME="$USER"      
FILE_TO_MOVE="/keepalived/keepalived.conf"
DEST_FOLDER="/etc/keepalived/"
SERVICE_NAME="keepalived"
BROWSER="firefox"
URL1="http://localhost:3000"
URL2="http://localhost:5601"

# ==== FUNCTIONS ====

add_user_to_sudoers() {
    echo "[INFO] Ensuring $USERNAME has sudo access..."
    if ! groups "$USERNAME" | grep -qw "sudo"; then
        sudo usermod -aG sudo "$USERNAME"
        echo "[INFO] Added $USERNAME to sudo group."
    else
        echo "[INFO] $USERNAME already in sudo group."
    fi

    # Passwordless sudo for automation
    SUDOERS_FILE="/etc/sudoers.d/$USERNAME"
    if [ ! -f "$SUDOERS_FILE" ]; then
        echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee "$SUDOERS_FILE" >/dev/null
        sudo chmod 440 "$SUDOERS_FILE"
    fi

    # Apply sudo group immediately
    if [ "$EUID" -ne 0 ]; then
        newgrp sudo <<EONG
echo "[INFO] Sudo group refreshed for $USERNAME."
EONG
    fi
}

install_packages() {
    echo "[INFO] Installing required packages..."
    sudo apt install -y keepalived docker docker-compose
}

add_user_to_docker() {
    echo "[INFO] Ensuring $USERNAME is in docker group..."
    sudo usermod -aG docker "$USERNAME"

    # Apply docker group immediately
    if [ "$EUID" -ne 0 ]; then
        newgrp docker <<EONG
echo "[INFO] Docker group refreshed for $USERNAME."
EONG
    fi
}


copy_file() {
    echo "[INFO] Moving $FILE_TO_MOVE to $DEST_FOLDER..."
    sudo mkdir -p "$DEST_FOLDER"
    sudo cp -f "$TARGET_FOLDER/$FILE_TO_MOVE" "$DEST_FOLDER"
}

start_service() {
    echo "[INFO] Starting $SERVICE_NAME..."
    sudo systemctl enable "$SERVICE_NAME" || true
    sudo systemctl restart "$SERVICE_NAME"
    sudo systemctl status "$SERVICE_NAME" --no-pager
}

start_docker_compose() {
    echo "[INFO] Starting Docker Compose..."
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

add_user_to_sudoers
install_packages
add_user_to_docker
copy_file
start_service
start_docker_compose
open_browser_tabs

echo
echo "[DONE] Setup completed successfully!"
echo "User '$USERNAME' now has sudo + docker access without logout or password prompts."
