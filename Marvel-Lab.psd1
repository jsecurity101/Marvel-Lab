@{

    # Script module or binary module file associated with this manifest.
    RootModule = 'Marvel-Lab.psm1'
    
    # Version number of this module.
    ModuleVersion = '1.0.0.0'
    
    # ID used to uniquely identify this module
    GUID = 'e64fed17-ab66-4c15-bcd4-c8bae84298eb'
    
    # Author of this module
    Author = 'Jonathan Johnson, Ben Shell'
    
    # Company or vendor of this module
    CompanyName = ''
    
    # Copyright statement for this module
    Copyright = 'BSD 3-Clause unless explicitly noted otherwise'
    
    # Description of the functionality provided by this module
    Description = 'A module to facilitate the automation of a defensive testing lab based off of Marvel characters'
    
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0'
    
    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = 'Rename-DC',
                        'Initialize-MarvelDomain',
                        'New-DCAutomatedTask',
                        'Update-Domain',
                        'Rename-Workstation',
                        'Join-Domain',
                        'Update-Workstation',
                        'New-WorkstationAutomatedTask',
                        'Get-Tools'
                        
                        
    
    # Cmdlets to export from this module
    CmdletsToExport = ''

    # Variables to export from this module
    VariablesToExport = ''

    # Aliases to export from this module
    AliasesToExport = ''
    }