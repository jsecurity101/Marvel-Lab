function Install-Logging {

    <#
    .SYNOPSIS
    Installs looging tools.

    .DESCRIPTION
    Install-Logging installs logging tools and the respective programs needed to forward logs to a SIEM.

    .PARAMETER ProjectFilePath
    Path of the Marvel-Lab directory.

    .PARAMETER SysmonConfigType
    A string value to represent which sysmon config they want to use.

    .PARAMETER SIEM_IP
    IP address of the SIEM.

    .PARAMETER ELK_Cert_Path
    File path of the ELK cert file.
     
    .PARAMETER ELK
    Switch statement to specify that the user is wanting to use ELK as their SIEM.
    
    .EXAMPLE
    Install-Logging -SIEM_IP 127.0.0.1
    
    .EXAMPLE
    Install-Logging -SIEM_IP 127.0.0.1 -ELK -ELK_Cert_Path C:\elk.crt -SysmonConfigType Olaf-Hartong-Modular
    #>

    [CmdletBinding(DefaultParameterSetName = 'Splunk')]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $ProjectFilePath,

        [Parameter(ParameterSetName = 'ELK')]
        [Parameter(ParameterSetName = 'Splunk')]
        [string]
        [ValidateSet('Olaf-Hartong-Modular', 'Marvel-Lab-Research')]
        $SysmonConfigType = 'Marvel-Lab-Research', 

        [Parameter(Mandatory, ParameterSetName = 'ELK')]
        [switch]
        $ELK,

        [Parameter(ParameterSetName = 'ELK')]
        [Parameter(ParameterSetName = 'Splunk')]
        [Parameter(Mandatory=$true)]
        [string]
        $SIEM_IP, 

        [Parameter(Mandatory, ParameterSetName = 'ELK')]
        [string]
        $ELK_Cert_Path
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
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] $SysmonUrlDownloading Sysmon"
        (New-Object System.Net.WebClient).DownloadFile($SysmonUrl, 'C:\Sysmon\Sysmon.zip')
        #Invoke-WebRequest $SysmonUrl -OutFile C:\Sysmon\Sysmon.zip
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

    switch ($PSCmdlet.ParameterSetName) {
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
                $WinlogbeatVer = "8.3.3"
                $WinlogbeatUrl = "https://artifacts.elastic.co/downloads/beats/winlogbeat/winlogbeat-" + $WinlogbeatVer + "-windows-x86_64.zip"
                $WinlogbeatConfig = "https://gist.github.com/jsecurity101/ec4c829e6d32a984d7ccf4c1e9247590/archive/a880c8c34a398d36c9a8a4f85b3a0f204606a2d2.zip"
    
    
                Write-Host "[*] Creating winlogbeat path - C:\Winlogbeat" -ForegroundColor Green
                Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Creating winlogbeat path - C:\Winlogbeat"
                New-Item -Path "c:\" -Name "Winlogbeat" -ItemType "directory"
    
                Write-Host "[*] Installing Winlogbeat" -ForegroundColor Green
                Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Installing Winlogbeat"
                
                (New-Object System.Net.WebClient).DownloadFile($WinlogbeatUrl, 'C:\Winlogbeat\winlogbeat.zip')
                #Invoke-WebRequest $WinlogbeatUrl -OutFile C:\Winlogbeat\$WinlogbeatOutputFile
                Expand-Archive -LiteralPath C:\Winlogbeat\winlogbeat.zip -DestinationPath C:\Winlogbeat\
    
                (New-Object System.Net.WebClient).DownloadFile($WinlogbeatConfig, 'C:\Winlogbeat\winlogconfig.zip')
                #Invoke-WebRequest $WinlogbeatConfig -OutFile C:\Winlogbeat\$WinlogZip
                Expand-Archive -LiteralPath C:\Winlogbeat\winlogconfig.zip -DestinationPath C:\Winlogbeat\
    
                Remove-Item C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\winlogbeat.yml
                Move-Item C:\Winlogbeat\ec4c829e6d32a984d7ccf4c1e9247590-a880c8c34a398d36c9a8a4f85b3a0f204606a2d2\winlogbeat.yml C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\
                Remove-Item 'C:\Winlogbeat\winlogconfig.zip', C:\Winlogbeat\ec4c829e6d32a984d7ccf4c1e9247590-a880c8c34a398d36c9a8a4f85b3a0f204606a2d2

                $ELKCertPath = $ELK_Cert_Path.Replace('\', '\\')
    
                (Get-Content C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\winlogbeat.yml).replace('<ELK-IP>', $SIEM_IP) | Set-Content C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\winlogbeat.yml
                (Get-Content C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\winlogbeat.yml).replace('<ELK_Cert_Path>', $ELKCertPath) | Set-Content C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\winlogbeat.yml
    
                Remove-Item 'C:\Winlogbeat\winlogbeat.zip'
    
                & C:\Winlogbeat\winlogbeat-$WinlogbeatVer-windows-x86_64\install-service-winlogbeat.ps1 
    
                Start-Service winlogbeat
            }
        }
    }
}

function Uninstall-Logging {

<#
    .SYNOPSIS
    Uninstalls looging tools.

    .DESCRIPTION
    Uninstall-Logging installs logging tools and the respective programs needed to forward logs to a SIEM.

    .PARAMETER ProjectFilePath
    Path of the Marvel-Lab directory.

    .PARAMETER SIEM
    A string value to represent which SIEM (ELK/Splunk) they are using.
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $ProjectFilePath,

        [Parameter(Mandatory=$true)]
        [string]
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
                Stop-Service -Name SplunkForwarder -Force
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
                & C:\Winlogbeat\winlogbeat-8.3.3-windows-x86_64\uninstall-service-winlogbeat.ps1 
                Remove-Item "C:\Winlogbeat\" -Recurse -Force
            }
        }
    }
}