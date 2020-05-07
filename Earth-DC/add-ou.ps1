#Author Jonathan Johnson (@jsecurity101)

New-ADOrganizationalUnit -Name "Workstations" -Path "DC=MARVEL,DC=LOCAL"

Write-Host "Workstation OU has been added!" -ForegroundColor Green