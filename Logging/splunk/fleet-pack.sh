#!/bin/bash
#Author: Jonathan Johnson
#Resources: https://github.com/kolide/fleet/blob/master/docs/cli/setup-guide.md | https://github.com/palantir/osquery-configuration


# Checking to see if script is running as root
if [[ $EUID -ne 0 ]]; then
  echo -e "\x1B[01;31m[X] Script Must Be Run As ROOT\x1B[0m"
   exit 1
fi
read -p 'Input your IP and press [ENTER]: ' Host_IP

# Pulling down OSQuery Configurations: 
read -p 'Input the email you used when setting up Kolide, then press [ENTER]: ' EMAIL
read -p 'Input the password you used when setting up Kolide, then press [ENTER]: ' PASSWORD
sudo docker exec -ti fleet sh -c 'fleetctl config set --address https://$Host_IP:8443 --tls-skip-verify'
docker exec -ti fleet sh -c 'fleetctl setup --email $EMAIL --password $PASSWORD'
git clone https://github.com/palantir/osquery-configuration.git
docker cp osquery-configuration/Fleet/Endpoints/packs/windows-application-security.yaml fleet:/windows-application-security.yaml
docker cp osquery-configuration/Fleet/Endpoints/packs/windows-registry-monitoring.yaml fleet:/windows-registry-monitoring.yaml
docker cp osquery-configuration/Fleet/Endpoints/packs/windows-compliance.yaml fleet:/windows-compliance.yaml
docker exec -ti fleet sh -c 'fleetctl apply -f windows-application-security.yaml'
docker exec -ti fleet sh -c 'fleetctl apply -f windows-registry-monitoring.yaml'
docker exec -ti fleet sh -c 'fleetctl apply -f wwindows-compliance.yaml'
rm -rf osquery-configuration/ 

echo -e "\x1B[01;34m[*] Configuration complete!\x1B[0m"