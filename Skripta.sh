#!/bin/bash
set -e
   
FILE_TO_MOVE="keepalived/keepalived.conf"
DEST_FOLDER="/etc/keepalived/"
SERVICE_NAME="keepalived"
BROWSER="firefox"
URL1="http://localhost:3000"
URL2="http://localhost:5601"


docker_preconfig() {
	echo "[INFO] Docker prerequiements"
	sudo apt-get update -y
	sudo apt-get install ca-certificates curl
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc
	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update -y
}

install_packages() {
    echo "[INFO] Installing required packages..."
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin keepalived
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
    docker compose up -d
}

open_browser_tabs() {
    echo "[INFO] Opening browser tabs..."
    nohup "$BROWSER" "$URL1" "$URL2" >/dev/null 2>&1 &
}

# ==== MAIN ====
echo "====================================="
echo " Starting setup "
echo "====================================="

docker_preconfig
install_packages
copy_file
start_service
start_docker_compose
open_browser_tabs

echo
echo "[DONE] Setup completed successfully!"
exit 0
