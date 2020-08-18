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

Workstations:
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

Logging:
########

Steps to get logging set up:
****************************

If you plan on using Splunk/Jupyter Notebooks/OSQuery/Kolide - install the required scripts on the Ubuntu box first before setting up logging on endpoints.


On Ubuntu box:
###############

1. On the Ubuntu machine download the Marvel-Lab repository.
2. Go into ``Marvel-Lab\Logging\splunk`` and run ``splunk_logging.sh``.

**Note**: Only Ubuntu 18 is supported for this script.

On Workstation and DC:
######################

1. Download the Marvel-Lab repository in the ``C:\`` directory. (If you
   downloaded the .zip of the repo, move the child folder to the
   C: directory and rename to ``Marvel-Lab``).
2. Go into ``Marvel-Lab\Logging`` and run ``Logging.ps1``.

**Note:** The Sysmon configuration is up to date with version - 11.0.
FileDelete Events will only be logged within the
``\Downloads`` folder of each user. Deletions are saved within
the ``C:\ArchivedFiles`` folder.