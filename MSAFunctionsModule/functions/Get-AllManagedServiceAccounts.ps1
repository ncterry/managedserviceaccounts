#==============================
Function Get-AllManagedServiceAccounts {  
<#
    .SYNOPSIS
    Gather the --- this machine.

    .DESCRIPTION
    No Parameters. Simply returns the local domain.

    .Example
    Get-AllManagedServiceAccounts

    .Example
    Get-AllManagedServiceAccounts $writehost $true
    # Will return the domain to a function, and write the domain in terminal.

    .OUTPUTS
    ---------------Active Directory Managed Service Accounts---------------

    CN=GMSA_AD_CYLONS,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    CN=gMSAtest,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    CN=GMSA_AD_Agency,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    CN=TestMSA,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    CN=TestMSA123,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    -----------------------------------------------------------------------
    DistinguishedName      : CN=GMSA_AD_CYLONS,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    Enabled                : True
    Name                   : GMSA_AD_CYLONS
    ObjectClass            : msDS-GroupManagedServiceAccount
    ObjectGUID             : e036a9a8-2385-4f33-b818-819a255196cc
    SamAccountName         : GMSA_AD_CYLONS$
    SID                    : S-1-5-21-2778787315-2228761457-209862467-8609
    ...
    ...
#>  
#==============================  
[CmdletBinding()]
Param(
    [Parameter()]
    [bool[]]
    $writehost = $true # Don't want to writeout if called by other function
) # End Param-------------------------------


    # If installed, the info for a Managed Service Account can be retrieved
    # Get a list of all active Managed Service Accounts
    $timestamp = Get-Date -f 'yyyy-MM-dd-HHmmss'
    # Create file name/location
    # If running this MSAprogram/function, it assumes this location has already been installed,
    #   as it is automatically created when a user executes: 'InstallMSAFunctionsModule.ps1'
    # "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\ServiceAccounts\
    $SA_Report = "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\ServiceAccounts\allMSAs\all_ManagedServiceAccounts_$timestamp.txt"
    
    # Gather all MAnaged Service accounts on the AD, and save results to a file.
    $allMSAs = Get-ADServiceAccount -Filter *

    $allMSAs | Out-File $SA_Report

    # Display results to terminal also.
    Write-Host -ForegroundColor Yellow "`n`n`n---------------Active Directory Managed Service Accounts---------------`n"
    foreach ($MSA in $allMSAs) {

        Write-Host -ForegroundColor Green ("> $MSA `n")
        
    }
    Write-Host ("`n`n")
    
    #Get-Content $SA_Report
    Return $allMSAs
    

} #End Function Get-AllManagedServiceAccounts
#==============================
