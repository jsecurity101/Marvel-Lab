function Update-Domain {

    <#
    .SYNOPSIS
    Updates domain controllers AD Groups, GPOs, and AD Users.

    .DESCRIPTION
    Update-Domain updates the domain controllers users, settings, and policies.

    .PARAMETER ProjectFilePath
    Path of the Marvel-Lab directory.

     .PARAMETER UserCSVFilePath
    Path of the Marvel-Lab directory.

    .PARAMETER WallpaperFilePath
    Path to the wallpaper you want to use.

    .PARAMETER GPOFilePath
    Path to the GPO files.
     
    .PARAMETER Automate
    Switch statement to remove previous scheduled tasks.
    
    .EXAMPLE
    Update-Domain
    
    .EXAMPLE
    Update-Workstation -Automate

    .EXAMPLE
    Update-Workstation $UserCSVFilePath C:\marvel_users.csv -Automate
    #>

    param(
        [string]
        $UserCSVFilePath = 'C:\Marvel-Lab\Earth-DC\Import-Marvel\marvel_users.csv',

        [string]
        $WallpaperFilePath = 'C:\Marvel-Lab\images\cap.jpg',

        [string]
        $ProjectFilePath = 'C:\Marvel-Lab',

        [string]
        $GPOFilePath = 'C:\Marvel-Lab\Earth-DC\GPOBackup',

        [switch]
        $Automate
    )
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Beginning of Update-Domain"
    Import-Module ActiveDirectory
    $ADUsers = Import-CSV $UserCSVFilePath
    #Adding AD Group for Local Admins on Workstations
    New-ADGroup -Name "Local Admins" -SamAccountName LocalAdmins -GroupCategory Security -GroupScope Global -DisplayName "Local Admins" -Path "CN=Users,DC=marvel,DC=local" -Description "Members of this group are Local Administrators on Workstations"

    foreach ($User in $ADUsers)

    {       
        $username 	= $User.username
        $password 	= $User.password
        $firstname 	= $User.firstname
        $lastname 	= $User.lastname
        $ou 		= $User.ou 
        $province   = $User.province
        $department = $User.department
        $password = $User.Password
        $identity = $User.identity

        if (Get-ADUser -F {SamAccountName -eq $Username })
        {
            Write-Warning "$username already exists."
        }

        else
        {

            New-ADUser `
                -SamAccountName $Username `
                -UserPrincipalName "$username@marvel.local" `
                -Name "$firstname $lastname" `
                -GivenName $firstname `
                -Surname $lastname `
                -Enabled $True `
                -DisplayName "$firstname $lastname" `
                -Path $ou `
                -state $province `
                -Department $department `
                -AccountPassword (convertto-securestring $password -AsPlainText -Force) -PasswordNeverExpires $True
            
            
            Add-ADGroupMember `
            -Members $username `
            -Identity $identity `
            }

        Write-Output "$username has been to the domain and added to the $identity group"
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] $username has been to the domain and added to the $identity group"
        
    }
    #Setting SPNs for Domain
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Setting SPNs"
    setspn -a mjolnir/marvel.local marvel\thor
    setspn -a mr3000/marvel.local marvel\ironman 

    New-ADOrganizationalUnit -Name "Workstations" -Path "DC=MARVEL,DC=LOCAL"

    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Setting Wallpaper"
    New-Item HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\ -Name System
    Set-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -name Wallpaper -value $WallpaperFilePath
    Set-ItemProperty -path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\System' -name WallpaperStyle -value "4"


    #Adding GPOs
    #Audit Logs
    $GPOName = 'Audit Logs'
    $OU = "ou=Workstations,dc=marvel,dc=local"
    $OU1 = "ou=Domain Controllers,dc=marvel,dc=local"
    Write-Host "Importing $GPOName..."
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Importing $GPOName..."
    Import-GPO -BackupGpoName $GPOName -Path $GPOFilePath\$GPOName -TargetName $GPOName -CreateIfNeeded
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
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Importing $GPOName..."
    Import-GPO -BackupGpoName $GPOName -Path $GPOFilePath\$GPOName -TargetName $GPOName -CreateIfNeeded
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
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Importing $GPOName..."
    Import-GPO -BackupGpoName $GPOName -Path $GPOFilePath\$GPOName -TargetName $GPOName -CreateIfNeeded
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
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Importing $GPOName..."
    Import-GPO -BackupGpoName $GPOName -Path $GPOFilePath\$GPOName -TargetName $GPOName -CreateIfNeeded
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
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Importing $GPOName..."
    Import-GPO -BackupGpoName $GPOName -Path $GPOFilePath\$GPOName -TargetName $GPOName -CreateIfNeeded
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
    if($Automate){
        Unregister-ScheduledTask -TaskName New-DCAutomatedTask -Confirm:$false
        Unregister-ScheduledTask -TaskName Update-Domain -Confirm:$false
    }

}