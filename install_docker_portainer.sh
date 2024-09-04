#!/bin/bash

# Actualizar el sistema
sudo apt-get update
sudo apt-get upgrade -y

# Instalar dependencias necesarias
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Añadir la clave GPG de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Añadir el repositorio de Docker
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Instalar Docker
sudo apt-get update
sudo apt-get install -y docker-ce

# Añadir el usuario actual al grupo docker (opcional)
sudo usermod -aG docker $USER

# Descargar e instalar Portainer
sudo docker volume create portainer_data
sudo docker run -d -p 9000:9000 --name portainer --restart always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce

# Mostrar información de acceso
echo -e "\e[32mDocker y Portainer han sido instalados y configurados."
echo -e "Puedes acceder a Portainer a través de la siguiente URL: http://$(hostname -I | awk '{print $1}'):9000\e[0m"
