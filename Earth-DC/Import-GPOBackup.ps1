# Author: Jonathan Johnson
# Purpose: Install GPO's from: https://github.com/Cyb3rWard0g/mordor/tree/master/environment/shire/GPOBackup.


Write-Host "$('[{0:HH:mm}]' -f (Get-Date)) Configuring auditing policy GPOs."

#Audit Logs
$GPOName = 'Audit Logs'
$OU = "ou=Workstations,dc=marvel,dc=local"
$OU1 = "ou=Domain Controllers,dc=marvel,dc=local"
Write-Host "Importing $GPOName..."
Import-GPO -BackupGpoName $GPOName -Path "C:\GPOBackup\Audit Logs" -TargetName $GPOName -CreateIfNeeded
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


#RDP
$GPOName = 'RDP'
$OU = "ou=Workstations,dc=marvel,dc=local"
Write-Host "Importing $GPOName..."
Import-GPO -BackupGpoName $GPOName -Path "C:\GPOBackup\RDP" -TargetName $GPOName -CreateIfNeeded
$gpLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name $GPOName
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
    New-GPLink -Name $GPOName -Target $OU -Enforced yes
}
else
{
    Write-Host "GpLink $GPOName already linked on $OU. Moving On."
}


#Workstation Local Administrators
$GPOName = 'Workstation Local Administrators'
$OU = "ou=Workstations,dc=marvel,dc=local"
Write-Host "Importing $GPOName..."
Import-GPO -BackupGpoName $GPOName -Path "C:\GPOBackup\Workstation Local Administrators" -TargetName $GPOName -CreateIfNeeded
$gpLinks = $null
$gPLinks = Get-ADOrganizationalUnit -Identity $OU -Properties name,distinguishedName, gPLink, gPOptions
$GPO = Get-GPO -Name $GPOName
If ($gPLinks.LinkedGroupPolicyObjects -notcontains $gpo.path)
{
    New-GPLink -Name $GPOName -Target $OU -Enforced yes
}
else
{
    Write-Host "GpLink $GPOName already linked on $OU. Moving On."
}

#Disable Windows Firewall
$GPOName = 'Disable Windows Firewall'
$OU = "ou=Workstations,dc=marvel,dc=local"
$OU1 = "ou=Domain Controllers,dc=marvel,dc=local"
Write-Host "Importing $GPOName..."
Import-GPO -BackupGpoName $GPOName -Path "C:\GPOBackup\Disable Windows Firewall" -TargetName $GPOName -CreateIfNeeded
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
Import-GPO -BackupGpoName $GPOName -Path "C:\GPOBackup\Disable Windows Defender" -TargetName $GPOName -CreateIfNeeded
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
Import-GPO -BackupGpoName $GPOName -Path "C:\GPOBackup\Disable Windows Automatic Updates" -TargetName $GPOName -CreateIfNeeded
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
Import-GPO -BackupGpoName $GPOName -Path "C:\GPOBackup\Powershell Logging" -TargetName $GPOName -CreateIfNeeded
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
