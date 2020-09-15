#Author Jonathan Johnson
#License: GPL-3.0

#Resources -
#http://woshub.com/check-powershell-script-running-elevated/

Write-Host "This script will update local groups as well as add a wallpaper for the user running this script"

Write-Host "Checking for elevated permissions..."
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
[Security.Principal.WindowsBuiltInRole] "Administrator")) {
Write-Warning "You need to run this script as an Administrator. Please open up new window as Administrator."
Break
}
else {
    Write-Host "Adding users to Local Administrators Group"
    Add-LocalGroupMember -Group Administrators -Member "marvel.local\loki"
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
    }

    Function Wallpaper
    { 
        New-Item HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ -Name System
        Set-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\\System' -name Wallpaper -value "C:\Marvel-Lab\images\thor.jpg"
        Set-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\\System' -name WallpaperStyle -value "4"
    
    } 
    
    Wallpaper

    Restart-Computer -Force