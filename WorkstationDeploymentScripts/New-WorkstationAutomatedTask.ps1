function New-WorkstationAutomatedTask {
    param(
        [string]
        $ProjectFilePath = 'C:\Marvel-Lab'
    )
        $action = New-ScheduledTaskAction -Execute 'powershell' -Argument "Import-Module $ProjectFilePath\Marvel-Lab.psm1; Update-Workstation -ProjectFilePath $ProjectFilePath -Automate 2>&1 | tee -filePath C:\deploymentlog.txt"
        $trigger = New-ScheduledTaskTrigger -AtLogOn
        $ScheduledTask = Register-ScheduledTask -Action $action -User 'marvel\thor' -Password 'GodofLightning1!' -Trigger $trigger -TaskName Update-Workstation
        Start-ScheduledTask -TaskName Update-Workstation
}