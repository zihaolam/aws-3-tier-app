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
sudo chmod 666 /var/run/docker.sock