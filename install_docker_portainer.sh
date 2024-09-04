#!/bin/bash

# Función para verificar la instalación de Docker
check_docker() {
    if command -v docker >/dev/null 2>&1; then
        echo -e "\e[32mDocker ya está instalado.\e[0m"
        return 0
    else
        return 1
    fi
}

# Función para verificar la instalación de Portainer
check_portainer() {
    if docker ps --filter "name=portainer" --format '{{.Names}}' | grep -q '^portainer$'; then
        echo -e "\e[32mPortainer ya está instalado y en ejecución.\e[0m"
        return 0
    else
        return 1
    fi
}

# Función para obtener la IP local
get_ip() {
    hostname -I | awk '{print $1}'
}

# Actualizar el sistema
sudo apt-get update
sudo apt-get upgrade -y

# Instalar dependencias necesarias
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Añadir la clave GPG de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Añadir el repositorio de Docker
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Instalar Docker si no está instalado
if ! check_docker; then
    echo -e "\e[32mInstalando Docker...\e[0m"
    sudo apt-get update
    sudo apt-get install -y docker-ce

    # Añadir el usuario actual al grupo docker (opcional)
    sudo usermod -aG docker $USER
else
    echo -e "\e[32mDocker ya está instalado y en ejecución.\e[0m"
fi

# Descargar e instalar Portainer si no está instalado
if ! check_portainer; then
    echo -e "\e[32mInstalando Portainer...\e[0m"
    sudo docker volume create portainer_data
    sudo docker run -d -p 9000:9000 --name portainer --restart always \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v portainer_data:/data \
      portainer/portainer-ce
else
    IP=$(get_ip)
    echo -e "\e[32mPortainer ya está instalado y corriendo en los siguientes puertos e IP:"
    echo -e "http://$IP:9000\e[0m"
fi

# Mostrar información de acceso en color verde
echo -e "\e[32mLa instalación ha sido completada (si no estaba previamente instalada)."
echo -e "Puedes acceder a Portainer a través de la siguiente URL: http://$(get_ip):9000\e[0m"

# Dibujar el nombre Ronald con barras, puntos y comas en verde
echo -e "\e[32m"
echo "  ____   _                      _  "
echo " |  _ \ | |                    | | "
echo " | |_) || |_  ___  ___  _ __  | |_ "
echo " |  _ < | __|/ _ \/ _ \| '_ \ | __|"
echo " | |_) || |_|  __/  __/| | | || |_ "
echo " |____/  \__|\___|\___/ |_| |_| \__|"
echo -e "\e[0m"
