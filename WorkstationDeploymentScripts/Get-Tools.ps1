function Get-Tools {
    [CmdletBinding(DefaultParameterSetName = 'Full')]
    param (
        [string]
        $FolderPath = 'C:\',

        [string]
        $DirectoryName = 'Tools',

        [Parameter(Mandatory, ParameterSetName = 'Blue')]
        [Switch]
        $Blue,

        [Parameter(Mandatory, ParameterSetName = 'Red')]
        [Switch]
        $Red,

        [switch]
        $Automate

    )

    New-Item -Path $FolderPath -Name $DirectoryName -ItemType "directory"

    switch ($PSCmdlet.ParameterSetName) {
        'Full'{
             Write-Host "Installing Chocolatey" -ForegroundColor Green
            Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
            
            Write-Host "Installing Chrome" -ForegroundColor Green
            choco install googlechrome -y
            
            Write-Host "Installing Git" -ForegroundColor Green
            choco install git.install -y
            $env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
            Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
            refreshenv 
            refreshenv 

            #Wireshark:
            choco install -y --limit-output --no-progress wireshark winpcap #command borrowed from - https://github.com/clong/DetectionLab/blob/6525456492bc311c3ae061adb854691f424e4ba7/Vagrant/scripts/install-choco-extras.ps1#L13

            New-Item -Path $FolderPath\$DirectoryName -Name "Red" -ItemType "directory"

            #Powersploit:
            $Powersploit = "https://github.com/PowerShellMafia/PowerSploit/archive/dev.zip"
            Invoke-WebRequest $Powersploit -OutFile "$FolderPath\$DirectoryName\Red\PowerSploit.zip"

            #Rubeus:
            git clone https://github.com/GhostPack/Rubeus.git $FolderPath\$DirectoryName\Red\Rubeus

            #Powershell Arsenal:
            git clone https://github.com/mattifestation/PowerShellArsenal.git $FolderPath\$DirectoryName\Red\PowershellArsenal

            #Seatbelt: 
            git clone https://github.com/GhostPack/Seatbelt.git $FolderPath\$DirectoryName\Red\Seatbelt

            #AtomicRedTeam: 
            git clone https://github.com/redcanaryco/atomic-red-team.git $FolderPath\$DirectoryName\Red\AtomicRedTeam

            #AtomicTestHarnesses: 
            git clone https://github.com/redcanaryco/AtomicTestHarnesses.git $FolderPath\$DirectoryName\Red\AtomicTestHarnesses

            #Mimikatz:
            $release = (Invoke-WebRequest "https://api.github.com/repos/gentilkiwi/mimikatz/releases" -UseBasicParsing | ConvertFrom-Json)[0].tag_name #Line taken from: https://github.com/clong/DetectionLab/blob/eabe0fa90c7d0a85b18e0f7557b00d5ca055d646/Vagrant/scripts/install-redteam.ps1#L36
            $mimikatz = "https://github.com/gentilkiwi/mimikatz/releases/download/$release/mimikatz_trunk.zip"
            Invoke-WebRequest $mimikatz -OutFile "$FolderPath\$DirectoryName\Red\Mimikatz.zip"

            New-Item -Path $FolderPath\$DirectoryName -Name "Blue" -ItemType "directory"

            #Sysinternals:
            $Sysinternals = "https://download.sysinternals.com/files/SysinternalsSuite.zip"
            Invoke-WebRequest $Sysinternals -OutFile "C:\Tools\Blue\Sysinternals.zip"

            New-Item -Path $FolderPath\$DirectoryName -Name "APIMonitor" -ItemType "directory"
            New-Item -Path $FolderPath\$DirectoryName -Name "IDAPro" -ItemType "directory"

            # Downloads -
            # API Monitoring: 
            $APIMonitorx64 = "http://www.rohitab.com/download/api-monitor-v2r13-setup-x64.exe"
            $APIMonitorx86 = "http://www.rohitab.com/download/api-monitor-v2r13-setup-x86.exe"

            #DnSpy:
            $version = (Invoke-WebRequest "https://api.github.com/repos/dnspy/dnspy/releases" -UseBasicParsing | ConvertFrom-Json)[0].tag_name
            $Dnspy = "https://github.com/dnSpy/dnSpy/releases/download/$version/dnSpy-net-win64.zip"

            #IDAPro: 
            $IDAPro = "https://out7.hex-rays.com/files/idafree70_windows.exe"

            #Windows 10 SDK:
            $WindowsSDK = "https://go.microsoft.com/fwlink/p/?linkid=2083338&clcid=0x409"

            if ((gwmi win32_operatingsystem | select osarchitecture).osarchitecture -eq "64-bit")
            {
                Write "You have a 64-bit system"
                Invoke-WebRequest $APIMonitorx64 -OutFile "$FolderPath\$DirectoryName\APIMonitor\api-monitor.exe"
                Invoke-WebRequest $Dnspy -OutFile "$FolderPath\$DirectoryName\dnspy-net.zip"
                Invoke-WebRequest $WindowsSDK -OutFile "C:\winsdksetup.exe"
                Invoke-WebRequest $IDAPro -OutFile "$FolderPath\$DirectoryName\IDAPro\IDAPro.exe"
            }
            else
            {
                Write "You have a 32-bit system"
                Invoke-WebRequest $APIMonitorx86 -OutFile "$FolderPath\$DirectoryName\APIMonitor\api-monitor.exe"
                Invoke-WebRequest $Dnspy -OutFile "$FolderPath\$DirectoryName\dnspy-net.zip"
                Invoke-WebRequest $WindowsSDK -OutFile "C:\winsdksetup.exe"
                Invoke-WebRequest $IDAPro -OutFile "$FolderPath\$DirectoryName\IDAPro\IDAPro.exe"

            }

            #Install Windows SDK: 
            #This will take a couple of minutes to show up in C:\Tools\WindowsSDK\WindowsKits
            c:\winsdksetup.exe /features +  /q 
        }
        'Blue'{
            Write-Host "Installing Chocolatey" -ForegroundColor Green
            Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
            
            Write-Host "Installing Chrome" -ForegroundColor Green
            choco install googlechrome -y
            
            Write-Host "Installing Git" -ForegroundColor Green
            choco install git.install -y
            $env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
            Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
            refreshenv 
            refreshenv 

            #Wireshark:
            choco install -y --limit-output --no-progress wireshark winpcap #command borrowed from - https://github.com/clong/DetectionLab/blob/6525456492bc311c3ae061adb854691f424e4ba7/Vagrant/scripts/install-choco-extras.ps1#L13

            #Notepad++:
            choco install notepadplusplus -y

            New-Item -Path $FolderPath\$DirectoryName -Name "Blue" -ItemType "directory"

            #Sysinternals:
            $Sysinternals = "https://download.sysinternals.com/files/SysinternalsSuite.zip"
            Invoke-WebRequest $Sysinternals -OutFile "C:\Tools\Blue\Sysinternals.zip"
        }
        'Red'{
            Write-Host "Installing Chocolatey" -ForegroundColor Green
            Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
            
            Write-Host "Installing Chrome" -ForegroundColor Green
            choco install googlechrome -y
            
            Write-Host "Installing Git" -ForegroundColor Green
            choco install git.install -y
            $env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
            Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
            refreshenv 
            refreshenv 

            #Wireshark:
            choco install -y --limit-output --no-progress wireshark winpcap #command borrowed from - https://github.com/clong/DetectionLab/blob/6525456492bc311c3ae061adb854691f424e4ba7/Vagrant/scripts/install-choco-extras.ps1#L13

            #Notepad++:
            choco install notepadplusplus -y

            New-Item -Path $FolderPath\$DirectoryName -Name "Red" -ItemType "directory"

            #Powersploit:
            $Powersploit = "https://github.com/PowerShellMafia/PowerSploit/archive/dev.zip"
            Invoke-WebRequest $Powersploit -OutFile "C:\Tools\Red\PowerSploit.zip"

            #Rubeus:
            git clone https://github.com/GhostPack/Rubeus.git $FolderPath\$DirectoryName\Red\Rubeus

            #Powershell Arsenal:
            git clone https://github.com/mattifestation/PowerShellArsenal.git $FolderPath\$DirectoryName\Red\PowershellArsenal

            #Seatbelt: 
            git clone https://github.com/GhostPack/Seatbelt.git $FolderPath\$DirectoryName\Red\Seatbelt

            #Mimikatz:
            $release = (Invoke-WebRequest "https://api.github.com/repos/gentilkiwi/mimikatz/releases" -UseBasicParsing | ConvertFrom-Json)[0].tag_name #Line taken from: https://github.com/clong/DetectionLab/blob/eabe0fa90c7d0a85b18e0f7557b00d5ca055d646/Vagrant/scripts/install-redteam.ps1#L36
            $mimikatz = "https://github.com/gentilkiwi/mimikatz/releases/download/$release/mimikatz_trunk.zip"
            Invoke-WebRequest $mimikatz -OutFile "$FolderPath\$DirectoryName\Red\Mimikatz.zip"

        }
    }
     if ($Automate){
            Unregister-ScheduledTask -TaskName Get-Tools -Confirm:$false
        }
}