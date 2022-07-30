function Update-Workstation {
    param(
        [string]
        $ProjectFilePath = 'C:\Marvel-Lab',

        [switch]
        $Automate
)

    Write-Host "Adding users to Local Administrators Group"
    Add-LocalGroupMember -Group "Administrators" -Member "marvel.local\loki"
    Add-LocalGroupMember -Group "Administrators" -Member "marvel.local\panther"
    Add-LocalGroupMember -Group "Administrators" -Member "marvel.local\spidy"
    Add-LocalGroupMember -Group "Administrators" -Member "marvel.local\ironman"

    Write-Host "Allowing RDP"
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0

    Write-Host "Adding users to Remote Desktop Users Group"
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member "marvel.local\loki"
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member "marvel.local\panther"
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member "marvel.local\spidy"
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member "marvel.local\ironman"


    New-Item HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ -Name System
    Set-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\\System' -name Wallpaper -value "C:\Marvel-Lab\images\thor.jpg"
    Set-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\\System' -name WallpaperStyle -value "4"

    if ($Automate){
        $action = New-ScheduledTaskAction -Execute 'powershell' -Argument "Import-Module $ProjectFilePath\Marvel-Lab.psm1; Get-Tools -Automate 2>&1 | tee -filePath C:\deploymentlog.txt" #Update
        $ScheduledTask = Register-ScheduledTask -Action $action  -User 'marvel\thor' -Password 'GodofLightning1!' -TaskName Get-Tools  #Update
        $RunTask = Start-ScheduledTask -TaskName Get-Tools
        $Unregister = Unregister-ScheduledTask -TaskName Create-ScheduledTask -Confirm:$false
        $Unregister = Unregister-ScheduledTask -TaskName Configure-Workstation -Confirm:$false
    }

}
