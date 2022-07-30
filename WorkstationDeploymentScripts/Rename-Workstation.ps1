function Rename-Workstation {
    param(
        [string]
        [ValidateSet('Asgard-Wrkstn', 'Wakanda-Wrkstn')]
        $WorkstationName = 'Asgard-Wrkstn',
                
        [string]
        $ProjectFilePath = 'C:\Marvel-Lab',

        [switch]
        $Automate
    )

    Write-Output "Setting timezone to UTC...."

    c:\windows\system32\tzutil.exe /s "UTC"

    Write-Output "Renaming Host..."

    if ($Automate){
        $action = New-ScheduledTaskAction -Execute 'powershell' -Argument "Import-Module $ProjectFilePath\Workstations\Windows\WorkstationDeployment.ps1; Join-Domain -ProjectFilePath $ProjectFilePath -Automate 2>&1 | tee -filePath C:\deploymentlog.txt" #Update
        $trigger = New-ScheduledTaskTrigger -AtLogOn
        $principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        $ScheduledTask = Register-ScheduledTask -Action $action -Trigger $trigger  -Principal $Principal -TaskName Join-Domain  #Update
    }

    Rename-computer –ComputerName $env:COMPUTERNAME -NewName $WorkstationName  -Force -Restart
}