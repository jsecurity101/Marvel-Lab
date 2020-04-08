#Author Jonathan Johnson
#License: GPL-3.0

$User = "marvel.local\thor"
$Password = ConvertTo-SecureString -String "GodofLightning1!" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $Password

Add-Computer -DomainName "marvel.local" -OUPath "OU=Workstations,DC=marvel,DC=local" -Credential $Credential -Force -Restart