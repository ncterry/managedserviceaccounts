<#
NEED: 
1) Active Directory for PowerShell
2) Admin privileges for the Domain in order to gather attribute GUIDs and gMSA permissions

To Do:
Look up permissions in the Active Directory for a target Organizational Unit 
This will allow viewing of possible access to an object-attributes.
Applies primarily to LAPS:
    'Local Administrator Password Solution'


#>



Import-Module ActiveDirectory

# Gather GUID for attributes on: (such as) 'ms-md-AdmPwd'
$schemaIDGUID = @{}



# Contains ``` line break marks. All one command
#-----------------Start
# name=ms-ds-GroupMSAMembership
# --> This attribute for checks to determine if requestor has permission to retrieve the password for a gMSA
Get-ADObject -SearchBase (Get-ADRootDSE).schemaNamingContext `
-LDAPFilter '(name=ms-ds-GroupMSAMembership)' `
-Properties name, schemaIDGUID | `
ForEach-Object {$schemaIDGUID.Add([System.Guid]$_.schemaIDGUID, $_.name)}
#-----------------End


#Write-host ($schemaIDGUID) #Does not write
#Write-Host ($schemaIDGUID.Name) #Does not write

$schemaIDGUID
<#  Name                           Value                                                                                    
    ----                           -----                                                                                    
    888eedd6-ce04-df40-b462-b8a... ms-DS-GroupMSAMembership
#>

$schemaIDGUID.Keys[0].GUID 
#888eedd6-ce04-df40-b462-b8a50e41ba38

$schemaIDGUID.Keys
<#Guid                                
  ----                                
  888eedd6-ce04-df40-b462-b8a50e41ba38
#>

$schemaIDGUID.Values 
#ms-DS-GroupMSAMembership

$schemaIDGUID.Count  
#1



# Get all managed service accounts
$gMSAs = Get-ADServiceAccount -Filter *
$gMSAs
<#
        DistinguishedName : CN=TestMSA123,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
        Enabled           : True
        Name              : TestMSA123
        ObjectClass       : msDS-GroupManagedServiceAccount
        ObjectGUID        : 0b075106-6a46-4f63-98d0-f36a6483eea4
        SamAccountName    : TestMSA123$
        SID               : S-1-5-21-2778787315-2228761457-209862467-8626
        UserPrincipalName :
#>



# Or get one machine, or one service account.
# Tailor to target machine
# Get the distinquishedName of the target device
#$target = 'CN=CLIENT111, CN=Computers, DC=WidgetLLC, DC=Internal'

# Declare the samaccountname of the gMSA to search for.
#$target = 'GMSA_AD_CYLONS' #Works
#$target = "TestMSA123"

# Apply single target to get the service account information.
#$gMSAs = Get-ADServiceAccount -Identity $target
#$gMSAs
<#
        DistinguishedName : CN=TestMSA123,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
        Enabled           : True
        Name              : TestMSA123
        ObjectClass       : msDS-GroupManagedServiceAccount
        ObjectGUID        : 0b075106-6a46-4f63-98d0-f36a6483eea4
        SamAccountName    : TestMSA123$
        SID               : S-1-5-21-2778787315-2228761457-209862467-8626
        UserPrincipalName :
#>




#$computers = Get-ADComputer -SearchBase $target -Filter {name -like '*'}
#$computers
<#
        DistinguishedName : CN=CLIENT111,CN=Computers,DC=WidgetLLC,DC=Internal
        DNSHostName       : Client111.WidgetLLC.Internal
        Enabled           : True
        Name              : CLIENT111
        ObjectClass       : computer
        ObjectGUID        : 124d5649-2ccc-4033-8b7e-21a91ec61258
        SamAccountName    : CLIENT111$
        SID               : S-1-5-21-2778787315-2228761457-209862467-8605
        UserPrincipalName : 
#>






# Gather objects that have permissions on the target.
#---Full control
#---Read properties
#---Write properties
# Connect PowerShell location to the Active Directory
Set-Location ad:
#
# Contains ``` line break marks. All one command
#-----------------Start

Foreach($gmsa in $gMSAs){ 
(Get-Acl $gmsa.distinguishedName).Access | 
Where-Object { (($_.AccessControlType -eq 'Allow') `
-and ($_.ActiveDirectoryRights -in ('GenericAll') `
-and $_.InheritanceType -in ('All', 'None')) `
-or (($_.ActiveDirectoryRights -like '*WriteProperty*') `
-and ($_.ObjectType -eq '888eedd6-ce04-df40-b462-b8a50e41ba38')))} | 
Format-Table ([string]$gmsa.name), IdentityReference, ActiveDirectoryRights, ObjectType, IsInherited -AutoSize
}#EndForeach
#-----------------End
# Returns info like this for all associated Managed Service Accounts
<#
TestMSA123 IdentityReference                ActiveDirectoryRights ObjectType                           IsInherited
---------- -----------------                --------------------- ----------                           -----------
           Everyone                                    GenericAll 00000000-0000-0000-0000-000000000000       False
           NT AUTHORITY\Authenticated Users            GenericAll 00000000-0000-0000-0000-000000000000       False
           NT AUTHORITY\SYSTEM                         GenericAll 00000000-0000-0000-0000-000000000000       False
           BUILTIN\Administrators                      GenericAll 00000000-0000-0000-0000-000000000000       False
           BUILTIN\Account Operators                   GenericAll 00000000-0000-0000-0000-000000000000       False
           WIDGETLLC\Domain Admins                     GenericAll 00000000-0000-0000-0000-000000000000       False
           WIDGETLLC\Enterprise Key Admins             GenericAll 00000000-0000-0000-0000-000000000000       False
           WIDGETLLC\Enterprise Admins                 GenericAll 00000000-0000-0000-0000-000000000000        True
#>




# Get objects that have specific permission sonthe target(s) and specifically the gMSA attribute: WriteProperty
# Connect PowerShell location to the Active Directory
Set-Location ad:
#
# Contains ``` line break marks. All one command
# This only grabs those Security Properties (objects) that All priviliges for this gMSA
# Can see thes objects by:
# Active Directory Users and Computers >> WidgetLLC.Internal >> Manged Service Accounts
# >> Right click on TestMSA123 >> Properties >> Security Tab >> Groups or user names >>
# >>>>>The objects here that have GenericAll (all permissions to access/edit this gMSA)
# >>>>>>>>Click on that object >> Go below to 'Permissions for Creator Owner'
# >>>>>>>>Since this object is set to 'GenericAll' then all of these boxes under 'Allow' will be checked. 
#-----------------Start
Foreach ($gmsa in $gMSAs) {
(Get-Acl $gmsa.distinguishedname).access | 
Where-Object {(($_.AccessControlType -eq 'Allow') `
-and (($_.ActiveDirectoryRights -like 'GenericAll')))} |
Format-Table ([string]$gmsa.name), IdentityReference, ActiveDirectoryRights, ObjectType, IsInherited -AutoSize 
}#EndForeach
#-----------------End
<#
TestMSA123 IdentityReference                ActiveDirectoryRights ObjectType                           IsInherited
---------- -----------------                --------------------- ----------                           -----------
           Everyone                                    GenericAll 00000000-0000-0000-0000-000000000000       False
           NT AUTHORITY\Authenticated Users            GenericAll 00000000-0000-0000-0000-000000000000       False
           NT AUTHORITY\SYSTEM                         GenericAll 00000000-0000-0000-0000-000000000000       False
           BUILTIN\Administrators                      GenericAll 00000000-0000-0000-0000-000000000000       False
           BUILTIN\Account Operators                   GenericAll 00000000-0000-0000-0000-000000000000       False
           WIDGETLLC\Domain Admins                     GenericAll 00000000-0000-0000-0000-000000000000       False
           WIDGETLLC\Enterprise Key Admins             GenericAll 00000000-0000-0000-0000-000000000000       False
           WIDGETLLC\Enterprise Admins                 GenericAll 00000000-0000-0000-0000-000000000000        True
#>


# Same as above except:     ActiveDirectoryRights --> changed to *(all) 
Foreach ($gmsa in $gMSAs) {
(Get-Acl $gmsa.distinguishedname).access | 
Where-Object {(($_.AccessControlType -eq 'Allow') `
-and (($_.ActiveDirectoryRights -like '*')))} |
Format-Table ([string]$gmsa.name), IdentityReference, ActiveDirectoryRights, ObjectType, IsInherited -AutoSize 
}#EndForeach
<#
TestMSA123 IdentityReference                                       ActiveDirectoryRights
---------- -----------------                                       ---------------------
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
           BUILTIN\Pre-Windows 2000 Compatible Access              ReadProperty
           BUILTIN\Pre-Windows 2000 Compatible Access              ReadProperty
           BUILTIN\Pre-Windows 2000 Compatible Access              ReadProperty
           BUILTIN\Pre-Windows 2000 Compatible Access              ReadProperty
           BUILTIN\Pre-Windows 2000 Compatible Access              ReadProperty
           BUILTIN\Pre-Windows 2000 Compatible Access              ReadProperty
           BUILTIN\Pre-Windows 2000 Compatible Access              ReadProperty
           BUILTIN\Pre-Windows 2000 Compatible Access              ReadProperty
           BUILTIN\Pre-Windows 2000 Compatible Access              ReadProperty
           WIDGETLLC\Key Admins                                    ReadProperty, WriteProperty
           WIDGETLLC\Enterprise Key Admins                         ReadProperty, WriteProperty
           CREATOR OWNER                                           Self
           NT AUTHORITY\SELF                                       Self
           NT AUTHORITY\ENTERPRISE DOMAIN CONTROLLERS              ReadProperty
           NT AUTHORITY\ENTERPRISE DOMAIN CONTROLLERS              ReadProperty
           NT AUTHORITY\ENTERPRISE DOMAIN CONTROLLERS              ReadProperty
           NT AUTHORITY\SELF                                       WriteProperty
           BUILTIN\Pre-Windows 2000 Compatible Access              GenericRead
           BUILTIN\Pre-Windows 2000 Compatible Access              GenericRead
           BUILTIN\Pre-Windows 2000 Compatible Access              GenericRead
           NT AUTHORITY\SELF                                       ReadProperty, WriteProperty
           NT AUTHORITY\SELF                                       ReadProperty, WriteProperty, ExtendedRight
           WIDGETLLC\Enterprise Admins                             GenericAll
           BUILTIN\Pre-Windows 2000 Compatible Access              ListChildren
           BUILTIN\Administrators                     ...erty, ExtendedRight, Delete, GenericRead, WriteDacl, WriteOwner

#>








# Was in there but all of the ObjectType are all 0's but the keys are the official key 
#-and ($_.ObjectType -in $schemaIDGUID.Keys)))} |
# 00000000-0000-0000-0000-000000000000    vs     $schemaIDGUID.Keys[0].GUID #888eedd6-ce04-df40-b462-b8a50e41ba38
# Return PowerShell location to C:
Set-Location C:
