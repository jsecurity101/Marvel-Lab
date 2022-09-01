function Rename-DC {

    <#
    .SYNOPSIS
    Rename's the Domain Controller.

    .DESCRIPTION
    Rename-DC was designed to update the domain controller's name.

    .PARAMETER DomainControllerName
    The new name of the Domain Controller (Asgard-Wrkstn/Wakanda-Wrkstn) 

    .PARAMETER ProjectFilePath
    Path of the Marvel-Lab directory.

    .PARAMETER Password
    Password of the current administrator
     
    .PARAMETER Automate
    Switch statement to create a scheduled task to run Initialize-MarvelDomain
    
    .EXAMPLE
    Rename-DC -Password 'Changeme1!'
    
    .EXAMPLE
    Rename-DC -Password 'Changeme1!' -Automate

    #>

    param(
 
        [string]
        $ProjectFilePath = 'C:\Marvel-Lab',

        [string]
        $DomainControllerName = 'Earth-DC',
        

        [string]
        [ValidateNotNullOrEmpty()]
        $Password,

        [switch]
        $Automate
    )
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Beginning of Rename-DC...."
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Setting timezone to UTC...."
    Write-Output "[*] Setting timezone to UTC...."

    c:\windows\system32\tzutil.exe /s "UTC"

    Write-Output "[*] Renaming Host..."
    
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Renaming Host..."

    if ($Automate){
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Creating ScheduledTask for Initialize-MarvelDomain"
        $action = New-ScheduledTaskAction -Execute 'powershell' -Argument "Import-Module $ProjectFilePath\Marvel-Lab.psm1; Initialize-MarvelDomain -Automate -Password $Password 2>&1 | tee -filePath $ProjectFilePath\scheduledtasklog.txt"
        $trigger = New-ScheduledTaskTrigger -AtLogOn
        $principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        $ScheduledTask = Register-ScheduledTask -Action $action -Trigger $trigger  -Principal $Principal -TaskName Initialize-MarvelDomain 
    }

    $Rename = Rename-computer -ComputerName $env:COMPUTERNAME -NewName $DomainControllerName  -Force -Restart
}