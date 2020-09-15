#!/bin/bash
#Author: Jonathan Johnson
#Resrouces: Homebrew Docs

# Checking to see if script is running as root
if [[ $EUID -ne 1 ]]; then
  echo -e "\x1B[01;31m[X] Script Cannot Be Ran As ROOT\x1B[0m"
   exit 1
fi

#Pulling/Installing Homebrew:
echo -e "\x1B[01;34m[*] Installing Homebrew:\x1B[0m"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

#Installing wget
echo -e "\x1B[01;34m[*] Installing wget:\x1B[0m"
homebrew install wget
