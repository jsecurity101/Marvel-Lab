function Rename-DC {
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
    Write-Output "Setting timezone to UTC...."

    c:\windows\system32\tzutil.exe /s "UTC"

    Write-Output "Renaming Host..."

    if ($Automate){
        $action = New-ScheduledTaskAction -Execute 'powershell' -Argument "Import-Module $ProjectFilePath\Marvel-Lab.psm1; Initialize-MarvelDomain -Automate -Password $Password 2>&1 | tee -filePath $ProjectFilePath\Earth-DC\deploymentlog.txt"
        $trigger = New-ScheduledTaskTrigger -AtLogOn
        $principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        $ScheduledTask = Register-ScheduledTask -Action $action -Trigger $trigger  -Principal $Principal -TaskName Initialize-MarvelDomain 
    }

    $Rename = Rename-computer -ComputerName $env:COMPUTERNAME -NewName $DomainControllerName  -Force -Restart
}