#Author Jonathan Johnson
#License: GPL-3.0

#Resources -
#Microsoft-Docs:https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/rename-computer?view=powershell-6
#Microsoft-Docs: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/get-credential?view=powershell-6
#http://woshub.com/check-powershell-script-running-elevated/

Write-Host "Checking for elevated permissions..."
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
[Security.Principal.WindowsBuiltInRole] "Administrator")) {
Write-Warning "You need to run this script as an Administrator. Please open up new window as Administrator."
Break
}
else {
    $User = Read-Host "Please enter username"
    $Password = Read-Host "Please enter username password" -AsSecureString
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password
    Write-Host "Renaming Computer..." -ForegroundColor Green
    Rename-computer –computername $env:COMPUTERNAME –newname (“Wakanda-WrkStn”) -DomainCredential $Credential -Force -Restart
}