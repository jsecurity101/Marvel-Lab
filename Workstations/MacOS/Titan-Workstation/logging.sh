#!/bin/bash
#Author: Jonathan Johnson
#References: Splunk Docs | https://blog.kolide.com/monitoring-macos-hosts-with-osquery-ba5dcc83122d | https://github.com/palantir/osquery-configuration


echo -e '


███╗   ███╗ █████╗ ██████╗ ██╗   ██╗███████╗██╗         ██╗      ██████╗  ██████╗  ██████╗ ██╗███╗   ██╗ ██████╗ 
████╗ ████║██╔══██╗██╔══██╗██║   ██║██╔════╝██║         ██║     ██╔═══██╗██╔════╝ ██╔════╝ ██║████╗  ██║██╔════╝ 
██╔████╔██║███████║██████╔╝██║   ██║█████╗  ██║         ██║     ██║   ██║██║  ███╗██║  ███╗██║██╔██╗ ██║██║  ███╗
██║╚██╔╝██║██╔══██║██╔══██╗╚██╗ ██╔╝██╔══╝  ██║         ██║     ██║   ██║██║   ██║██║   ██║██║██║╚██╗██║██║   ██║
██║ ╚═╝ ██║██║  ██║██║  ██║ ╚████╔╝ ███████╗███████╗    ███████╗╚██████╔╝╚██████╔╝╚██████╔╝██║██║ ╚████║╚██████╔╝
╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚══════╝    ╚══════╝ ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ 

'

# Checking to see if script is running as root
if [[ $EUID -ne 0 ]]; then
  echo -e "\x1B[01;31m[X] Script Must Be Ran As ROOT\x1B[0m"
   exit 1
fi

read -p 'Input the IP of the Splunk Server and press [ENTER]: ' Splunk_IP

#Pulling down OSQuery: 
echo -e "\x1B[01;34m[*] Pulling down OSQuery:\x1B[0m"
wget "https://pkg.osquery.io/darwin/osquery-4.4.0.pkg"

#Installing package: 
echo -e "\x1B[01;34m[*] Installing OSQuery Package:\x1B[0m"
installer -pkg osquery-4.4.0.pkg -target /

#Pulling down OSQuery configs/packs from Palantir's github:
echo -e "\x1B[01;34m[*] Pulling down OSQuery configs/packs from Palantir's github:\x1B[0m" 
wget "https://raw.githubusercontent.com/palantir/osquery-configuration/master/Classic/Endpoints/MacOS/osquery.conf"
wget "https://raw.githubusercontent.com/palantir/osquery-configuration/master/Classic/Endpoints/packs/security-tooling-checks.conf"
wget "https://raw.githubusercontent.com/palantir/osquery-configuration/master/Classic/Endpoints/packs/performance-metrics.conf"
cp osquery.conf /var/osquery/
cp performance-metrics.conf /var/osquery/packs/
cp security-tooling-checks.conf /var/osquery/packs

#Starting OSQuery:
echo -e "\x1B[01;34m[*] Starting OSQuery:\x1B[0m" 
sudo osqueryctl start


#Pulling splunk forwarder:
echo -e "\x1B[01;34m[*] Pulling Splunk Forwarder:\x1B[0m"
wget -O splunkforwarder-8.0.6-152fb4b2bb96-darwin-64.tgz 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86&platform=macos&version=8.0.6&product=universalforwarder&filename=splunkforwarder-8.0.6-152fb4b2bb96-darwin-64.tgz&wget=true'

#Starting Splunk/Setting Forward Server: 
echo -e "\x1B[01;34m[*] Starting Splunk/Setting Forward Server:\x1B[0m"

tar xvzf splunkforwarder-8.0.6-152fb4b2bb96-darwin-64.tgz -C /Applications
mkdir /Applications/splunkforwarder/etc/apps/SplunkUniversalForwarder/local

cp inputs.conf /Applications/splunkforwarder/etc/apps/SplunkUniversalForwarder/local/
/Applications/splunkforwarder/bin/splunk add forward-server $Splunk_IP:9997
/Applications/splunkforwarder/bin/splunk start