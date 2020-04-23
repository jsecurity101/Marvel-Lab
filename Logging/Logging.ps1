#Author Jonathan Johnson

#References:https://powershellexplained.com/2016-10-21-powershell-installing-msi-files/ && https://docs.splunk.com/Documentation/Splunk/8.0.3/Installation/InstallonWindowsviathecommandline

using namespace System.Management.Automation.Host

function Show-Menu {
    [CmdletBinding()]
    param (
        [string]$Question = 'Which logging option would you like?'
    )

    Clear-Host
    Write-Host     Write-Host "
███╗   ███╗ █████╗ ██████╗ ██╗   ██╗███████╗██╗         ██╗      ██████╗  ██████╗  ██████╗ ██╗███╗   ██╗ ██████╗ 
████╗ ████║██╔══██╗██╔══██╗██║   ██║██╔════╝██║         ██║     ██╔═══██╗██╔════╝ ██╔════╝ ██║████╗  ██║██╔════╝ 
██╔████╔██║███████║██████╔╝██║   ██║█████╗  ██║         ██║     ██║   ██║██║  ███╗██║  ███╗██║██╔██╗ ██║██║  ███╗
██║╚██╔╝██║██╔══██║██╔══██╗╚██╗ ██╔╝██╔══╝  ██║         ██║     ██║   ██║██║   ██║██║   ██║██║██║╚██╗██║██║   ██║
██║ ╚═╝ ██║██║  ██║██║  ██║ ╚████╔╝ ███████╗███████╗    ███████╗╚██████╔╝╚██████╔╝╚██████╔╝██║██║ ╚████║╚██████╔╝
╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚══════╝    ╚══════╝ ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
"
    Write-Host "================ $Question =============="
    Write-Host "1: Press '1' to install Sysmon with no forwarding."
    Write-Host "2: Press '2' for Sysmon + Winlogbeat which will forward Sysmon and Windows Events to HELK/ELK Instance."
    Write-Host "3: Press '3' for Sysmon + Splunk UF which will forward Sysmon and Windows Events to Splunk."

}
function Install-Sysmon {
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

Write-Host "Installing Sysmon.." -ForegroundColor Green
& cmd.exe /c 'C:\Sysmon\Sysmon64.exe -accepteula -i C:\Sysmon\sysmon.xml 2>&1'  
}

function Install-Sysmon-HELK {
$HELK_IP = Read-Host "Please input the IP of your HELK/ELK box"
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

Write-Host "Installing Sysmon.." -ForegroundColor Green
& cmd.exe /c 'C:\Sysmon\Sysmon64.exe -accepteula -i C:\Sysmon\sysmon.xml 2>&1' 

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
}

function Install-Sysmon-Splunk {
$Splunk_IP = Read-Host "Please input the IP of your Splunk box"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12  


#Sysmon Arguments:
$SysmonUrl = "https://download.sysinternals.com/files/Sysmon.zip"
$SysmonOutputFile = "Sysmon.zip"
$SysmonConfig = "https://gist.github.com/jsecurity101/77fbb4d01887af8700b256a612094fe2/archive/158478cacd3a20eca0845b6a4b9f463d9c6c75f1.zip"
$SysmonZip = "sysmon.zip"

#Splunk Arugments:
$SplunkUF = "https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=windows&version=8.0.3&product=universalforwarder&filename=splunkforwarder-8.0.3-a6754d8441bf-x64-release.msi&wget=true"


New-Item -Path "c:\" -Name "Sysmon" -ItemType "directory"
#Downloading and Installing Sysmon 
Invoke-WebRequest $SysmonUrl -OutFile C:\Sysmon\$SysmonOutputFile
Expand-Archive -LiteralPath C:\Sysmon\$SysmonOutputFile -DestinationPath C:\Sysmon\

#Pulling Sysmon Config
Invoke-WebRequest $SysmonConfig -OutFile C:\Sysmon\$SysmonZip
Expand-Archive -LiteralPath C:\Sysmon\$SysmonZip -DestinationPath C:\Sysmon\
Move-Item C:\Sysmon\77fbb4d01887af8700b256a612094fe2-158478cacd3a20eca0845b6a4b9f463d9c6c75f1\sysmon.xml C:\Sysmon
Remove-Item C:\Sysmon\$SysmonOutputFile, C:\Sysmon\77fbb4d01887af8700b256a612094fe2-158478cacd3a20eca0845b6a4b9f463d9c6c75f1

Write-Host "Installing Sysmon.." -ForegroundColor Green
& cmd.exe /c 'C:\Sysmon\Sysmon64.exe -accepteula -i C:\Sysmon\sysmon.xml 2>&1' 

#Installing Splunk
Write-Host "Installing SplunkUF" -ForegroundColor Green

Invoke-WebRequest $SplunkUF -OutFile $env:HOMEDRIVE:\splunk_forwarder.msi

& cmd.exe /c msiexec.exe /i c:\splunk_forwarder.msi RECEIVING_INDEXER=$Splunk_IP":9997" LAUNCHSPLUNK=0 WINEVENTLOG_APP_ENABLE=1 WINEVENTLOG_SET_ENABLE=1 WINEVENTLOG_SEC_ENABLE=1 WINEVENTLOG_SYS_ENABLE=1 AGREETOLICENSE=Yes /quiet

Remove-Item 'C:\Program Files\SplunkUniversalForwarder\etc\apps\SplunkUniversalForwarder\local\inputs.conf'

Move-Item C:\Marvel-Lab\Logging\splunk\inputs.conf 'C:\Program Files\SplunkUniversalForwarder\etc\apps\SplunkUniversalForwarder\local\inputs.conf'

& cmd.exe /c 'C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe' start

}

do
 {
    Welcome_Banner
    Show-Menu
$selection = Read-Host "Please make a selection"
    switch ($selection)
    {
    '1' {
    Write-Host "You chose to only install Sysmon with no forwarding"
    Install-Sysmon
    } 
    '2' {
    Write-Host "You chose to install Sysmon + Winlogbeat which will forward Sysmon and Windows Events to HELK/ELK Instance"
    Install-Sysmon-HELK
    } 
    '3' {
    Write-Host "You chose to install Sysmon + Splunk UF which will forward Sysmon and Windows Events to Splunk"

    Install-Sysmon-Splunk
    }
    }
 }
 until ($selection -eq '1' -or '2' -or '3' )


