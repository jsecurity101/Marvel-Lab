***********
Build Steps
***********

Domain Controller:
##################

1. Build stock Windows Server VM.
2. Go into Server and download this repo into the ``C:\`` directory. If
   you downloaded the .zip of the repo, move the child folder to the
   C: directory and rename to ``Marvel-Lab``.
3. Go into the ``Earth-DC`` folder.
4. Run these scripts in order:

-  ``rename-dc.ps1``
-  ``deploying-marvel-forest.ps1``
-  ``import-marvel-users.ps1``
-  ``add-ou.ps1``
-  ``Import-GPOBackup.ps1``
-  Install Logging. Go to **Logging** below and follow steps.

Workstations (Windows):
#############

1. Build Windows 10 VM.
2. Go into one of the Windows VMs and download this repo into the
   ``C:\`` directory. If you downloaded the .zip of the repo, move the
   child folder to the C: directory and rename to ``Marvel-Lab``.
3. Go into one of the Workstaion folders. This project supports two
   different Workstations.
4. Run these scripts in order:

-  ``rename-workstation.ps1``
-  ``join-domain.ps1``
-  ``updating-groups.ps1``
-  ``Tools.ps1``
-  Install Logging. Go to **Logging** below and follow steps.

**Note:** If ``join-domain.ps1`` fails, make sure that the host is
pointing to Earth-DC’s IP for DNS.

Workstations (MacOS):
#############

1. Build Mac VM.
2. Pull down the Marvel-Lab repo
3. Go into the ``Marvel-Lab/Workstations/MacOS/`` directory 
4. Run these scripts in order:

-  ``build.sh``
-  ``tools.sh``
-  Install Logging. Go to **Logging** below and follow steps.

**Note:** If ``build.sh`` fails, make sure that the host is
pointing to Earth-DC’s IP for DNS.

Adding Earth-DC's IP:  ``System Preferences -> Network -> Ethernet Adapter -> Advanced -> DNS -> Add the IP of Earth-DC under DNS Servers``

Adding domain name to ``Search Domains``:  ``System Preferences -> Network -> Ethernet Adapter -> Advanced -> DNS -> Add marvel.local in the Search Domains``


Logging:
########

Steps to get logging set up:
****************************

If you plan on using Splunk/Jupyter Notebooks/OSQuery/Kolide - install the required scripts on the Ubuntu box first before setting up logging on endpoints.


On Ubuntu box:
###############

1. On the Ubuntu machine download the Marvel-Lab repository.
2. Go into ``Marvel-Lab\Logging\splunk`` and run ``splunk_logging.sh``.
3. Go to the hosts and AFTER Kolide has been set up from the ``On Windows Workstation and DC`` instructions, run ``fleet-pack.sh``. 

**Note**: Only Ubuntu 18+ is supported for this script.

On Windows Workstation and DC:
##############################

**In order to recieve logs in Splunk, the ``splunk_logging.sh`` script must have succeeded on the Logger box (Ubuntu).**

1. Download the Marvel-Lab repository in the ``C:\`` directory. (If you
   downloaded the .zip of the repo, move the child folder to the
   C: directory and rename to ``Marvel-Lab``).
2. Go to KolideIP:8443, set up Username/Password. 
3. Set Organization Name to ``Marvel Lab``. You don't have to do the URL. When it shows you the fleet web address, press Submit, then Finish. 
4. Go into ``Marvel-Lab\Logging`` and run ``Logging.ps1``.

**Note:** The Sysmon configuration is up to date with version - 11.0.
FileDelete Events will only be logged within the
``\Downloads`` folder of each user. Deletions are saved within
the ``C:\ArchivedFiles`` folder.



On MacOS Workstation:
######################
1. Run ``logging.sh``
2. During installation there will be some prompt that will need to be filled in when accepting the Splunk License. Exact steps are below: 
- Press Enter
- Press q
- Press y, then Enter
- Enter admin username/password of your choice (You might have to do this twice)  