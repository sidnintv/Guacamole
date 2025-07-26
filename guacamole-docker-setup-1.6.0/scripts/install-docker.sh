#!/bin/bash
set -e

echo "=== Updating system and installing dependencies ==="
sudo apt update && sudo apt upgrade -y
sudo apt install -y ca-certificates curl gnupg lsb-release

echo "=== Adding the official Docker repository ==="
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "=== Installing Docker and Docker Compose ==="
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "=== Enabling Docker to start on boot ==="
sudo systemctl enable --now docker

echo "=== Adding current user to the docker group ==="
sudo usermod -aG docker $USER

echo "=== Checking installed versions ==="
docker --version
docker compose version

echo ""
echo "Docker and Docker Compose have been successfully installed!"
echo "Log out and log back in (or run: newgrp docker) to apply the group changes."
