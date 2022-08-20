function Install-Logging {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $ProjectFilePath,

        [Parameter(Mandatory=$true)]
        [switch]
        [ValidateSet('Olaf-Hartong-Modular', 'Marvel-Lab-Research')]
        $SysmonConfigType, 

        [Parameter(Mandatory=$true)]
        [switch]
        [ValidateSet('Splunk', 'ELK')]
        $SIEM,

        [Parameter(Mandatory=$true)]
        [string]
        $SIEM_IP
)

    Write-Host "[*] Checking to see if Sysmon is installed on host"
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Checking to see if Sysmon is installed on host"
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
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Downloading Sysmon"
        Invoke-WebRequest $SysmonUrl -OutFile C:\Sysmon\Sysmon.zip
        Expand-Archive -LiteralPath C:\Sysmon\Sysmon.zip -DestinationPath C:\Sysmon\

        switch ($SysmonConfigType)
        {
            'Olaf-Hartong-Modular'
            {
                $SysmonConfig = "https://raw.githubusercontent.com/olafhartong/sysmon-modular/master/sysmonconfig.xml"
            }
            'Marvel-Lab-Research'
            {
                $SysmonConfig = "https://raw.githubusercontent.com/jsecurity101/Marvel-Lab/master/Logging/research-sysmon-config.xml"
            }
        }

        Write-Host "[*] You chose $SysmonConfigType. Installing and configuring now" -ForegroundColor Green
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] You chose $SysmonConfigType. Installing and configuring now" 
        Invoke-WebRequest $SysmonConfig -OutFile C:\Sysmon\$SysmonOutputFile

        Write-Host "[*] Installing Sysmon" -ForegroundColor Green
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Installing Sysmon"
        & cmd.exe /c 'C:\Sysmon\Sysmon64.exe -accepteula -i C:\Sysmon\sysmonconfig.xml -a ArchivedFiles 2>&1'  
    }

    Write-Host "[*] Setting up SIEM connection"
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Setting up SIEM connection"

    switch ($SIEM) {
        'Splunk'{
            Write-Host "[*] Checking to see if Splunk is installed on host"
            Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Checking to see if Splunk is installed on host"
            $s = [bool](Get-Service SplunkForwarder -ErrorAction SilentlyContinue)
        
            if ($s -eq $true) {
                Write-Warning "[*] Splunk is already installed" 
                Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Splunk is already installed" 
            }
            else {
                #Splunk Arugments:
                $SplunkUF = "https://download.splunk.com/products/universalforwarder/releases/8.2.6/windows/splunkforwarder-8.2.6-a6fe1ee8894b-x64-release.msi"

                #Installing Splunk
                Write-Host "[*] Installing SplunkUF" -ForegroundColor Green
                Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Installing SplunkUF"

                Invoke-WebRequest $SplunkUF -OutFile $env:HOMEDRIVE:\splunk_forwarder.msi

                & cmd.exe /c msiexec.exe /i c:\splunk_forwarder.msi RECEIVING_INDEXER=$SIEM_IP":9997" LAUNCHSPLUNK=0 WINEVENTLOG_APP_ENABLE=1 WINEVENTLOG_SET_ENABLE=1 WINEVENTLOG_SEC_ENABLE=1 WINEVENTLOG_SYS_ENABLE=1 AGREETOLICENSE=Yes /quiet

                Remove-Item 'C:\Program Files\SplunkUniversalForwarder\etc\apps\SplunkUniversalForwarder\local\inputs.conf'

                Copy-Item $ProjectFilePath\Logging\splunk\inputs.conf 'C:\Program Files\SplunkUniversalForwarder\etc\apps\SplunkUniversalForwarder\local\inputs.conf'

                & cmd.exe /c 'C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe' start

            }
        }
        'ELK' {
            Write-Host "[*] Checking to see if winlogbeat is installed on host"
            Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Checking to see if winlogbeat is installed on host"
            $winlogbeatservice = [bool](Get-Service winlogbeat -ErrorAction SilentlyContinue)
            if ($winlogbeatservice -eq $True)
            {
                Write-Warning "[*] Winlogbeat is installed already" 
                Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Winlogbeat is installed already" 
            }
            else {
                #Winlogbeat Arguments:
                $WinlogbeatVer = "7.13.0"
                $WinlogbeatUrl = "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-" + $WinlogbeatVer + "-windows-x86_64.zip"
                $WinlogbeatOutputFile = "winlogbeat.zip"
                $WinlogbeatConfig = "https://gist.github.com/jsecurity101/ec4c829e6d32a984d7ccf4c1e9247590/archive/8d85c6c443704e821a7f53e536be61667c67febd.zip"
                $WinlogZip = "winlogconfig.zip"
    
    
                Write-Host "[*] Creating winlogbeat path - C:\Winlogbeat" -ForegroundColor Green
                Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Creating winlogbeat path - C:\Winlogbeat"
                New-Item -Path "c:\" -Name "Winlogbeat" -ItemType "directory"
    
                Write-Host "[*] Installing Winlogbeat" -ForegroundColor Green
                Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Installing Winlogbeat"
                Invoke-WebRequest $WinlogbeatUrl -OutFile C:\Winlogbeat\$WinlogbeatOutputFile
                Expand-Archive -LiteralPath C:\Winlogbeat\$WinlogbeatOutputFile -DestinationPath C:\Winlogbeat\
    
                Invoke-WebRequest $WinlogbeatConfig -OutFile C:\Winlogbeat\$WinlogZip
                Expand-Archive -LiteralPath C:\Winlogbeat\$WinlogZip -DestinationPath C:\Winlogbeat\
    
                Remove-Item C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\winlogbeat.yml
                Move-Item C:\Winlogbeat\ec4c829e6d32a984d7ccf4c1e9247590-8d85c6c443704e821a7f53e536be61667c67febd\winlogbeat.yml C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\
                Remove-Item C:\Winlogbeat\$WinlogZip, C:\Winlogbeat\ec4c829e6d32a984d7ccf4c1e9247590-8d85c6c443704e821a7f53e536be61667c67febd
    
                (Get-Content C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\winlogbeat.yml).replace('<HELK-IP>', $SIEM_IP) | Set-Content C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\winlogbeat.yml
    
                Remove-Item C:\Winlogbeat\$WinlogbeatOutputFile 
    
                & C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\install-service-winlogbeat.ps1 
    
                Start-Service winlogbeat
            }
        }
    }
}

function Uninstall-Logging {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $ProjectFilePath,

        [Parameter(Mandatory=$true)]
        [switch]
        [ValidateSet('Splunk', 'ELK')]
        $SIEM
    )

    $sysmon = [bool](Get-Service Sysmon* -ErrorAction SilentlyContinue)
    if ($sysmon -eq $false) {
        Write-Host "[*] Sysmon is not installed" -ForegroundColor Green
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Sysmon is not installed"
    }
    else {
        Write-Host "[*] Uninstalling Sysmon and removing its folders"
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Uninstalling Sysmon and removing its folders"
        C:\Sysmon\Sysmon64.exe -u
        Remove-Item "C:\Sysmon\" -Recurse -Force
        }

    switch ($SIEM) {
        'Splunk'{
            Write-Host "[*] Checking to see if Splunk is installed on host"
            Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Checking to see if Splunk is installed on host"
            $s = [bool](Get-Service SplunkForwarder -ErrorAction SilentlyContinue)
        
            if ($s -eq $false) {
                Write-Host "[*] Splunk is not installed" -ForegroundColor Green
                Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Splunk is not installed"
            }
            else {
                Write-Host "[*] Uninstalling Splunk and removing its folders"
                Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Uninstalling Splunk and removing its folders"
                Stop-Service SplunkForwarder
                $UniversalForwarder = Get-WmiObject -Class Win32_Product | Where-Object{$_.Name -eq "UniversalForwarder"}
                $UniversalForwarder.Uninstall()
                Remove-Item "C:\splunk_forwarder.msi"
            }
        }
        'ELK' {
            Write-Host "[*] Checking to see if winlogbeat is installed"
            Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Checking to see if winlogbeat is installed"
            $winlog = [bool](Get-Service winlogbeat -ErrorAction SilentlyContinue)
            if ($winlog -eq $false) {
                Write-Host "[*] Winlogbeat is not installed" -ForegroundColor Green
            }
            else {
                Write-Host "[*] Uninstalling Winlogbeat and removing its folders"
                Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Uninstalling Winlogbeat and removing its folders"
                Stop-Service winlogbeat
                Remove-Item "C:\Winlogbeat\" -Recurse -Force
            }
        }
    }
}