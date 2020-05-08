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
2. Go into one of the Windows VMs and download this repo into the `C:\` directory. If you downloaded the .zip of the repo, move the child folder to the C:\ directory and rename to `Marvel-Lab`. 
3. Go into one of the Workstaion folders. This project supports two different Workstations. 
4. Run these scripts in order: 
  * `rename-workstation.ps1`
  * `join-domain.ps1` 
  * `updating-groups.ps1`
  * `Tools.ps1`
  
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


**Note:** The Sysmon configuration is up to date with version - 11.0. FileDelete Events will only be logged within the \Downloads\ folder of each user. Deletions are saved within the C:\ArchivedFiles\ folder. 

## Troubleshooting tips
1. If the docker containers are not starting correctly after reboot, run `sudo docker ps` on the splunk box. Make sure the containers were started. 

2. If you do not see the GPO's are being properly pushed to your workstation, go to workstation open powershell.exe and run: `gpupate /force`. 


## Script Explanations:

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

  * `updating-groups.ps1`
    * Powershell script that will add users within the LocalAdmin group in AD to the Local Administrators and Remote Desktop Users groups on the host.  

  * `Logging.ps1`
    * Powershell script will give 3 options for endpoint logging: 
     1) Just to install [Sysmon](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon). 
     2) To install Sysmon and send logs to a [HELK](https://github.com/Cyb3rWard0g/HELK) build (we do not build this for you, it assumes you already have it built). 
     3) To install Sysmon and send logs to Splunk.

  *  `Tools.ps1`
     *  Powershell script that will install various different Red-Team tools and Wireshark. 
   
  * `splunk_logging.sh`
    * Bash script that will build out Splunk, Portainer, and Jupyter Notebooks within a docker container. 

## Support: 

* Windows 10 +
* Windows Server 2016 +
* Ubuntu 18 +

# Authors:
* [Jonathan Johnson](https://twitter.com/jsecurity101) 
* [Ben Shell](https://twitter.com/UsernameIsBen)


# To Do List: 

* Add OSQuery
* Add Zeek/Bro Logs
* Add update scripts 
* Add box resource suggestions
