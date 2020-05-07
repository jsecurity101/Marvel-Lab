#!/bin/bash
#Authors: Jonathan Johnson & Ben Shell
#References: https://stackoverflow.com/ && https://github.com/target/huntlib.git

# Checking to see if script is running as root
if [[ $EUID -ne 0 ]]; then
  echo -e "\x1B[01;31m[X] Script Must Be Run As ROOT\x1B[0m"
   exit 1
fi
Host_IP="$(hostname -I | awk '{ print $1 }')"

# Installing Docker Compose
echo -e "\x1B[01;34m[*] Checking to see if docker is installed\x1B[0m"

if [[ $(which docker-compose) && $(docker-compose --version) ]]; then
    echo -e "\x1B[01;32m[*] Docker Compose is installed\x1B[0m"
  else
   echo -e "\x1B[01;34m[*] Installing Docker Compose\x1B[0m"
    apt-get install docker-compose -y
fi

# Enabling docker service:
echo -e "\x1B[01;34m[*] Enabling Docker Service\x1B[0m"
sudo systemctl enable docker.service

# Starting containers
echo -e "\x1B[01;34m[*] Starting containers\x1B[0m"
docker-compose up -d

# Checking Jupyter Notebooks
echo -e "\x1B[01;34m[*] Checking Jupyter Notebooks\x1B[0m"
sleep 10
token="$(docker exec -it jupyter-notebooks sh -c 'jupyter notebook list' | grep token | sed 's/.*token=\([^ ]*\).*/\1/')"
echo -e "\x1B[01;32m[*] Portainer's IP is: $Host_IP:9000\x1B[0m"
echo -e "\x1B[01;32m[*] Splunk's IP is: $Host_IP:8000 ; Credentials - admin:Changeme1! (unless you changed them in the DockerFile)\x1B[0m"
echo -e "\x1B[01;32m[*] Jupyter Notebook's IP is: $Host_IP:8888\x1B[0m"
echo -e "\x1B[01;32m[*] Jupyter Notebook token is $token\x1B[0m"