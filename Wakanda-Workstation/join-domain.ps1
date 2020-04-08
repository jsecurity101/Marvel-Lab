#Author Jonathan Johnson
#License: GPL-3.0

$User = "marvel.local\panther"
$Password = ConvertTo-SecureString -String "WakandaForever!" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password

Add-Computer -DomainName "marvel.local" -OUPath "OU=Workstations,DC=marvel,DC=local" -Credential $Credential -Force -Restart