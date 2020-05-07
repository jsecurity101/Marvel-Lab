#Author Jonathan Johnson
#License: GPL-3.0

#Resources -
#http://woshub.com/check-powershell-script-running-elevated/

Write-Host "Checking for elevated permissions..."
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
[Security.Principal.WindowsBuiltInRole] "Administrator")) {
Write-Warning "You need to run this script as an Administrator. Please open up new window as Administrator."
Break
}
else {
    Write-Host "Adding users to Local Administrators Group"
    Add-LocalGroupMember -Group "Administrators" -Member "marvel.com\loki"
    Add-LocalGroupMember -Group "Administrators" -Member "marvel.com\panther"
    Add-LocalGroupMember -Group "Administrators" -Member "marvel.com\spidy"
    Add-LocalGroupMember -Group "Administrators" -Member "marvel.com\ironman"

    Write-Host "Adding users to Remote Desktop Users Group"
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member "marvel.com\loki"
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member "marvel.com\panther"
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member "marvel.com\spidy"
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member "marvel.com\ironman"
}