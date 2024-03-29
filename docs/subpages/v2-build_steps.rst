***********
Build Steps
***********

Domain Controller:
##################

1. Build stock Windows Server VM.
2. Go into Server and download this repo into the ``C:\`` directory. If
   you downloaded the .zip of the repo, move the child folder to the
   C: directory and rename to ``Marvel-Lab``.
3. Go into the ``Marvel-Lab`` folder.
4. Import Marvel-Lab Module - ``Import-Module Marvel-Lab.psd1``
5. You can either run the scripts separately or automate the process: 
   
   Automated: 
   ``Rename-DC -Password <password> -Automate``
   **Note:** If you choose to perform the build in an automated fashion,  you will need to log into the box after the Rename-DC module runs and restarts the box.

   Separately:
-  ``Rename-DC``
-  ``Initialize-MarvelDomain -Password 'Changeme1!'``
-  ``Update-Workstation``


-  Install Logging. Go to **Logging** below and follow steps.
-  Build logs will be stored in ``C:\Marvel-Lab\DeploymentLog.txt``.

Workstations (Windows):
#############

1. Build Windows 10 VM.
2. Go into Server and download this repo into the ``C:\`` directory. If
   you downloaded the .zip of the repo, move the child folder to the
   C: directory and rename to ``Marvel-Lab``.
3. Go into the ``Marvel-Lab`` folder.
4. Import Marvel-Lab Module - ``Import-Module Marvel-Lab.psd1``
5. Go into network adapters and set the DNS to the DC's IP. If you can't ping ``marvel.local`` the domain joining script will fail.
6. You can either run the scripts separately or automate the process: 
   
   Automated: 
   ``Rename-Workstation -Automate``
   **Note:** If you choose to perform the build in an automated fashion,  you will need to log into the box after the Rename-DC module runs and restarts the box.

   Separately:
-  ``Rename-Workstation``
-  ``Join-Domain``
-  ``Update-Workstation``
-  ``Get-Tools``

-  Install Logging. Go to **Logging** below and follow steps.
-  Build logs will be stored in ``C:\Marvel-Lab\DeploymentLog.txt``.

Logging:
########

Steps to get logging set up:
****************************

Install the required scripts on the Ubuntu box first before setting up logging on endpoints.


On Ubuntu box:
**************

1. Install Docker by following these steps, assuming you’re on Ubuntu: https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository.
2. Install Docker Compose by following the documentation here: https://docs.docker.com/compose/install/.
3. On the Ubuntu machine download the Marvel-Lab repository.
4. Go into ``Marvel-Lab\Logging\`` and run ``setup_logging.sh``.

**Note**: Only Ubuntu 22.04+ is supported for this script.


On Windows Workstation and DC:
******************************

**Note**: In order to receive logs in Splunk, the ``setup_logging.sh`` script must have succeeded on the Logger box (Ubuntu).

1. Go into the Server and download this repo into the ``C:\`` directory. If you downloaded the .zip of the repo, move the child folder to the C:\ directory and rename to ``Marvel-Lab``.
2. Go into the ``Marvel-Lab`` folder.
3. Import Marvel-Lab Module - ``Import-Module Marvel-Lab.psd1``
4. Logging supports ELK and Splunk
   * For ELK: 
   -  Pull the ``elk.cert`` from the Ubuntu box.
   ``Install-Logging -SIEM_IP 127.0.0.1 -ELK -ELK_Cert_Path C:\elk.crt``

   * For Splunk: 
   ``Install-Logging -SIEM_IP 127.0.0.1 -Splunk``

**Note:** The Sysmon configuration is up to date with version - 14.0.
FileDelete Events will only be logged within the
``\Downloads`` folder of each user. Deletions are saved within
the ``C:\ArchivedFiles`` folder.

