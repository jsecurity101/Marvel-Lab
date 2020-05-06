# Marvel-Lab
A collection of scripts that will help automate the build process for a Marvel domain. 

<img src="https://thumbs.gfycat.com/KlutzyIdealisticCanine-size_restricted.gif" width=900 />

**These scripts assume the path to the folder is C:\Marvel-Lab. If this isn't the path of the repo, the scripts will error out.**

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
   * Install Logging. Go to **Logging** below and follow steps. 


**Workstations**:
1. Build Windows 10 VM.
2. Go into one of the Windows VM and download this repoo into the `C:\` directory. 
3. Go into one of the Workstaion folders. This project supports two different Workstations. 
4. Run these scripts in order: 
  * `rename-workstation.ps1`
  * `join-domain.ps1`
  * Install Logging. Go to **Logging** below and follow steps. 
  
  
**Logging:**

`splunk_logging.sh` is stored in the Logging directory. This will install docker containers for: Portainer, Jupyter Notebooks, and Splunk. 

**Note**: Only Ubuntu 18 is supported for this script. 

`Logging.ps1` offers three different build options. 
1. Just to install [Sysmon](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon). 
2. To install Sysmon and send logs to a [HELK](https://github.com/Cyb3rWard0g/HELK) build (we do not build this for you, it assumes you already have it built). 
3. To install Sysmon and send logs to Splunk. 

### Steps to get logging set up: 

1. On the Ubuntu machine download the Marvel-Lab repository. 
2. Go into `Marvel-Lab\Logging\splunk` and run `splunk_logging.sh`.
3. On the Workstation and Domain-Controller down the the he Marvel-Lab repository in the `C:\` directory. (If .zip is downloaded take out the second Marvel-Lab folder and put it in `C:\` directory). 
4. Go into `Marvel-Lab\Logging` and run `Logging.ps1`. 



## Troubleshooting tips
1. It is very likely the GPO's: `Workstation Local Administrator Policy` and `RDP` will not work. This is a SID problem with the groups within AD. You can fix this one of two ways: 

**Preferred method:** 
Steps to fix `RDP` GPO:

Tools -> Group Policy Management -> Domains -> marvel.local -> Workstations -> RDP; Right click -> Edit; Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Restricted Groups; Right click on SID -> Delete; Right click -> Add Group -> Browse -> Input: Domain Users -> Ok ->  Ok -> within "this group is a member of" click Add -> Browse -> input: Remote Desktop Users -> Ok -> Ok -> Apply -> Ok

The `RDP` policy should look like this: 

<p align="center"><img src="https://github.com/jsecurity101/Marvel-Lab/blob/master/images/RDP.PNG"></p>


Steps to fix `Workstation Local Administrator Policy` GPO:

Tools -> Group Policy Management -> Domains -> marvel.local -> Workstations -> Workstation Local Administrators; Right click -> Edit; Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Restricted Groups; Right click on SID -> Delete; Right click -> Add Group -> Browse -> Input LocalAdmins -> Ok ->  Ok -> within "this group is a member of" click Add -> Browse -> input: Administrators -> Ok -> Ok -> Apply -> Ok

The `Workstation Local Administrator Policy` should look like this: 

<p align="center"><img src="https://github.com/jsecurity101/Marvel-Lab/blob/master/images/LocalAdmin.PNG"></p>

**Yolo Method:** 
* Delete these two GPO's and implement locally on box. 

2. If you do not see the GPO's are being properly pushed to your workstation, go to workstation open powershell.exe and run: `gpupate /force`. 

# Author:
* [Jonathan Johnson](https://twitter.com/jsecurity101) 
* [Ben Shell](https://twitter.com/UsernameIsBen)


# To Do List: 

* Add OSQuery
* Add Zeek/Bro Logs
