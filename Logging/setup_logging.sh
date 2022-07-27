#!/bin/bash
#Authors: Jonathan Johnson & Ben Shell
#References: https://stackoverflow.com/ && https://github.com/target/huntlib.git

SETUP_SPLUNK="False"
SETUP_ELASTIC="False"
SETUP_ZEEK="False"

# Checking to see if script is running as root
if [[ $EUID -ne 0 ]]; then
  echo -e "\x1B[01;31m[X] Script Must Be Run As ROOT\x1B[0m"
   exit 1
fi

echo -e "\x1B[01;34m[*] Setting timezone to UTC...\x1B[0m"
timedatectl set-timezone UTC

# Checking Docker
echo -e "\x1B[01;34m[*] Checking to see if Docker is installed...\x1B[0m"

if [[ $(which docker) && $(docker compose version) ]]; then
    echo -e "\x1B[01;32m[*] Docker Compose is installed\x1B[0m"
  else
	echo -e "\x1B[01;31m[*] Docker was not found. See the Read the Docs installation documentation (https://marvel-lab.readthedocs.io/en/latest/subpages/build_steps.html#logging) \x1B[0m"
	exit 0
fi

# Enabling docker service:
echo -e "\x1B[01;34m[*] Enabling Docker Service...\x1B[0m"
systemctl enable docker.service

# Starting containers
echo -e "\x1B[01;34m[*] Starting containers\x1B[0m"
docker compose up -d

# Zeek
if [ "$SETUP_ZEEK" = "True" ]; then
	read -r -p "Zeek needs a network interface to monitor. Would you like to print out your interfaces to see which one to monitor? [y/N] " response

	if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
	then
		if hash ifconfig 2>/dev/null; then
			ifconfig
		else
			ip address
		fi
	else
		echo -e "\x1B[01;34m[*] Moving on...\x1B[0m"
	fi

	read -p 'Input the network interface you would like Zeek to monitor and press [ENTER]: ' Interface
	
	echo -e "\x1B[01;34m[*] Creating Zeek:\x1B[0m"
	docker compose up -d -f ./Config/zeek/zeek-compose.yml

# Splunk
if [ "$SETUP_SPLUNK" = "True" ]; then
	# Define healthcheck function for splunk
	splunk_healthcheck(){
		echo -e "\x1B[01;32m[*] Waiting for splunk...\x1B[0m"
		SPLUNK_STATUS=""
		while [[ "$SPLUNK_STATUS" != "\"healthy"\" ]]
		do
			sleep 3
			SPLUNK_STATUS=$(docker inspect --format='{{json .State.Health.Status}}' splunk)
		done
	}

	# Wait for splunk to finish installing
	splunk_healthcheck

	# The 'docker cp' commands are needed after Splunk install, otherwise our custom config would be overwritten
	docker cp splunk/inputs.conf splunk:/opt/splunk/etc/system/local/inputs.conf
	docker cp splunk/indexes.conf splunk:/opt/splunk/etc/system/local/indexes.conf
	echo -e "\x1B[01;32m[*] Restarting splunk to apply inputs.conf and indexes.conf\x1B[0m"
	docker restart splunk
	splunk_healthcheck

	# Checking Jupyter Notebooks
	echo -e "\x1B[01;34m[*] Checking Jupyter Notebooks...\x1B[0m"
	sleep 10
	token="$(docker exec -it jupyter-notebooks sh -c 'jupyter notebook list' | grep token | sed 's/.*token=\([^ ]*\).*/\1/')"

	echo -e "\x1B[01;32m[*] Access Splunk at https://$Host_IP/splunk/ ; Credentials - admin:Changeme1! (unless you changed them in the DockerFile)\x1B[0m"
	echo -e "\x1B[01;32m[*] Access Jupyter Notebook at: http://$Host_IP:8888\x1B[0m"
	echo -e "\x1B[01;32m[*] Jupyter Notebook token is $token\x1B[0m"

echo -e "\x1B[01;32m[*] Access Portainer at https://$Host_IP/portainer/ \x1B[0m"

