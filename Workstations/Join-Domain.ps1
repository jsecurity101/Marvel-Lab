function Join-Domain {

    <#
    .SYNOPSIS
    Joins workstation to marvel domain.

    .DESCRIPTION
    Join-Domain was designed to add the current workstation to the marvel domain.

    .PARAMETER ProjectFilePath
    Path of the Marvel-Lab directory.

    .PARAMETER Automate
    Switch statement to create a scheduled task to run New-WorkstationAutomatedTask
    
    .EXAMPLE
    Join-Domain

    .EXAMPLE
    Join-Domain -ProjectFilePath C:\Marvel-Lab -Automate
    #>

    param(
        [string]
        $ProjectFilePath = 'C:\Marvel-Lab',

        [switch]
        $Automate
    )
            Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Beginning of Join-Domain"
            $DomainUser = "marvel.local\loki"
            $DomainPassword = ConvertTo-SecureString -String "Mischief$" -AsPlainText -Force
            $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $DomainUser, $DomainPassword
            Write-Host "Joining Domain..." -ForegroundColor Green
            Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Joining Domain..."
            Add-Computer -DomainName "marvel.local" -OUPath "OU=Workstations,DC=marvel,DC=local" -Credential $Credential -Force
            if ($Automate){
                Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Creating Scheduled Task for New-WorkstationAutomatedTask"
                $action = New-ScheduledTaskAction -Execute 'powershell' -Argument "Import-Module $ProjectFilePath\Marvel-Lab.psm1; New-WorkstationAutomatedTask -ProjectFilePath $ProjectFilePath"
                $trigger = New-ScheduledTaskTrigger  -AtLogOn
                $principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
                $ScheduledTask = Register-ScheduledTask -Action $action -Trigger $trigger  -Principal $principal -TaskName New-WorkstationAutomatedTask
                Unregister-ScheduledTask -TaskName Join-Domain -Confirm:$false
            }
            Restart-Computer -Force
}