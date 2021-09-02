#Author: Jonathan Johnson
#Resources -
#https://chocolatey.org/docs/installation

function Show-Menu {
  [CmdletBinding()]
  param (
      [string]$Question = 'Which Tool option would you like?'
  )

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
    Write-Host "================ $Question =============="
    Write-Host "1: Press '1' to install  Red team tools, Blue team tools, and basic tooling."
    Write-Host "2: Press '2' to install Red team tools, Blue team tools, basic tooling and Debugging Tools."
    Write-Host "3: Press '3' to install Debugging Tools."

}

Write-Host "Checking for elevated permissions..."
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
[Security.Principal.WindowsBuiltInRole] "Administrator")) {
Write-Warning "You need to run this script as an Administrator. Please open up new window as Administrator."
Break
}
else {

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "Installing Tools" -ForegroundColor Green
New-Item -Path "C:\" -Name "Tools" -ItemType "directory"

function Install-Basic {
  Write-Host "Installing Chocolatey" -ForegroundColor Green
  Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  
  Write-Host "Installing Chrome" -ForegroundColor Green
  choco install googlechrome -y
  
  Write-Host "Installing Git" -ForegroundColor Green
  choco install git.install -y
  $env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
  Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
  refreshenv 
  refreshenv 

#Wireshark:
choco install -y --limit-output --no-progress wireshark winpcap #command borrowed from - https://github.com/clong/DetectionLab/blob/6525456492bc311c3ae061adb854691f424e4ba7/Vagrant/scripts/install-choco-extras.ps1#L13

#Notepad++:
choco install notepadplusplus -y

}
    
function Install-Red-Team {

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
$release = (Invoke-WebRequest "https://api.github.com/repos/gentilkiwi/mimikatz/releases" -UseBasicParsing | ConvertFrom-Json)[0].tag_name #Line taken from: https://github.com/clong/DetectionLab/blob/eabe0fa90c7d0a85b18e0f7557b00d5ca055d646/Vagrant/scripts/install-redteam.ps1#L36
$mimikatz = "https://github.com/gentilkiwi/mimikatz/releases/download/$release/mimikatz_trunk.zip"
Invoke-WebRequest $mimikatz -OutFile "C:\Tools\Red\Mimikatz.zip"

}

function Install-Blue-Team {

  New-Item -Path "C:\Tools" -Name "Blue" -ItemType "directory"

#Sysinternals:
$Sysinternals = "https://download.sysinternals.com/files/SysinternalsSuite.zip"
Invoke-WebRequest $Sysinternals -OutFile "C:\Tools\Blue\Sysinternals.zip"


}
function Install-Debugging {

New-Item -Path "c:\" -Name "Tools" -ItemType "directory"
New-Item -Path "c:\Tools" -Name "APIMonitor" -ItemType "directory"
New-Item -Path "c:\Tools" -Name "WindowsSDK" -ItemType "directory"
New-Item -Path "c:\Tools" -Name "IDAPro" -ItemType "directory"

# Downloads -
# API Monitoring: 
$APIMonitorx64 = "http://www.rohitab.com/download/api-monitor-v2r13-setup-x64.exe"
$APIMonitorx86 = "http://www.rohitab.com/download/api-monitor-v2r13-setup-x86.exe"

#DnSpy:
$version = (Invoke-WebRequest "https://api.github.com/repos/dnspy/dnspy/releases" -UseBasicParsing | ConvertFrom-Json)[0].tag_name
$Dnspy = "https://github.com/dnSpy/dnSpy/releases/download/$version/dnSpy-net-win64.zip"

#IDAPro: 
$IDAPro = "https://out7.hex-rays.com/files/idafree70_windows.exe"

#Windows 10 SDK:
$WindowsSDK = "https://go.microsoft.com/fwlink/p/?linkid=2083338&clcid=0x409"

if ((gwmi win32_operatingsystem | select osarchitecture).osarchitecture -eq "64-bit")
{
    Write "You have a 64-bit system"
    Invoke-WebRequest $APIMonitorx64 -OutFile "C:\Tools\APIMonitor\api-monitor.exe"
    Invoke-WebRequest $Dnspy -OutFile "C:\Tools\dnspy-net.zip"
    Invoke-WebRequest $WindowsSDK -OutFile "C:\Tools\WindowsSDK\winsdksetup.exe"
    Invoke-WebRequest $IDAPro -OutFile "C:\Tools\IDAPro\IDAPro.exe"
}
else
{
    Write "You have a 32-bit system"
    Invoke-WebRequest $APIMonitorx86 -OutFile "C:\Tools\APIMonitor\api-monitor.exe"
    Invoke-WebRequest $Dnspy -OutFile "C:\Tools\dnspy-net.zip"
    Invoke-WebRequest $WindowsSDK -OutFile "C:\Tools\WindowsSDK\winsdksetup.exe"
    Invoke-WebRequest $IDAPro -OutFile "C:\Tools\IDAPro\IDAPro.exe"

}

#Install Windows SDK: 
#This will take a couple of minutes to show up in C:\Tools\WindowsSDK\WindowsKits
C:\Tools\WindowsSDK\winsdksetup.exe /features + /installpath 'C:\Tools\WindowsSDK\WindowsKits\10\' /q 

}

do
 {
    Welcome_Banner
    Show-Menu
$selection = Read-Host "Please make a selection"
    switch ($selection)
    {
    '1' {
    Write-Host "You chose to install Red team tools, Blue team tools, and basic tooling."
    Install-Basic
    Install-Red-Team
    Install-Blue-Team
    } 
    '2' {
    Write-Host "You chose to install Red team tools, Blue team tools, basic tooling and Debugging Tools."
    Install-Basic
    Install-Red-Team
    Install-Blue-Team
    Install-Debugging
    } 
    '3' {
    Write-Host "You chose to install Debugging Tools."
    Install-Debugging
    }
    }
 }
 until ($selection -eq '1' -or '2' -or '3' )

}


