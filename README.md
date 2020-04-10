# Marvel-Lab
A collection of Powershell scripts that will help automate the build process for a Marvel domain. 

<img src="https://thumbs.gfycat.com/KlutzyIdealisticCanine-size_restricted.gif" width=900 />

## Build Steps: 

**Domain Controller**: 
1. Build stock Windows Server VM. 
2. Go into Server and download this repo into the `C:\` directory. 
3. Go into the `Earth-DC` folder. 
4. Run these scripts in order: 
  * `rename-dc.ps1`
  * `deploying-marvel-forest.ps1`
  * `import-marvel-users.ps1`
  * `add-ou.ps1`
  * `Import-GPOBackup`


**Workstations**:
1. Build Windows 10 VM.
2. Go into one of the Windows VM and download this repoo into the `C:\` directory. 
3. Go into one of the Workstaion folders. This project supports two different Workstations. 
4. Run these scripts in order: 
  * `rename-workstation.ps1`
  * `join-domain.ps1`
  
  
**Logging:**
Two different scripts. One is just to install [Sysmon](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon). The other is to install Sysmon and send logs to a [HELK](https://github.com/Cyb3rWard0g/HELK) build. Future version might have a Splunk/Sysmon script. 

**Troubleshooting tips**
1. It is very likely the GPO's: `Workstation Local Administrator Policy` and `RDP` will not work. This is a SID problem with the groups within AD. You can fix this one of two ways: 

**Preferred method:** 
* Fix the Restricted Groups within each policy. Go to: `Computer Configuration -> Policy -> Windows Settings -> Security Settings -> Restricted Groups`. 

The `RDP` policy should look like this: 

<p align="center"><img src="https://github.com/jsecurity101/Marvel-Lab/images/RDP.PNG"></p>

The `Workstation Local Administrator Policy` should look like this: 

<p align="center"><img src="https://github.com/jsecurity101/Marvel-Lab/images/LocalAdmin.PNG"></p>

**Yolo Method:** 
* Delete these two GPO's and implement locally on box. 

2. If you do not see the GPO's are being properly pushed to your workstation, go to workstation open powershell.exe and run: `gpupate /force`. 

## Notes from Author: 
This project is not officially supported. Tickets will probably be closed immediately. However, in the future there will be updates as I see fit. 
