#Author: Jonathan Johnson
#Resources -
#https://chocolatey.org/docs/installation

Clear-Host


Write-Host "

  __  __                           _   _______             _      
 |  \/  |                         | | |__   __|           | |     
 | \  / |  __ _  _ __ __   __ ___ | |    | |  ___    ___  | | ___ 
 | |\/| | / _` || '__|\ \ / // _ \| |    | | / _ \  / _ \ | |/ __|
 | |  | || (_| || |    \ V /|  __/| |    | || (_) || (_) || |\__ \
 |_|  |_| \__,_||_|     \_/  \___||_|    |_| \___/  \___/ |_||___/
                                                                  

                        ▒▒▒▒                  
                      ▒▒▒▒▒▒▒▒                
                    ▒▒▒▒▒▒▒▒▒▒▒▒              
                  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒            
                ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒          
              ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒        
              ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒      
                ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒    
                  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  
                    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
                    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
                    ████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒
                  ██████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒  
                ████████  ░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒    
              ████████      ▒▒▒▒▒▒▒▒▒▒▒▒      
            ████████          ▒▒▒▒▒▒▒▒        
          ████████              ▒▒▒▒          
        ████████                              
      ████████                                
    ████████                                  
  ███████                                    
 ███████                                      
██████                                        

"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "Installing Chocolatey" -ForegroundColor Green
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))


Write-Host "Installing Chrome" -ForegroundColor Green
choco install googlechrome -y

Write-Host "Installing Git" -ForegroundColor Green
choco install git.install -y
powershell.exe refreshenv
refreshenv
refreshenv

Write-Host "Installing Tools" -ForegroundColor Green
New-Item -Path "C:\" -Name "Tools" -ItemType "directory"
New-Item -Path "C:\Tools" -Name "Blue" -ItemType "directory"
New-Item -Path "C:\Tools" -Name "Red" -ItemType "directory"

#Powersploit:
$Powersploit = "https://github.com/PowerShellMafia/PowerSploit/archive/dev.zip"
Invoke-WebRequest $Powersploit -OutFile "C:\Tools\Red\PowerSploit.zip"

#Rubeus:
git clone https://github.com/GhostPack/Rubeus.git C:\Tools\Red\Rubeus

#Powershell Arsenal:
git clone https://github.com/mattifestation/PowerShellArsenal.git C:\Tools\Red\PowershellArsenal

#Seatbelt: 
git clone https://github.com/GhostPack/Seatbelt.git C:\Tools\Red\Seatbelt

#Mimikatz:
$mimikatz = "https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20200502/mimikatz_trunk.zip"
Invoke-WebRequest $mimikatz -OutFile "C:\Tools\Red\Mimikatz.zip"

#Wireshark:
choco install wireshark -y

#Notepad++:
choco install notepadplusplus -y

