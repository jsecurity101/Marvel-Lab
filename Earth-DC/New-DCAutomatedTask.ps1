function New-DCAutomatedTask {
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
        $action = New-ScheduledTaskAction -Execute 'powershell' -Argument "Import-Module $ProjectFilePath\Marvel-Lab.psm1; Update-Domain -UserCSVFilePath $UserCSVFilePath -WallpaperFilePath $WallpaperFilePath -GPOFilePath $GPOFilePath  -Automate 2>&1 | tee -filePath $ProjectFilePath\Earth-DC\deploymentlog.txt"
        $ScheduledTask = $ScheduledTask = Register-ScheduledTask -Action $action -User 'marvel\Administrator' -Password $Password -TaskName Update-Domain
        Start-ScheduledTask -TaskName Update-Domain
        Unregister-ScheduledTask -TaskName Initialize-MarvelDomain -Confirm:$false
}
