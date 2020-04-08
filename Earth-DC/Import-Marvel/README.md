# Import-Marvel

<strong>Powershell script and .CSV file that allows you to import Marvel characters as users into Active Directory</strong>

<img src="https://media.giphy.com/media/vBjLa5DQwwxbi/giphy.gif" width=900 />



<strong>Script:</strong>
1. Adds users into Active Directory
2. Adds users to appropriate groups based off of `marvel_users.csv`.
3. Sets Service Prinipal Names (SPN)'s for users `thor` and `ironman`. 


<strong>To run:</strong>
1. Download `import_marvel.ps1` and `marvel_users.csv`.

2. Change domain name to match personal enviroment's domain.
 
**Note:** This will need to be done in both files. 	

-  Inside of `import_marvel.ps1` on line: 60, 79, & 80
	
-  Inside of `marvel_users.csv` for each user in the `ou` section

**Example:** `"CN=thor,DC=example,DC=com"` if desired domain is `example.com`
		
3. Change the path to which `marvel_users.csv` is located on line 24 for `import_marvel.ps1`.

4. Change the path to which `quotes.txt` is located on line 83 for `import_marvel.ps1`

4. Run `.\import_marvel.ps1`




