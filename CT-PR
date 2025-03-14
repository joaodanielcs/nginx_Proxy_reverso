#!/bin/bash

# Perguntar pelo hostname e senha
read -p "Digite o hostname do container: " HOSTNAME
read -sp "Digite a senha do container: " PASSWORD
echo ""

# Identificar o próximo ID disponível
NEXTID=$(pvesh get /cluster/nextid)

# Verificar se o template Debian 12 está disponível, caso contrário, fazer o download
TEMPLATE_STORAGE="local"
TEMPLATE_NAME="debian-12-standard_12.0-1_amd64.tar.gz"
TEMPLATE_PATH="/var/lib/vz/template/cache/$TEMPLATE_NAME"

if [ ! -f "$TEMPLATE_PATH" ]; then
  echo "Template Debian 12 não encontrado. Baixando..."
  wget http://download.proxmox.com/images/system/$TEMPLATE_NAME -P /var/lib/vz/template/cache/
fi

# Criar o container
pct create $NEXTID $TEMPLATE_PATH --hostname $HOSTNAME --password $PASSWORD --storage Pool --rootfs Pool:50 --cores 4 --memory 2048 --swap 1024 --net0 name=eth0,bridge=vmbr0,ip=dhcp

# Iniciar o container
pct start $NEXTID

# Executar o comando dentro do container
pct exec $NEXTID -- bash -c "$(wget -qLO - https://raw.githubusercontent.com/joaodanielcs/nginx_Proxy_reverso/refs/heads/main/install.sh)"

echo "Container criado e configurado com sucesso!"
echo "ID: $NEXTID"
echo "Hostname: $HOSTNAME"
