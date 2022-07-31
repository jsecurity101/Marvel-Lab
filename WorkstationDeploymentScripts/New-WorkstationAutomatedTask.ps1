function New-WorkstationAutomatedTask {
    param(
        [string]
        $ProjectFilePath = 'C:\Marvel-Lab'
    )
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Beginning of New-WorkstationAutomatedTask"
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Creating Scheduled Task for Update-Workstation"
        $action = New-ScheduledTaskAction -Execute 'powershell' -Argument "Import-Module $ProjectFilePath\Marvel-Lab.psm1; Update-Workstation -ProjectFilePath $ProjectFilePath -Automate"
        $ScheduledTask = Register-ScheduledTask -Action $action -User 'marvel\thor' -Password 'GodofLightning1!' -TaskName Update-Workstation
        Start-ScheduledTask -TaskName Update-Workstation
}