#Author Jonathan Johnson (@jsecurity101)

Write-Host "This script will add an organizational unit called Workstations, as well as add a wallpaper for the user running this script"

New-ADOrganizationalUnit -Name "Workstations" -Path "DC=MARVEL,DC=LOCAL"

Write-Host "Workstation OU has been added!" -ForegroundColor Green

Function Wallpaper
{ 
    New-Item HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ -Name System
    Set-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\\System' -name Wallpaper -value "C:\Marvel-Lab\images\cap.jpg"
    Set-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\\System' -name WallpaperStyle -value "4"

} 

Wallpaper

Restart-Computer -Force