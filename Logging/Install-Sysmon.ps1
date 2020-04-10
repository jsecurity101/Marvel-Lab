#Author: Jonathan Johnson
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12  


#Sysmon Arguments:
$SysmonUrl = "https://download.sysinternals.com/files/Sysmon.zip"
$SysmonOutputFile = "Sysmon.zip"
$SysmonConfig = "https://gist.github.com/jsecurity101/77fbb4d01887af8700b256a612094fe2/archive/158478cacd3a20eca0845b6a4b9f463d9c6c75f1.zip"
$SysmonZip = "sysmon.zip"


New-Item -Path "c:\" -Name "Sysmon" -ItemType "directory"
#Downloading and Installing Sysmon 
Invoke-WebRequest $SysmonUrl -OutFile C:\Sysmon\$SysmonOutputFile
Expand-Archive -LiteralPath C:\Sysmon\$SysmonOutputFile -DestinationPath C:\Sysmon\

#Pulling Sysmon Config
Invoke-WebRequest $SysmonConfig -OutFile C:\Sysmon\$SysmonZip
Expand-Archive -LiteralPath C:\Sysmon\$SysmonZip -DestinationPath C:\Sysmon\
Move-Item C:\Sysmon\77fbb4d01887af8700b256a612094fe2-158478cacd3a20eca0845b6a4b9f463d9c6c75f1\sysmon.xml C:\Sysmon
Remove-Item C:\Sysmon\$SysmonOutputFile, C:\Sysmon\77fbb4d01887af8700b256a612094fe2-158478cacd3a20eca0845b6a4b9f463d9c6c75f1
C:\Sysmon\Sysmon64.exe -accepteula -i C:\Sysmon\sysmon.xml 