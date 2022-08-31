function Update-Workstation {

    <#
    .SYNOPSIS
    Updates workstation's administators/RDP group.

    .DESCRIPTION
    Update-Workstation was designed to update various workstation settings/policies.

    .PARAMETER ProjectFilePath
    Path of the Marvel-Lab directory.
     
    .PARAMETER Automate
    Switch statement to create a scheduled task to run Get-Tools
    
    .EXAMPLE
    Update-Workstation
    
    .EXAMPLE
    Update-Workstation -Automate

    .EXAMPLE
    Update-Workstation -ProjectFilePath C:\Marvel-Lab -Automate
    #>


    param(
        [string]
        $ProjectFilePath = 'C:\Marvel-Lab',

        [switch]
        $Automate
)

    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Beginning of Update-Workstation"

    Write-Output "[*] Adding users to Local Administrators Group"
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Adding users to Local Administrators Group"
    Add-LocalGroupMember -Group "Administrators" -Member "marvel.local\loki"
    Add-LocalGroupMember -Group "Administrators" -Member "marvel.local\panther"
    Add-LocalGroupMember -Group "Administrators" -Member "marvel.local\spidy"
    Add-LocalGroupMember -Group "Administrators" -Member "marvel.local\ironman"

    Write-Host "[*] Allowing RDP"
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Allowing RDP"
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0

    Write-Host "[*] Adding users to Remote Desktop Users Group"
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Adding users to Remote Desktop Users Group"
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member "marvel.local\loki"
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member "marvel.local\panther"
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member "marvel.local\spidy"
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member "marvel.local\ironman"

    Write-Host "[*] Setting Wallpaper"
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Setting Wallpaper"
    New-Item HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ -Name System
    Set-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\\System' -name Wallpaper -value "C:\Marvel-Lab\images\thor.jpg"
    Set-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\\System' -name WallpaperStyle -value "4"

    if ($Automate){
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Adding ScheduledTask for Get-Tools"
        $action = New-ScheduledTaskAction -Execute 'powershell' -Argument "Import-Module $ProjectFilePath\Marvel-Lab.psm1; Get-Tools -ProjectFilePath $ProjectFilePath -Automate" 
        $ScheduledTask = Register-ScheduledTask -Action $action  -User 'marvel\thor' -Password 'GodofLightning1!' -TaskName Get-Tools  
        $RunTask = Start-ScheduledTask -TaskName Get-Tools
        $Unregister = Unregister-ScheduledTask -TaskName New-WorkstationAutomatedTask -Confirm:$false
    }

}
