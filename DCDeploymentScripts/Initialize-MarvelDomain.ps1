function Initialize-MarvelDomain {

    param(
        [string]
        $HostName = (Get-WmiObject win32_computersystem).Name, 

        [string]
        $DomainName = (Get-WmiObject win32_computersystem).Domain,

        [string]
        [ValidateNotNullOrEmpty()]
        $Password,
        
        [string]
        $ProjectFilePath = 'C:\Marvel-Lab',

        [string]
        $UserCSVFilePath = 'C:\Marvel-Lab\Earth-DC\Import-Marvel\marvel_users.csv',

        [string]
        $WallpaperFilePath = 'C:\Marvel-Lab\images\cap.jpg',

        [string]
        $GPOFilePath = 'C:\Marvel-Lab\Earth-DC\GPOBackup',

        [switch]
        $Automate

    )
    Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Beginning of Initialize-MarvelDomain...."
    $AdminPassword = (ConvertTo-SecureString $Password -AsPlainText -Force)

    if ((Get-WmiObject win32_computersystem).PartOfDomain -eq $false) 
    {
        Write-Host -fore green "[*] $HostName is not the domain controller yet. Creating forest now"
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] $HostName is not the domain controller yet. Creating forest now...."
        
        # Windows Features Installation
        Get-Command -Module ServerManager
        Write-Host -fore green "Installing Windows features:"
        $windows_features = @("AD-Domain-Services", "DNS")
        $windows_features.ForEach({
            Write-Host -fore yello "[*]  Installing $_ Windows feature.."
            Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Installing $_ Windows feature.."
            Install-WindowsFeature -name $_ -IncludeManagementTools
        })
        
        # Creating Forest
        Write-Host -fore green "[*] Deploying a new forest and promoting $HostName to Domain Controller."
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Deploying a new forest and promoting $HostName to Domain Controller."

        Import-Module ADDSDeployment
        Install-ADDSForest `
        -SafeModeAdministratorPassword $($AdminPassword) `
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

        Write-Host -fore red "[*] Cannot create forest. $hostname is already either apart of $DomainName domain or is already the domain controller"
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Cannot create forest. $hostname is already either apart of $DomainName domain or is already the domain controller."
    }
    if ($Automate){
        Add-Content $ProjectFilePath\Deploymentlog.txt "[*] Creating ScheduledTask for New-DCAutomatedTask."
        $action = New-ScheduledTaskAction -Execute 'powershell' -Argument "Import-Module $ProjectFilePath\Marvel-Lab.psm1; New-DCAutomatedTask -UserCSVFilePath $UserCSVFilePath -WallpaperFilePath $WallpaperFilePath -GPOFilePath $GPOFilePath -Password $Password 2>&1 | tee -filePath $ProjectFilePath\Earth-DC\deploymentlog.txt"
        $trigger = New-ScheduledTaskTrigger -AtLogOn
        $principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        $ScheduledTask = Register-ScheduledTask -Action $action -Trigger $trigger  -Principal $Principal -TaskName New-DCAutomatedTask  
        Unregister-ScheduledTask -TaskName Initialize-MarvelDomain -Confirm:$false
    }
    
    Restart-Computer -Force
}