#!/bin/bash

sudo apt-get update -y && \
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg && \
sudo mkdir -m 0755 -p /etc/apt/keyrings && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
sudo apt-get update -y && \
sudo chmod a+r /etc/apt/keyrings/docker.gpg && \
sudo apt-get -y update && \
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
sudo groupadd docker && \
sudo usermod -aG docker $USER && \
newgrp docker && \
sudo systemctl restart docker && \
sudo chmod 666 /var/run/docker.sock && \
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
sudo chmod +x /usr/local/bin/docker-compose && \
mkdir ~/app && \
git clone https://github.com/zihaolam/aws-3-tier-app.git ~/app && \
docker-compose -f ~/app/app-backend/docker-compose.yml -up -d