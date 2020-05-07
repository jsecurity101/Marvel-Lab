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
    $User = "marvel.local\loki"
    $Password = ConvertTo-SecureString -String "Mischief$" -AsPlainText -Force
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password
    Write-Host "Joining Domain..." -ForegroundColor Green
    Add-Computer -DomainName "marvel.local" -OUPath "OU=Workstations,DC=marvel,DC=local" -Credential $Credential -Force -Restart
}