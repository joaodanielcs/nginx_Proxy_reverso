#!/bin/bash

apt update
apt upgrade -y
timedatectl set-timezone America/Sao_Paulo
apt install sudo -y
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo apt install docker-compose -y
mkdir nginx && cd nginx
cat <<EOF > docker-compose.yml
version: '3'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    ports:
      - '90:80'
      - '81:81'
      - '450:443'
    environment:
      DB_MYSQL_HOST: "db"
      DB_MYSQL_PORT: 3306
      DB_MYSQL_USER: "npm"
      DB_MYSQL_PASSWORD: "npm"
      DB_MYSQL_NAME: "npm"
    volumes:
      - /srv/dev-disk-by-label-data/dockerapp/nginx/data:/data
      - /srv/dev-disk-by-label-data/dockerapp/nginx/letsencrypt:/etc/letsencrypt
  db:
    image: 'yobasystems/alpine-mariadb'
    environment:
      MYSQL_ROOT_PASSWORD: 'npm'
      MYSQL_DATABASE: 'npm'
      MYSQL_USER: 'npm'
      MYSQL_PASSWORD: 'npm'
    volumes:
      - /srv/dev-disk-by-label-data/dockerapp/nginx/mysql:/var/lib/mysql
EOF
docker-compose up -d
for container in $(docker ps -a -q); do
    docker update --restart unless-stopped $container
clear
ip=$(hostname -I | awk '{print $1}')
echo "Server:   http://$ip:81/login"
echo "Username: admin@example.com"
echo "Password: changeme"
echo
echo
