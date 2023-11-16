#==============================
Function Get-MSApermissions {  
<#
    .SYNOPSIS
    Gather the Managed Service Accounts that are associated with the Active Directory 
    as well the AD Identities, for example: 'BUILTIN\Administrators'  and view the permissions
    that each AD Identity has in regards to each Managed Service Account.  

    .DESCRIPTION
    Need: 
        Active Directory for PowerShell
        Admin privileges or the Domain in order gather attribute GUIDs and gMSA permissions.
        The focus is to look up permissions in the Active Directory for an Organizational Unit.
        This will allow viewing of who has what access to Managed Service Accounts

    .Example
    Get-MSApermissions -targetMSA "all"

    .Example
    Get-MSApermissions -targetMSA $TestMSA

    .OUTPUTS
    TestMSA123  IdentityReference                                       ActiveDirectoryRights
    ----------  -----------------                                       ---------------------
                Everyone                                                GenericAll
                NT AUTHORITY\Authenticated Users                        GenericAll
                NT AUTHORITY\SYSTEM                                     GenericAll
                BUILTIN\Administrators                                  GenericAll
                BUILTIN\Account Operators                               GenericAll
                WIDGETLLC\Domain Admins                                 GenericAll
                WIDGETLLC\Enterprise Key Admins                         GenericAll
                NT AUTHORITY\SELF                                       ReadProperty, WriteProperty
                NT AUTHORITY\SELF                                       Self
                NT AUTHORITY\SELF                                       Self
                BUILTIN\Windows Authorization Access Group              ReadProperty
                WIDGETLLC\Cert Publishers                               ReadProperty, WriteProperty
                BUILTIN\Pre-Windows 2000 Compatible Access              ReadProperty
#>  
#==============================  
[CmdletBinding()]
Param(
    [Parameter()]
    [string]
    $targetMSA # Default to all Service Accounts
) # End Param-------------------------------


    $targetMSA = $targetMSA.ToLower()               # In case user uses any capitol letters
    If ($targetMSA -eq "") {$targetMSA = "all"}     # No entry defaults to all 

    Import-Module ActiveDirectory
    # Gather GUID for attributes on: (such as) 'ms-md-AdmPwd'
    $schemaIDGUID = @{}
    $timestamp = Get-Date -f 'yyyy-MM-dd-HHmmss'
    # Create file name/location
    # If running this MSAprogram/function, it assumes this location has already been installed,
    #   as it is automatically created when a user executes: 'InstallMSAFunctionsModule.ps1'
    # "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\ServiceAccounts\
    $tempFile = "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\ServiceAccounts\tempMsaPermissions.txt"
    $SA_Report = "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\ServiceAccounts\msaPermissions\msaPermissions_$timestamp.txt"
    # Gather all MAnaged Service accounts on the AD, and save results to a file.
    $allMSAs = Get-ADServiceAccount -Filter *
    $allMSAs | Out-File $SA_Report

    # Location for MSA data, and the SA results file.
    # This is a default system location:  C:\Program Files\WindowsPowerShell\Modules\
    # Checking if the MSAFunctionsModule has been run
    # If not, create the directory for the results.
    $directory1 = "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\"
    $directory2 = "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\ServiceAccounts\"
    $directory3 = "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\ServiceAccounts\msaPermissions\"
    $timestamp = Get-Date -f 'yyyy-MM-dd-HHmmss'
    $SA_Report = $directory3 + "msaPermissions_$timestamp.txt"
    
    If (!(Test-Path -Path $directory1)){
        New-Item -ItemType Directory $directory1
        New-Item -ItemType Directory $directory2
        New-Item -ItemType Directory $directory3
        New-Item -ItemType File $SA_Report

    } elseIf (!(Test-Path -Path $directory2)) {
        New-Item -ItemType Directory $directory2
        New-Item -ItemType Directory $directory3
        New-Item -ItemType File $SA_Report

    } elseIf (!(Test-Path -Path $directory3)) {
        New-Item -ItemType Directory $directory3
        New-Item -ItemType File $SA_Report

    } elseIf (!(Test-Path -Path $SA_Report)) {
        New-Item -ItemType File $SA_Report

    } else {
        Remove-Item -Path $SA_Report
        New-Item -ItemType File $SA_Report
    }#End If/Elsee



    #-----------------Start
    # name=ms-ds-GroupMSAMembership
    # --> This attribute checks to determine if requestor has permission to retrieve the password info for a gMSA
    Get-ADObject -SearchBase (Get-ADRootDSE).schemaNamingContext -LDAPFilter '(name=ms-ds-GroupMSAMembership)' -Properties name, schemaIDGUID | ForEach-Object {$schemaIDGUID.Add([System.Guid]$_.schemaIDGUID, $_.name)}
    #-----------------End

    

    # If user sends in 1 target MSA
    If ($targetMSA -ne "all") {
           
        $gmsa = Get-ADServiceAccount $targetMSA

        # Connect PowerShell location to the Active Directory
        Set-Location AD:

        # Print MSA permission to the PowerShell Terminal
        (Get-Acl $gmsa.distinguishedname).access | Where-Object {(($_.AccessControlType -eq 'Allow') -and (($_.ActiveDirectoryRights -like '*')))} | Format-Table ([string]$gmsa.name), IdentityReference, ActiveDirectoryRights, ObjectType, IsInherited -AutoSize 

        # Sent MSA permissions to a results file
        # Add to tempfile, then pull temp file data into a growing results file. 
        # Ineffecient, but otherwise there will be formatting errors with the final results file. 
        (Get-Acl $gmsa.distinguishedname).access | Where-Object {(($_.AccessControlType -eq 'Allow') -and (($_.ActiveDirectoryRights -like '*')))} | Format-Table ([string]$gmsa.name), IdentityReference, ActiveDirectoryRights, ObjectType, IsInherited -AutoSize | Out-File $tempFile

        # Round-about way to add all results to a single file, but otherwise there are formatting errors.
        # Grab info each loop, and add that to the final report
        Add-Content -Path $SA_Report -Value "************************"
        Add-Content -Path $SA_Report -Value ("Managed Service Account: " + $gmsa.name)
        Add-Content -Path $SA_Report -Value "Permissions:"
        Get-Content -Path $tempFile | Add-Content -Path $SA_Report

    # Or else gather permissions for all MSAs
    } else {

        # Get all managed service accounts
        $gMSAs = Get-ADServiceAccount -Filter *
        $num = 0

        # Connect PowerShell location to the Active Directory
        Set-Location AD:   
       
        # Get objects that have specific permissions on the target(s) Managed Service Accounts
        Foreach ($gmsa in $gMSAs) {

            Write-Host -ForegroundColor Yellow ("Managed Service Account: `n" + $gMSAs[$num].name)

            # Print MSA permission to the PowerShell Terminal
            (Get-Acl $gMSAs[$num].distinguishedname).access | Where-Object {(($_.AccessControlType -eq 'Allow') -and (($_.ActiveDirectoryRights -like '*')))} | Format-Table ([string]$gMSAs[$num].name), IdentityReference, ActiveDirectoryRights, ObjectType, IsInherited -AutoSize 

            # Sent MSA permissions to a results file
            # Add to tempfile, then pull temp file data into a growing results file. 
            # Ineffecient, but otherwise there will be formatting errors with the final results file. 
            (Get-Acl $gMSAs[$num].distinguishedname).access | Where-Object {(($_.AccessControlType -eq 'Allow') -and (($_.ActiveDirectoryRights -like '*')))} | Format-Table ([string]$gMSAs[$num].name), IdentityReference, ActiveDirectoryRights, ObjectType, IsInherited -AutoSize | Out-File $tempFile

            # Round-about way to add all results to a single file, but otherwise there are formatting errors.
            # Grab info each loop, and add that to the final report
            Add-Content -Path $SA_Report -Value "************************"
            Add-Content -Path $SA_Report -Value ("Managed Service Account: " + $gMSAs[$num].name)
            Add-Content -Path $SA_Report -Value "Permissions:"
            Get-Content -Path $tempFile | Add-Content -Path $SA_Report

            $num++

        }#EndForeach
    }#End If/Else

    # Delete the temp file
    Remove-Item $tempFile
    # Exit out of 'AD' and go back to 'C'
    Set-Location C: 
    

} #End Function Get-MSApermissions
#==============================
