********************
Script Explanations 
********************
-  ``rename-dc.ps1``

   -  Powershell script that will rename the computer name of the Domain
      Controller to: Earth-DC.

-  ``deploying-marvel-forest.ps1``

   -  Powershell script that will create and deploy a forest with the
      domain name of: marvel.local

-  ``import-marvel-users.ps1``

   -  Powershell script that imports marvel characters from a csv into
      the AD infrastructure. This script will assign groups to domain
      users as well.

-  ``add-ou.ps1``

   -  Powershell script that will add the Workstation organizational
      unit to the AD infrastructure.

-  ``Import-GPOBackup.ps1``

   -  Powershell script that will import mulitple Group Policy Objects
      (GPOs) into the group policy management. GPO’s will be linked and
      enforced with this script as well.

-  ``rename-workstation.ps1``

   -  Powershell script that will rename the computer name of the Win10
      workstation to either: Asgard-WrkStn or Wakanda-Wrkstn

-  ``join-domain.ps1``

   -  Powershell script that will join the workstation to the
      marvel.local.

-  ``updating-groups.ps1``

   -  Powershell script that will add users within the LocalAdmin group
      in AD to the Local Administrators and Remote Desktop Users groups
      on the host.
   - This script will also set a wallpaper for the current user NOT all users. If you want to update the wallpaper per user run this following: 

   ::
    
      New-Item HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ -Name System
        
        
   ::
   
      Set-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\\System' -name Wallpaper -value "C:\Marvel-Lab\images\<image_name>.jpg"
        
   ::
     
      Set-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\\System' -name WallpaperStyle -value "4"

-  ``Logging.ps1``

   -  Powershell script will give 3 options for endpoint logging:

   1) Just to install `Sysmon`_.
   2) To install Sysmon and send logs to a `HELK`_ build (we do not
      build this for you, it assumes you already have it built).
   3) To install Sysmon and send logs to Splunk.

-  ``Tools.ps1``

   -  Powershell script that will install various different Red-Team
      tools and Wireshark.

-  ``splunk_logging.sh``

   -  Bash script that will build out Splunk, Portainer, and Jupyter
      Notebooks within a docker container.

.. _Sysmon: https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon
.. _HELK: https://github.com/Cyb3rWard0g/HELK