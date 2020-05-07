# Marvel-Lab
A collection of scripts that will help automate the build process for a Marvel domain. 

<img src="https://thumbs.gfycat.com/KlutzyIdealisticCanine-size_restricted.gif" width=900 />

**These scripts assume the path to the folder is C:\Marvel-Lab. If this isn't the path of the repo, the scripts will error out.**

## Build Steps: 

**Domain Controller**: 
1. Build stock Windows Server VM. 
2. Go into Server and download this repo into the `C:\` directory. If you downloaded the .zip of the repo, move the child folder to the C:\ directory and rename to `Marvel-Lab`. 
3. Go into the `Earth-DC` folder. 
4. Run these scripts in order: 
  * `rename-dc.ps1`
  * `deploying-marvel-forest.ps1`
  * `import-marvel-users.ps1`
  * `add-ou.ps1`
  * `Import-GPOBackup.ps1`
   * Install Logging. Go to **Logging** below and follow steps. 


**Workstations**:
1. Build Windows 10 VM.
2. Go into one of the Windows VM and download this repo into the `C:\` directory. If you downloaded the .zip of the repo, move the child folder to the C:\ directory and rename to `Marvel-Lab`. 
3. Go into one of the Workstaion folders. This project supports two different Workstations. 
4. Run these scripts in order: 
  * `rename-workstation.ps1`
  * `join-domain.ps1` 
  
**Note:** If `join-domain.ps1` fails, make sure that the host is pointing to Earth-DC's IP for DNS. 

  * Install Logging. Go to **Logging** below and follow steps. 
  
  
**Logging:**

**Note**: Only Ubuntu 18 is supported for this script. 

### Steps to get logging set up: 

#### On Ubuntu box: 
1. On the Ubuntu machine download the Marvel-Lab repository. 
2. Go into `Marvel-Lab\Logging\splunk` and run `splunk_logging.sh`.

#### On Workstation and DC:
1. Download the Marvel-Lab repository in the `C:\` directory. (If you downloaded the .zip of the repo, move the child folder to the C:\ directory and rename to `Marvel-Lab`). 
2. Go into `Marvel-Lab\Logging` and run `Logging.ps1`. 

## Troubleshooting tips
1. It is very likely the GPO's: `Workstation Local Administrator Policy` and `RDP` will not work. This is a SID problem with the groups within AD. You can fix this one of two ways: 

**Preferred method:** 
Steps to fix `RDP` GPO:


```
Tools -> Group Policy Management -> Domains -> marvel.local -> Workstations -> RDP; Right click -> Edit; Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Restricted Groups; Right click on SID -> Delete; Right click -> Add Group -> Browse -> Input: Domain Users -> Ok ->  Ok -> within "this group is a member of" click Add -> Browse -> input: Remote Desktop Users -> Ok -> Ok -> Apply -> Ok
```

The `RDP` policy should look like this: 

<p align="center"><img src="https://github.com/jsecurity101/Marvel-Lab/blob/master/images/RDP.PNG"></p>


Steps to fix `Workstation Local Administrator Policy` GPO:

```
Tools -> Group Policy Management -> Domains -> marvel.local -> Workstations -> Workstation Local Administrators; Right click -> Edit; Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Restricted Groups; Right click on SID -> Delete; Right click -> Add Group -> Browse -> Input LocalAdmins -> Ok ->  Ok -> within "this group is a member of" click Add -> Browse -> input: Administrators -> Ok -> Ok -> Apply -> Ok
```

The `Workstation Local Administrator Policy` should look like this: 

<p align="center"><img src="https://github.com/jsecurity101/Marvel-Lab/blob/master/images/LocalAdmin.PNG"></p>

**Yolo Method:** 
* Delete these two GPO's and implement locally on box. 

2. If you do not see the GPO's are being properly pushed to your workstation, go to workstation open powershell.exe and run: `gpupate /force`. 


## Scripts:

  * `rename-dc.ps1`
    * Powershell script that will rename the computer name of the Domain Controller to: Earth-DC.
  
  * `deploying-marvel-forest.ps1`
    * Powershell script that will create and deploy a forest with the domain name of: marvel.local

  * `import-marvel-users.ps1`
    * Powershell script that imports marvel characters from a csv into the AD infrastructure. This script will assign groups to domain users as well. 

  * `add-ou.ps1`
    * Powershell script that will add the Workstation organizational unit to the AD infrastructure. 

  * `Import-GPOBackup.ps1`
    * Powershell script that will import mulitple Group Policy Objects (GPOs) into the group policy management. GPO's will be linked and enforced with this script as well. 

  * `rename-workstation.ps1`
    * Powershell script that will rename the computer name of the Win10 workstation to either: Asgard-WrkStn or Wakanda-Wrkstn
  
  * `join-domain.ps1`
    * Powershell script that will join the workstation to the marvel.local.

  * `Logging.ps1`
    * Powershell script will give 3 options for endpoint logging: 
     1. Just to install [Sysmon](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon). 
     2. To install Sysmon and send logs to a [HELK](https://github.com/Cyb3rWard0g/HELK) build (we do not build this for you, it assumes you already have it built). 
     3. To install Sysmon and send logs to Splunk.
   
  * `splunk_logging.sh`
    * Bash script that will build out Splunk, Portainer, and Jupyter Notebooks within a docker container. 

# Authors:
* [Jonathan Johnson](https://twitter.com/jsecurity101) 
* [Ben Shell](https://twitter.com/UsernameIsBen)


# To Do List: 

* Add OSQuery
* Add Zeek/Bro Logs
* Add update scripts 
