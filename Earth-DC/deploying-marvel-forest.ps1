# Author: Jonathan Johnson (@jsecurity101)

# References:
# https://github.com/MicrosoftDocs/windowsserverdocs/blob/master/WindowsServerDocs/identity/ad-ds/deploy/Install-a-New-Windows-Server-2012-Active-Directory-Forest--Level-200-.md
# https://stackoverflow.com/a/4409448
# https://raw.githubusercontent.com/jsecurity101/mordor/master/environment/shire/aws/scripts/DC/deploy_forest.ps1

$host_info = gwmi win32_computersystem
$hostname = ($host_info).Name
$domain_name = ($host_info).Domain
$SafeModeAdministratorPassword = Read-Host "Please enter password you would like for administrator safe mode" -AsSecureString

if (($host_info).partofdomain -eq $false) 
{
    write-host -fore green "$hostname is not the domain controller yet. Creating forest now"
    
    # Windows Features Installation
    Get-Command -module ServerManager
    write-host -fore green "Installing Windows features:"
    $windows_features = @("AD-Domain-Services", "DNS")
    $windows_features.ForEach({
        write-host -fore yello "Installing $_ Windows feature.."
        Install-WindowsFeature -name $_ -IncludeManagementTools
    })
    
    # Creating Forest
    write-host -fore green "Deploying a new forest and promoting $hostname to Domain Controller.."

    Import-Module ADDSDeployment
    Install-ADDSForest `
    -SafeModeAdministratorPassword $($SafeModeAdministratorPassword) `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "WinThreshold" `
    -DomainName "marvel.local" `
    -DomainNetbiosName "MARVEL" `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$true `
    -SysvolPath "C:\Windows\SYSVOL" `
    -Force:$true

} 
else 
{

    write-host -fore red "Cannot create forest. $hostname is already either apart of $domain_name domain or is already the domain controller"
} 