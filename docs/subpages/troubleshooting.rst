*********************
Troubleshooting Steps 
*********************

1. If the docker containers are not starting correctly after reboot, run
   ``sudo docker ps`` on the splunk box. Make sure the containers were
   started.

2. If you do not see the GPO’s are being properly pushed to your
   workstation, go to workstation open powershell.exe and run:
   ``gpupate /force``.