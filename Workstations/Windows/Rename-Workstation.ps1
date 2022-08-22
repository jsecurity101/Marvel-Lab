function Rename-Workstation {

    <#
    .SYNOPSIS
    Rename's the workstation.

    .DESCRIPTION
    Rename-Workstation was designed to update the workstations name to Asgard-Wrkstn or Wakanda-Wrkstn.

    .PARAMETER WorkstationName
    The new name of the workstation (Asgard-Wrkstn/Wakanda-Wrkstn) 

    .PARAMETER ProjectFilePath
    Path of the Marvel-Lab directory.
     
    .PARAMETER Automate
    Switch statement to create a scheduled task to run Join-Domain
    
    .EXAMPLE
    Rename-Workstation
    
    .EXAMPLE
    Rename-Workstation -WorkstationName 'Wakanda-Wrkstn' -Automate

    .EXAMPLE
    Rename-Workstation -ProjectFilePath C:\Marvel-Lab -Automate
    #>

    param(
        [string]
        [ValidateSet('Asgard-Wrkstn', 'Wakanda-Wrkstn')]
        $WorkstationName = 'Asgard-Wrkstn',
                
        [string]
        $ProjectFilePath = 'C:\Marvel-Lab',

        [switch]
        $Automate
    )
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Beginning of Rename-Workstation"
    Write-Output "Setting timezone to UTC...."
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Setting timezone to UTC...."
    c:\windows\system32\tzutil.exe /s "UTC"

    Write-Output "Renaming Host..."
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Renaming Host...."
    if ($Automate){
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Creating Scheduled Task for Join-Domain"
        $action = New-ScheduledTaskAction -Execute 'powershell' -Argument "Import-Module $ProjectFilePath\Marvel-Lab.psm1; Join-Domain -ProjectFilePath $ProjectFilePath -Automate"
        $trigger = New-ScheduledTaskTrigger -AtStartup
        $principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        $ScheduledTask = Register-ScheduledTask -Action $action -Trigger $trigger  -Principal $principal -TaskName Join-Domain
    }

    $Rename = Rename-computer -ComputerName $env:COMPUTERNAME -NewName $WorkstationName  -Force -Restart
}