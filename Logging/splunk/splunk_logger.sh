#!/bin/bash 
#Authors: Jonathan Johnson & Ben Shell
#References: https://stackoverflow.com/ && https://github.com/target/huntlib.git 

#Checking to see if script is running as root
if [[ $EUID -ne 0 ]]; then
  echo -e "\x1B[01;31mScript Must Be Ran As ROOT\x1B[0m" 
   exit 1
fi

#Installing Docker Compose
echo -e "\x1B[01;34mChecking to see if docker is installed\x1B[0m"

if [[ $(which docker-compose) && $(docker-compose --version) ]]; then
    echo -e "\x1B[01;32mDocker Compose is installed\x1B[0m"
  else
   echo -e "\x1B[01;32mInstalling Docker Compose\x1B[0m" 
    apt-get install docker-compose -y
fi

docker-compose up -d
sleep 30

#Installing Jupyter Notebooks:
echo -e "\x1B[01;32mInstalling Jupyter Notebooks\x1B[0m"
docker exec -it jupyter-notebooks sh -c 'jupyter notebook list'

if [[$(which git) ]]; then
   echo -e "\x1B[01;32mGit is already installed\x1B[0m"
  else
   echo -e "\x1B[01;32mGit is already installed\x1B[0m"
    apt-get install git -y
fi


