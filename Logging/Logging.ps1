#Author Jonathan Johnson

#References:https://powershellexplained.com/2016-10-21-powershell-installing-msi-files/ && https://docs.splunk.com/Documentation/Splunk/8.0.3/Installation/InstallonWindowsviathecommandline

using namespace System.Management.Automation.Host

function Show-Menu {
    [CmdletBinding()]
    param (
        [string]$Question = 'Which logging option would you like?'
    )

    Clear-Host
    Write-Host "
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
    Write-Host "3: Press '3' for Sysmon + OSQuery + Splunk UF which will forward Sysmon/Windows Events/OSQuery to Splunk."

}

#Sysmon Arguments:
$SysmonUrl = "https://download.sysinternals.com/files/Sysmon.zip"
$SysmonOutputFile = "Sysmon.zip"
$SysmonConfig = "https://gist.github.com/jsecurity101/77fbb4d01887af8700b256a612094fe2/archive/b7e99bf91d075862de3bc0668fd71a6ad7f19f17.zip"

#Winlogbeat Arguments:
$WinlogbeatUrl = "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-7.5.2-windows-x86_64.zip"
$WinlogbeatOutputFile = "winlogbeat.zip"
$WinlogbeatConfig = "https://gist.github.com/jsecurity101/ec4c829e6d32a984d7ccf4c1e9247590/archive/8d85c6c443704e821a7f53e536be61667c67febd.zip"
$WinlogZip = "winlogconfig.zip"

#Splunk Arugments:
$SplunkUF = "https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=windows&version=8.0.3&product=universalforwarder&filename=splunkforwarder-8.0.3-a6754d8441bf-x64-release.msi&wget=true"

#OSQuery Arguments
$KolideLauncher = "https://github.com/kolide/launcher/releases/download/v0.11.9/launcher_v0.11.9.zip"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 

Write-Host "Checking for elevated permissions..."
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
[Security.Principal.WindowsBuiltInRole] "Administrator")) {
Write-Warning "You need to run this script as an Administrator. Please open up new window as Administrator."
Break
}
else {
function Install-Sysmon {
New-Item -Path "c:\" -Name "Sysmon" -ItemType "directory"

#Downloading and Installing Sysmon 
Invoke-WebRequest $SysmonUrl -OutFile C:\Sysmon\$SysmonOutputFile
Expand-Archive -LiteralPath C:\Sysmon\$SysmonOutputFile -DestinationPath C:\Sysmon\

#Pulling Sysmon Config
Invoke-WebRequest $SysmonConfig -OutFile C:\Sysmon\$SysmonOutputFile
Expand-Archive -LiteralPath C:\Sysmon\$SysmonOutputFile -DestinationPath C:\Sysmon\
Move-Item C:\Sysmon\77fbb4d01887af8700b256a612094fe2-b7e99bf91d075862de3bc0668fd71a6ad7f19f17\sysmon.xml C:\Sysmon
Remove-Item C:\Sysmon\$SysmonOutputFile, C:\Sysmon\77fbb4d01887af8700b256a612094fe2-b7e99bf91d075862de3bc0668fd71a6ad7f19f17

Write-Host "Installing Sysmon.." -ForegroundColor Green
& cmd.exe /c 'C:\Sysmon\Sysmon64.exe -accepteula -i C:\Sysmon\sysmon.xml -a ArchivedFiles 2>&1'  
}

function Install-Winlogbeat {
$HELK_IP = Read-Host "Please input the IP of your HELK/ELK box" 

#Downloading and Installing Winlogbeat
New-Item -Path "c:\" -Name "Winlogbeat" -ItemType "directory"

Invoke-WebRequest $WinlogbeatUrl -OutFile C:\Winlogbeat\$WinlogbeatOutputFile
Expand-Archive -LiteralPath C:\Winlogbeat\$WinlogbeatOutputFile -DestinationPath C:\Winlogbeat\

Invoke-WebRequest $WinlogbeatConfig -OutFile C:\Winlogbeat\$WinlogZip
Expand-Archive -LiteralPath C:\Winlogbeat\$WinlogZip -DestinationPath C:\Winlogbeat\

Remove-Item C:\Winlogbeat\winlogbeat-7.5.2-windows-x86_64\winlogbeat.yml
Move-Item C:\Winlogbeat\ec4c829e6d32a984d7ccf4c1e9247590-8d85c6c443704e821a7f53e536be61667c67febd\winlogbeat.yml C:\Winlogbeat\winlogbeat-7.5.2-windows-x86_64\
Remove-Item C:\Winlogbeat\$WinlogZip, C:\Winlogbeat\ec4c829e6d32a984d7ccf4c1e9247590-8d85c6c443704e821a7f53e536be61667c67febd

(Get-Content C:\Winlogbeat\winlogbeat-7.5.2-windows-x86_64\winlogbeat.yml).replace('<HELK-IP>', $HELK_IP) | Set-Content C:\Winlogbeat\winlogbeat-7.5.2-windows-x86_64\winlogbeat.yml

Remove-Item C:\Winlogbeat\$WinlogbeatOutputFile 

C:\Winlogbeat\winlogbeat-7.5.2-windows-x86_64\install-service-winlogbeat.ps1 

Start-Service winlogbeat
}

function Install-OSQuery {
    New-Item -Path "c:\" -Name "OSQuery" -ItemType "directory"
    $OSQuery_IP = Read-Host "Please Input the IP and port number of the Kolide Server" 
    $Enroll_Secret = Read-Host "Go to https://"$OSQuery_IP":8443, click on 'Add New Host', copy the Enroll Secret and paste here"
   
    Invoke-WebRequest $KolideLauncher -OutFile 'C:\OSQuery\kolidelauncher.zip'
    Expand-Archive -LiteralPath C:\OSquery\kolidelauncher.zip -DestinationPath C:\OSquery\

    ((Get-Content -path "C:\Marvel-Lab\Logging\Kolide_Launcher_Service.ps1") -replace 'OSQuery_IP', $OSQuery_IP -replace 'KolideSecret', $Enroll_Secret) | Set-Content -Path "C:\Marvel-Lab\Logging\Kolide_Launcher_Service.ps1"
    & powershell C:\Marvel-Lab\Logging\Kolide_Launcher_Service.ps1
    sc.exe start kolide_launcher 
    Remove-Item C:\OSQuery\kolidelauncher.zip
    Write-Host "OSQuery logs are now available in Kolide Fleet" -ForegroundColor Green
}


function Install-Splunk {
$Splunk_IP = Read-Host "Please input the IP of your Splunk box"

#Installing Splunk
Write-Host "Installing SplunkUF" -ForegroundColor Green

Invoke-WebRequest $SplunkUF -OutFile $env:HOMEDRIVE:\splunk_forwarder.msi

& cmd.exe /c msiexec.exe /i c:\splunk_forwarder.msi RECEIVING_INDEXER=$Splunk_IP":9997" LAUNCHSPLUNK=0 WINEVENTLOG_APP_ENABLE=1 WINEVENTLOG_SET_ENABLE=1 WINEVENTLOG_SEC_ENABLE=1 WINEVENTLOG_SYS_ENABLE=1 AGREETOLICENSE=Yes /quiet

Remove-Item 'C:\Program Files\SplunkUniversalForwarder\etc\apps\SplunkUniversalForwarder\local\inputs.conf'

Copy-Item C:\Marvel-Lab\Logging\splunk\inputs.conf 'C:\Program Files\SplunkUniversalForwarder\etc\apps\SplunkUniversalForwarder\local\inputs.conf'

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
    Install-Sysmon
    Install-Winlogbeat
    } 
    '3' {
    Write-Host "You chose to install Sysmon + OSQuery + Splunk UF which will forward Sysmon/Windows Events/OSQuery to Splunk"
    Install-Sysmon
    Install-OSQuery
    Install-Splunk
    }
    }
 }
 until ($selection -eq '1' -or '2' -or '3' )

}