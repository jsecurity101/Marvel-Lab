#Jonathan Johnson
#github:https://github.com/jsecurity101

Write-Output "
   _____                            _              __  __                      _  
 |_   _|                          | |            |  \/  |                    | | 
   | |  _ __ ___  _ __   ___  _ __| |_   ______  | \  / | __ _ _ ____   _____| | 
   | | | '_ ` _ \| '_ \ / _ \| '__| __| |______| | |\/| |/ _` | '__\ \ / / _ \ | 
  _| |_| | | | | | |_) | (_) | |  | |_           | |  | | (_| | |   \ V /  __/ | 
 |_____|_| |_| |_| .__/ \___/|_|   \__|          |_|  |_|\__,_|_|    \_/ \___|_| 
                 | |                                                             
                 |_|                                                             
"  

Function Import-Marvel()


{

Import-Module activedirectory
  
#Update the path to where the .csv file is stored. 

$ADUsers = Import-csv C:\Marvel-Lab\Earth-DC\Import-Marvel\marvel_users.csv

#Adding AD Group for Local Admins on Workstations
New-ADGroup -Name "Local Admins" -SamAccountName LocalAdmins -GroupCategory Security -GroupScope Global -DisplayName "Local Admins" -Path "CN=Users,DC=marvel,DC=local" -Description "Members of this group are Local Administrators on Workstations"

foreach ($User in $ADUsers)

{
	#Read in data from .csv and assign it to the variable. This is done to import attributes in the New-ADUser.
		
	$username 	= $User.username
	$password 	= $User.password
	$firstname 	= $User.firstname
	$lastname 	= $User.lastname
	$ou 		= $User.ou 
    $province   = $User.province
    $department = $User.department
    $password = $User.Password
    $identity = $User.identity


	#Runs check against AD to verify User doesn't already exist inside of Active Directory

	if (Get-ADUser -F {SamAccountName -eq $Username })
	{
		 Write-Warning "$username already exists."
	}


#If User doesn't exist, New-ADUser will add $Username to AD based on the objects specified specified in the .csv file. 

	else


	{
        #Update to UserPrincipalName to match personal domain. Ex: If domain is: example.com. Should read as - $Username@example.com
        #Update "-Path" on line 58 to match domain.

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
    }

    setspn -a mjolnir/marvel.local marvel\thor #update domain to match enviroments
    setspn -a mr3000/marvel.local marvel\ironman #update domain to match enviroments
}
Import-Marvel
