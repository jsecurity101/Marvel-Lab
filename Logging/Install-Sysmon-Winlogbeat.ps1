#Author: Jonathan Johnson
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12  



$WinlogbeatUrl = "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-7.5.2-windows-x86_64.zip"
$WinlogbeatOutputFile = "winlogbeat.zip"
$WinlogbeatConfig = "https://gist.github.com/jsecurity101/ec4c829e6d32a984d7ccf4c1e9247590/archive/8d85c6c443704e821a7f53e536be61667c67febd.zip"
$WinlogZip = "winlogconfig.zip"

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

#Downloading and Installing Winlogbeat
New-Item -Path "c:\" -Name "Winlogbeat" -ItemType "directory"

Invoke-WebRequest $WinlogbeatUrl -OutFile C:\Winlogbeat\$WinlogbeatOutputFile
Expand-Archive -LiteralPath C:\Winlogbeat\$WinlogbeatOutputFile -DestinationPath C:\Winlogbeat\

Invoke-WebRequest $WinlogbeatConfig -OutFile C:\Winlogbeat\$WinlogZip
Expand-Archive -LiteralPath C:\Winlogbeat\$WinlogZip -DestinationPath C:\Winlogbeat\

Remove-Item C:\Winlogbeat\winlogbeat-7.5.2-windows-x86_64\winlogbeat.yml
Move-Item C:\Winlogbeat\ec4c829e6d32a984d7ccf4c1e9247590-8d85c6c443704e821a7f53e536be61667c67febd\winlogbeat.yml C:\Winlogbeat\winlogbeat-7.5.2-windows-x86_64\
Remove-Item C:\Winlogbeat\$WinlogZip, C:\Winlogbeat\ec4c829e6d32a984d7ccf4c1e9247590-8d85c6c443704e821a7f53e536be61667c67febd

$IP = Read-Host "Enter IP of HELK box"

(Get-Content C:\Winlogbeat\winlogbeat-7.5.2-windows-x86_64\winlogbeat.yml).replace('<HELK-IP>', $IP) | Set-Content C:\Winlogbeat\winlogbeat-7.5.2-windows-x86_64\winlogbeat.yml

Remove-Item C:\Winlogbeat\$WinlogbeatOutputFile 

C:\Winlogbeat\winlogbeat-7.5.2-windows-x86_64\install-service-winlogbeat.ps1 

Start-Service winlogbeat