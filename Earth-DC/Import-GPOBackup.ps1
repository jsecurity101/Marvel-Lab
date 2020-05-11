# Author: Jonathan Johnson


Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Configuring auditing policy GPOs."

#Audit Logs
$GPOName = 'Audit Logs'
$OU = "ou=Workstations,dc=marvel,dc=local"
$OU1 = "ou=Domain Controllers,dc=marvel,dc=local"
Write-Host "Importing $GPOName..."
Import-GPO -BackupGpoName $GPOName -Path "C:\Marvel-Lab\Earth-DC\GPOBackup\Audit Logs" -TargetName $GPOName -CreateIfNeeded
$gpLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$gPLinks = Get-ADOrganizationalUnit -Identity $OU1 -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name $GPOName
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
    New-GPLink -Name $GPOName -Target $OU -Enforced yes
    New-GPLink -Name $GPOName -Target $OU1 -Enforced yes
}
else
{
    Write-Host "GpLink $GPOName already linked on $OU. Moving On."
    Write-Host "GpLink $GPOName already linked on $OU1. Moving On."
}

#Disable Windows Firewall
$GPOName = 'Disable Windows Firewall'
$OU = "ou=Workstations,dc=marvel,dc=local"
$OU1 = "ou=Domain Controllers,dc=marvel,dc=local"
Write-Host "Importing $GPOName..."
Import-GPO -BackupGpoName $GPOName -Path "C:\Marvel-Lab\Earth-DC\GPOBackup\Disable Windows Firewall" -TargetName $GPOName -CreateIfNeeded
$gpLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$gPLinks = Get-ADOrganizationalUnit -Identity $OU1 -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name $GPOName
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
    New-GPLink -Name $GPOName -Target $OU -Enforced yes
    New-GPLink -Name $GPOName -Target $OU1 -Enforced yes
}
else
{
    Write-Host "GpLink $GPOName already linked on $OU. Moving On."
    Write-Host "GpLink $GPOName already linked on $OU1. Moving On."
}

#Disable Windows Defender
$GPOName = 'Disable Windows Defender'
$OU = "ou=Workstations,dc=marvel,dc=local"
$OU1 = "ou=Domain Controllers,dc=marvel,dc=local"
Write-Host "Importing $GPOName..."
Import-GPO -BackupGpoName $GPOName -Path "C:\Marvel-Lab\Earth-DC\GPOBackup\Disable Windows Defender" -TargetName $GPOName -CreateIfNeeded
$gpLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$gPLinks = Get-ADOrganizationalUnit -Identity $OU1 -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name $GPOName
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
    New-GPLink -Name $GPOName -Target $OU -Enforced yes
    New-GPLink -Name $GPOName -Target $OU1 -Enforced yes
}
else
{
    Write-Host "GpLink $GPOName already linked on $OU. Moving On."
    Write-Host "GpLink $GPOName already linked on $OU1. Moving On."
}

#Disable Windows Automatic Updates
$GPOName = 'Disable Windows Automatic Updates'
$OU = "ou=Workstations,dc=marvel,dc=local"
$OU1 = "ou=Domain Controllers,dc=marvel,dc=local"
Write-Host "Importing $GPOName..."
Import-GPO -BackupGpoName $GPOName -Path "C:\Marvel-Lab\Earth-DC\GPOBackup\Disable Windows Automatic Updates" -TargetName $GPOName -CreateIfNeeded
$gpLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$gPLinks = Get-ADOrganizationalUnit -Identity $OU1 -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name $GPOName
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
    New-GPLink -Name $GPOName -Target $OU -Enforced yes
    New-GPLink -Name $GPOName -Target $OU1 -Enforced yes
}
else
{
    Write-Host "GpLink $GPOName already linked on $OU. Moving On."
    Write-Host "GpLink $GPOName already linked on $OU1. Moving On."
}

#Powershell Logging
$GPOName = 'Powershell Logging'
$OU = "ou=Workstations,dc=marvel,dc=local"
$OU1 = "ou=Domain Controllers,dc=marvel,dc=local"
Write-Host "Importing $GPOName..."
Import-GPO -BackupGpoName $GPOName -Path "C:\Marvel-Lab\Earth-DC\GPOBackup\Powershell Logging" -TargetName $GPOName -CreateIfNeeded
$gpLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$gPLinks = Get-ADOrganizationalUnit -Identity $OU1 -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name $GPOName
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
    New-GPLink -Name $GPOName -Target $OU -Enforced yes
    New-GPLink -Name $GPOName -Target $OU1 -Enforced yes
}
else
{
    Write-Host "GpLink $GPOName already linked on $OU. Moving On."
    Write-Host "GpLink $GPOName already linked on $OU1. Moving On."
}
