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

# Disable download progress bar to improve download speed
$ProgressPreference = 'SilentlyContinue'

#Sysmon Arguments:
$SysmonUrl = "https://download.sysinternals.com/files/Sysmon.zip"
$SysmonOutputFile = "sysmonconfig.xml"


#Winlogbeat Arguments:
$WinlogbeatVer = "7.13.0"
$WinlogbeatUrl = "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-" + $WinlogbeatVer + "-windows-x86_64.zip"
$WinlogbeatOutputFile = "winlogbeat.zip"
$WinlogbeatConfig = "https://gist.github.com/jsecurity101/ec4c829e6d32a984d7ccf4c1e9247590/archive/8d85c6c443704e821a7f53e536be61667c67febd.zip"
$WinlogZip = "winlogconfig.zip"

#Splunk Arugments:
$SplunkUF = "https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=windows&version=8.2.0&product=universalforwarder&filename=splunkforwarder-8.2.0-e053ef3c985f-x64-release.msi&wget=true"

#OSQuery Arguments:
$KolideLauncher = "https://github.com/kolide/launcher/releases/download/v0.11.19/windows.amd64_v0.11.19.zip"
$FleetFolderName = "windows.amd64_v0.11.19"

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
Invoke-WebRequest $SysmonUrl -OutFile C:\Sysmon\Sysmon.zip
Expand-Archive -LiteralPath C:\Sysmon\Sysmon.zip -DestinationPath C:\Sysmon\

#Pulling Sysmon Config

$configtype = Read-Host "Would you like to install a modular config for Sysmon (by Olaf) or a research config that is less restricted? Choose: modular OR research"

if ($configtype -eq 'research') 
{
$SysmonConfig = "https://raw.githubusercontent.com/jsecurity101/Marvel-Lab/master/Logging/research-sysmon-config.xml"
}
if ($configtype -eq 'modular') 
{
$SysmonConfig = "https://raw.githubusercontent.com/olafhartong/sysmon-modular/master/sysmonconfig.xml"
}
else
{
Write-Host "Invalid selection"
}
Invoke-WebRequest $SysmonConfig -OutFile C:\Sysmon\$SysmonOutputFile



Write-Host "Installing Sysmon.." -ForegroundColor Green
& cmd.exe /c 'C:\Sysmon\Sysmon64.exe -accepteula -i C:\Sysmon\sysmonconfig.xml -a ArchivedFiles 2>&1'  
}

function Install-Winlogbeat {
$HELK_IP = Read-Host "Please input the IP of your HELK/ELK box" 

#Downloading and Installing Winlogbeat
New-Item -Path "c:\" -Name "Winlogbeat" -ItemType "directory"

Invoke-WebRequest $WinlogbeatUrl -OutFile C:\Winlogbeat\$WinlogbeatOutputFile
Expand-Archive -LiteralPath C:\Winlogbeat\$WinlogbeatOutputFile -DestinationPath C:\Winlogbeat\

Invoke-WebRequest $WinlogbeatConfig -OutFile C:\Winlogbeat\$WinlogZip
Expand-Archive -LiteralPath C:\Winlogbeat\$WinlogZip -DestinationPath C:\Winlogbeat\

Remove-Item C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\winlogbeat.yml
Move-Item C:\Winlogbeat\ec4c829e6d32a984d7ccf4c1e9247590-8d85c6c443704e821a7f53e536be61667c67febd\winlogbeat.yml C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\
Remove-Item C:\Winlogbeat\$WinlogZip, C:\Winlogbeat\ec4c829e6d32a984d7ccf4c1e9247590-8d85c6c443704e821a7f53e536be61667c67febd

(Get-Content C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\winlogbeat.yml).replace('<HELK-IP>', $HELK_IP) | Set-Content C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\winlogbeat.yml

Remove-Item C:\Winlogbeat\$WinlogbeatOutputFile 

& C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\install-service-winlogbeat.ps1 

Start-Service winlogbeat
}

function Install-OSQuery {
    Write-Host "Installing Chocolatey" -ForegroundColor Green
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    choco install osquery -y
    refreshenv
}

function Install-Fleet {
    New-Item -Path "c:\" -Name "OSQuery" -ItemType "directory"
    $OSQuery_IP = Read-Host "Please Input the IP and port number of the Kolide Server" 
    $Enroll_Secret = Read-Host "Go to https://"$OSQuery_IP":8443, click on 'Add New Host', copy the Enroll Secret and paste here"
   
    Invoke-WebRequest $KolideLauncher -OutFile 'C:\OSQuery\kolidelauncher.zip'
    Expand-Archive -LiteralPath C:\OSquery\kolidelauncher.zip -DestinationPath C:\OSquery\
    New-Service -Name "kolide_launcher" -BinaryPathName "C:\OSQuery\$FleetFolderName\launcher.exe --hostname=$OSQuery_IP`:8443 --enroll_secret=$Enroll_Secret --insecure"
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
    Install-Fleet
    Install-Splunk
    }
    }
 }
 until ($selection -eq '1' -or '2' -or '3' )

}
