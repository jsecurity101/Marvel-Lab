function Join-Domain {
    param(
        [string]
        $ProjectFilePath = 'C:\Marvel-Lab',

        [switch]
        $Automate
    )
            $User = "marvel.local\loki"
            $Password = ConvertTo-SecureString -String "Mischief$" -AsPlainText -Force
            $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password
            Write-Host "Joining Domain..." -ForegroundColor Green
            Add-Computer -DomainName "marvel.local" -OUPath "OU=Workstations,DC=marvel,DC=local" -Credential $Credential -Force
            if ($Automate){
                $action = New-ScheduledTaskAction -Execute 'powershell' -Argument "Import-Module $ProjectFilePath\Marvel-Lab.psm1; New-WorkstationAutomatedTask -ProjectFilePath $ProjectFilePath 2>&1 | tee -filePath C:\deploymentlog.txt" #Update
                $trigger = New-ScheduledTaskTrigger -AtLogOn
                $principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
                $ScheduledTask = Register-ScheduledTask -Action $action -Trigger $trigger  -Principal $Principal -TaskName New-WorkstationAutomatedTask
            }
            Restart-Computer -Force
}