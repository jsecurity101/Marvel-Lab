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
    Write-Host "3: Press '3' for Sysmon + Splunk UF which will forward Sysmon/Windows Events to Splunk."
    Write-Host "4: Press '4' for Sysmon + OSQuery + Splunk UF which will forward Sysmon/Windows Events/OSQuery to Splunk."
    Write-Host "5: Press '5' to remove all logging components (sensors and forwarders)."

}

# Disable download progress bar to improve download speed
$ProgressPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 

Write-Host "[*] Checking for elevated permissions..." -ForegroundColor Green

$id = [System.Security.Principal.WindowsIdentity]::GetCurrent()

$principal = New-Object System.Security.Principal.WindowsPrincipal($id)

if (!$principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))
    {
        Write-Warning "[*] You do not have the correct permissions to run this script. Please re-run as Administrator" -ErrorAction Stop
            
    }
else {

    function Install-Sysmon {
    Write-Host "[*] Checking to see if Sysmon is installed on host..."
    $sysmonservice = [bool](Get-Service Sysmon* -ErrorAction SilentlyContinue)
    if ($sysmonservice -eq $true){
        Write-Warning "[*] Sysmon is installed already" 
    }
    else {
        #Sysmon Arguments:
        $SysmonUrl = "https://download.sysinternals.com/files/Sysmon.zip"
        $SysmonOutputFile = "sysmonconfig.xml"

        New-Item -Path "c:\" -Name "Sysmon" -ItemType "directory"

        Write-Host "[*] Downloading Sysmon" -ForegroundColor Green
        Invoke-WebRequest $SysmonUrl -OutFile C:\Sysmon\Sysmon.zip
        Expand-Archive -LiteralPath C:\Sysmon\Sysmon.zip -DestinationPath C:\Sysmon\

        $configtype = Read-Host "Would you like to install a modular config for Sysmon (by Olaf) or a research config that is less restricted? Choose: modular OR research" 

        switch ( $configtype )
        {
            'modular'
            {
                $SysmonConfig = "https://raw.githubusercontent.com/olafhartong/sysmon-modular/master/sysmonconfig.xml"
            }
            'research'
            {
                $SysmonConfig = "https://raw.githubusercontent.com/jsecurity101/Marvel-Lab/master/Logging/research-sysmon-config.xml"
            }
            default
            {
                Write-Host "Invalid selection"
            }
        }

        Write-Host "[*] You chose $configtype. Installing now configuration now..." -ForegroundColor Green
        Invoke-WebRequest $SysmonConfig -OutFile C:\Sysmon\$SysmonOutputFile

        Write-Host "Installing Sysmon.." -ForegroundColor Green
        & cmd.exe /c 'C:\Sysmon\Sysmon64.exe -accepteula -i C:\Sysmon\sysmonconfig.xml -a ArchivedFiles 2>&1'  
    }

}

    function Install-Winlogbeat {

        Write-Host "[*] Checking to see if winlogbeat is installed on host..."
        $winlogbeatservice = [bool](Get-Service winlogbeat -ErrorAction SilentlyContinue)
        if ($winlogbeatservice -eq $True)
        {
            Write-Warning "[*] Winlogbeat is installed already" 
        }
        else {
            #Winlogbeat Arguments:
            $WinlogbeatVer = "7.13.0"
            $WinlogbeatUrl = "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-" + $WinlogbeatVer + "-windows-x86_64.zip"
            $WinlogbeatOutputFile = "winlogbeat.zip"
            $WinlogbeatConfig = "https://gist.github.com/jsecurity101/ec4c829e6d32a984d7ccf4c1e9247590/archive/8d85c6c443704e821a7f53e536be61667c67febd.zip"
            $WinlogZip = "winlogconfig.zip"

            $HELK_IP = Read-Host "Please input the IP of your HELK/ELK box" 

            Write-Host "[*] Creating winlogbeat path - C:\Winlogbeat" -ForegroundColor Green
            New-Item -Path "c:\" -Name "Winlogbeat" -ItemType "directory"

            Write-Host "[*] Installing Winlogbeat" -ForegroundColor Green
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
    
    }

    function Install-OSQuery {
        Write-Host "[*] Checking to see if chocolatey is installed on host..."
        $c = [bool](Get-Command -Name choco.exe -ErrorAction SilentlyContinue)
        if ($c -eq $true) {
            Write-Warning "[*] Chocolatey is already installed" 
        }
        else {
            Write-Host "Installing Chocolatey" -ForegroundColor Green
            Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
         }

        Write-Host "[*] Checking to see if Osquery is installed on host..."
        $o = [bool](Get-Command osqueryd.exe -ErrorAction SilentlyContinue)
        if ($o -eq $true) {
            Write-Warning "[*] Osquery is already installed" 
            }
        else {
            choco install osquery -y
            }
        }

    function Install-Fleet {
        Write-Host "[*] Checking to see if Fleet is installed on host..."
        $f = [bool](Get-Service kolide_launcher -ErrorAction SilentlyContinue)

        if ($f -eq $true) {
            Write-Warning "[*] Fleet is already installed" 
        }
        else {
            #OSQuery Arguments:
            $KolideLauncher = "https://github.com/kolide/launcher/releases/download/v0.11.19/windows.amd64_v0.11.19.zip"
            $FleetFolderName = "windows.amd64_v0.11.19"
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

    }

    function Install-Splunk {
        Write-Host "[*] Checking to see if Splunk is installed on host..."
        $s = [bool](Get-Service SplunkForwarder -ErrorAction SilentlyContinue)
    
        if ($s -eq $true) {
            Write-Warning "[*] Splunk is already installed" 
        }
        else {
            #Splunk Arugments:
            $SplunkUF = "https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=windows&version=8.2.0&product=universalforwarder&filename=splunkforwarder-8.2.0-e053ef3c985f-x64-release.msi&wget=true"
            $Splunk_IP = Read-Host "Please input the IP of your Splunk box"

            #Installing Splunk
            Write-Host "Installing SplunkUF" -ForegroundColor Green

            Invoke-WebRequest $SplunkUF -OutFile $env:HOMEDRIVE:\splunk_forwarder.msi

            & cmd.exe /c msiexec.exe /i c:\splunk_forwarder.msi RECEIVING_INDEXER=$Splunk_IP":9997" LAUNCHSPLUNK=0 WINEVENTLOG_APP_ENABLE=1 WINEVENTLOG_SET_ENABLE=1 WINEVENTLOG_SEC_ENABLE=1 WINEVENTLOG_SYS_ENABLE=1 AGREETOLICENSE=Yes /quiet

            Remove-Item 'C:\Program Files\SplunkUniversalForwarder\etc\apps\SplunkUniversalForwarder\local\inputs.conf'

            Copy-Item C:\Marvel-Lab\Logging\splunk\inputs.conf 'C:\Program Files\SplunkUniversalForwarder\etc\apps\SplunkUniversalForwarder\local\inputs.conf'

            & cmd.exe /c 'C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe' start

        }
    
    }

    function Remove-Logging {
        Write-Host "[*] Checking to see if Splunk is installed on host..."
        $s = [bool](Get-Service SplunkForwarder -ErrorAction SilentlyContinue)
    
        if ($s -eq $false) {
            Write-Host "[*] Splunk is not installed" -ForegroundColor Green
        }
        else {
            Write-Host "[*] Uninstalling Splunk and removing its folders.."
            Stop-Service SplunkForwarder
            $UniversalForwarder = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "UniversalForwarder"}
            $UniversalForwarder.Uninstall()
            Remove-Item "C:\splunk_forwarder.msi"
            }

        Write-Host "[*] Checking to see if Sysmon is installed on host..."
        $sysmon = [bool](Get-Service Sysmon* -ErrorAction SilentlyContinue)
        if ($sysmon -eq $false) {
            Write-Host "[*] Sysmon is not installed" -ForegroundColor Green
        }
        else {
            Write-Host "[*] Uninstalling Sysmon and removing its folders.."
            C:\Sysmon\Sysmon64.exe -u
            Remove-Item "C:\Sysmon\" -Recurse -Force
            }

        Write-Host "[*] Checking to see if winlogbeat is installed..."
        $winlog = [bool](Get-Service winlogbeat -ErrorAction SilentlyContinue)
        if ($winlog -eq $false) {
            Write-Host "[*] Winlogbeat is not installed" -ForegroundColor Green
        }
        else {
            Write-Host "[*] Uninstalling Winlogbeat and removing its folders.."
            Stop-Service winlogbeat
            Remove-Item "C:\Winlogbeat\" -Recurse -Force
            }

        Write-Host "[*] Checking to see if kolide is installed..."
        $kolide = [bool](Get-Service kolide_launcher -ErrorAction SilentlyContinue)
        if ($kolide -eq $false) {
            Write-Host "[*] Kolide is not installed" -ForegroundColor Green
        }
        else {
            Write-Host "[*] Uninstalling kolide and removing its folders.."
            Stop-Service kolide_launcher
            sc.exe delete kolide_launcher
            $path = Test-Path C:\Osquery\
            if ($path -eq $false) {
                Write-Host "Osuqery is note installed"
                }
            else{
            Remove-Item "C:\Osquery\" -Recurse -Force
                }
            }

         Write-Host "[*] Checking to see if Osquery is installed..."
        $o = [bool](Get-Command osqueryd.exe -ErrorAction SilentlyContinue)
        if ($o -eq $false) {
            Write-Host "[*] Osquery is not installed" -ForegroundColor Green
        }
        else {
            Write-Host "[*] Uninstalling kolide and removing its folders.."
            choco uninstall osquery -y
            }
    }

    do {
        Welcome_Banner
        Show-Menu
        $selection = Read-Host "Please make a selection"

        switch ($selection) {
        '1' {
            Write-Host "[*] You chose to only install Sysmon with no forwarding" -ForegroundColor Blue
            Install-Sysmon
        } 
        '2' {
            Write-Host "[*] You chose to install Sysmon + Winlogbeat which will forward Sysmon and Windows Events to HELK/ELK Instance" -ForegroundColor Blue
            Install-Sysmon
            Install-Winlogbeat
        } 
        '3' {
            Write-Host "[*] You chose to install Sysmon + Splunk UF which will forward Sysmon/Windows Events to Splunk" -ForegroundColor Blue
            Install-Sysmon
            Install-Splunk
        }
        '4' {
            Write-Host "[*] You chose to install Sysmon + OSQuery + Splunk UF which will forward Sysmon/Windows Events/OSQuery to Splunk" -ForegroundColor Blue
            Install-Sysmon
            Install-OSQuery
            Install-Fleet
            Install-Splunk
            }
        '5' {
            Write-Host "[*] You chose to remove all logging components (sensors and forwarders)" -ForegroundColor Blue
            Remove-Logging
            }
        }
        }
        until ($selection -eq '1' -or '2' -or '3' -or '4')
        
    }
   