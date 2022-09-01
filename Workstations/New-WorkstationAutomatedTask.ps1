function New-WorkstationAutomatedTask {

    <#
    .SYNOPSIS
    Creates Update-Workstation scheduled task.

    .DESCRIPTION
    New-WorkstationAutomatedTask was designed to create a scheduled task for Update-Workstation with the user marvel\thor.

    .PARAMETER ProjectFilePath
    Path of the Marvel-Lab directory.
    
    .EXAMPLE
    New-WorkstationAutomatedTask

    .EXAMPLE
    New-WorkstationAutomatedTask -ProjectFilePath C:\Marvel-Lab
    #>

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