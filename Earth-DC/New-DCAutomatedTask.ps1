function New-DCAutomatedTask {
    <#
    .SYNOPSIS
    Creates Update-Domain scheduled task.

    .DESCRIPTION
    New-DCAutomatedTask was designed to create a scheduled task for Update-Domain with the user marvel\Administrator.

    .PARAMETER ProjectFilePath
    Path of the Marvel-Lab directory.

    .PARAMETER UserCSVFilePath
    Path of the Marvel-Lab directory.

    .PARAMETER WallpaperFilePath
    Path to the wallpaper you want to use.

    .PARAMETER GPOFilePath
    Path to the GPO files.
    
    .PARAMETER Password
    Administrators password.

    .EXAMPLE
    New-DCAutomatedTask -Password 'Changeme1!'

    .EXAMPLE
    New-DCAutomatedTask -Password 'Changeme1!' -ProjectFilePath C:\Marvel-Lab
    #>

    param(
        [string]
        [ValidateNotNullOrEmpty()]
        $Password,

        [string]
        $ProjectFilePath = 'C:\Marvel-Lab',

        [string]
        $UserCSVFilePath = 'C:\Marvel-Lab\Earth-DC\Import-Marvel\marvel_users.csv',

        [string]
        $WallpaperFilePath = 'C:\Marvel-Lab\images\cap.jpg',

        [string]
        $GPOFilePath = 'C:\Marvel-Lab\Earth-DC\GPOBackup' 
        )
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Beginning of New-DCAutomatedTask...."
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Createing ScheduledTask for Update-Domain..."
        $action = New-ScheduledTaskAction -Execute 'powershell' -Argument "Import-Module $ProjectFilePath\Marvel-Lab.psm1; Update-Domain -UserCSVFilePath $UserCSVFilePath -WallpaperFilePath $WallpaperFilePath -GPOFilePath $GPOFilePath -ProjectFilePath $ProjectFilePath  -Automate 2>&1 | tee -filePath $ProjectFilePath\scheduledtasklog.txt"
        $ScheduledTask = $ScheduledTask = Register-ScheduledTask -Action $action -User 'marvel\Administrator' -Password $Password -TaskName Update-Domain
        Start-ScheduledTask -TaskName Update-Domain
        Unregister-ScheduledTask -TaskName Initialize-MarvelDomain -Confirm:$false
}
