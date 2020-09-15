#!/bin/bash

#Author: Jonathan Johnson
#References: https://nine41.us/2017/02/13/bind-macos-to-active-directory-using-a-script/ // https://gist.github.com/bzerangue/6886182#to-unbind-a-computer-from-an-active-directory-domain


echo -e "

████████╗██╗████████╗ █████╗ ███╗   ██╗      ██╗    ██╗██████╗ ██╗  ██╗███████╗████████╗███╗   ██╗
╚══██╔══╝██║╚══██╔══╝██╔══██╗████╗  ██║      ██║    ██║██╔══██╗██║ ██╔╝██╔════╝╚══██╔══╝████╗  ██║
   ██║   ██║   ██║   ███████║██╔██╗ ██║█████╗██║ █╗ ██║██████╔╝█████╔╝ ███████╗   ██║   ██╔██╗ ██║
   ██║   ██║   ██║   ██╔══██║██║╚██╗██║╚════╝██║███╗██║██╔══██╗██╔═██╗ ╚════██║   ██║   ██║╚██╗██║
   ██║   ██║   ██║   ██║  ██║██║ ╚████║      ╚███╔███╔╝██║  ██║██║  ██╗███████║   ██║   ██║ ╚████║
   ╚═╝   ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝       ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═══╝

"

# Checking to see if script is running as root
if [[ $EUID -ne 0 ]]; then
  echo -e "\x1B[01;31m[X] Script Must Be Run As ROOT\x1B[0m"
   exit 1
fi


echo -e "\x1B[01;34m[*] Setting Workstation name to - Titan-Wrkstn\x1B[0m"
scutil --set ComputerName "Titan-Wrkstn"
scutil --set LocalHostName "Titan-Wrkstn"


echo -e "\x1B[01;34m[*] Setting variables\x1B[0m"
domain=marvel.local
domainuser=thanos
userpassword=InfinityStone$
computername=Titan-Wrkstin

echo -e "\x1B[01;34m[*] Binding host to marvel.local\x1B[0m"
dsconfigad -add "${domain}" -username "${domainuser}" -password "${userpassword}" -computer "${computername}" -ou "OU=Workstations,DC=marvel,DC=local" -groups "Domain Admins"



echo -e "\x1B[01;34m[*] Confirming that the host successfully binded to the domain\x1B[0m"
if [[ $(dsconfigad -show | awk '/Active Directory Domain/{print $NF}') != 'marvel.local' ]]; then
        echo -e "\x1B[01;34mBIND DID NOT WORK, FOLLOW TROUBLESHOOTING TIPS ON THE DOCS PAGE\x1B[0m"
else
        echo -e "\x1B[01;34m[*] Binding completed!\x1B[0m"
fi
