# Abusing  gMSA Passwords to Gain Elevated Access
<#---
----------------------------------------
----------------------------------------
----------------------------------------
gMSA - Group Managed Service Accounts
An Active Directory piece that can be used to run tasks, services, and apps, securely and through automation.
These accounts, significantly help with security by using automatically generated passwords that are large, 
automatically rotating, and will not be accessed directly by a user.

The information for any gMSA  is stored in the Active Directory.
The associated password is stored here as an attribute. This also shows who can query the password, the timeline 
for password rotation, and the IDs used to generate the passwords.

> msDS-ManagedPassword - a BLOB with the password for group-managed service accounts.
> msDS-ManagedPasswordID - the key ID used to generate the current gMSA password.
> msDS-ManagedPasswordPreviousID - the key ID used to generate the previous gMSA password.
> msDS-GroupMSAMembership - the list of objects that have permission to query the password for the gMSA
> msDS-ManagedPasswordInterval - the interval (days) in which the password is rotated for the gMSA

The password info will be stored in the attribute:  'msDS-ManagedPassword'
What users are able to query the password is in the attribute:  'msDS-GroupMSAMembership'

While it is listed as an 'attribute' since it is a part of the Active Directory, the associate AD permissions 
will be applied as well. If a user/object etc., is able query the password from the 'msDS-GroupMSAMembership' account, 
that user/object also needs to have the 'Read' permissions to the Group Managed Service Account itself, in particular,
the 'msDS-ManagedPassword' attribute. While this may seem inconvenient, it is a part of layered password security. 

The primary steps for an administrator:
1) Only vital objects should have permission to query the 'msDS-GroupMSAMembership' attribute.
2) On machines where the gMSA is installed, only administrators that may need access should have permissions to 
   read any password attributes.
3) Only administrators should have permission to modify gMSA attributes, to prevent any faulty additions 
   most notably to the 'msDS-GroupMSAMembership' attribute.

How to abuse a gMSA
As a service account, there are inherent privileges that are applied. It may be possible to gather the associated
password with a tool like Mimikatz, or deep queries in the Active Directory. If acquired, this would allow lateral 
AD movement.

If a service account has been compromised, even if the account is non-privileged in the Active Directory, this 
still implies a level of local administration on the local machine.


----------------------------------------
----------------------------------------
----------------------------------------
---#>

# gMSA Recon
# 1) Find out if a gMSA/s exist. (Shown 1, but all MSAs should also appear.)
Get-ADServiceAccount -Filter *
<#
        RunspaceId        : e8f08e24-9cbd-4bfb-93d2-a3d27eb0d416
        DistinguishedName : CN=GMSA_AD_CYLONS,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
        Enabled           : True
        Name              : GMSA_AD_CYLONS
        ObjectClass       : msDS-GroupManagedServiceAccount
        ObjectGUID        : e036a9a8-2385-4f33-b818-819a255196cc
        SamAccountName    : GMSA_AD_CYLONS$
        SID               : S-1-5-21-2778787315-2228761457-209862467-8609
        UserPrincipalName :
        ...
        ...
        ...
#>

# Identify users that have access to query gMSA passwords
Get-ADServiceAccount -Filter * -Properties PrincipalsAllowedToRetrieveManagedPassword
# We can see that 'Client111' has the ability query the password for this service account.
<#
        RunspaceId                                 : e8f08e24-9cbd-4bfb-93d2-a3d27eb0d416
        DistinguishedName                          : CN=GMSA_AD_CYLONS,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
        Enabled                                    : True
        Name                                       : GMSA_AD_CYLONS
        ObjectClass                                : msDS-GroupManagedServiceAccount
        ObjectGUID                                 : e036a9a8-2385-4f33-b818-819a255196cc
        PrincipalsAllowedToRetrieveManagedPassword : {CN=CLIENT111,CN=Computers,DC=WidgetLLC,DC=Internal}
        SamAccountName                             : GMSA_AD_CYLONS$
        SID                                        : S-1-5-21-2778787315-2228761457-209862467-860
        ...
        ...
        ...
#>

# Check to se if service accounts are members of any privileged groups.
Get-ADServiceAccount -Filter * -Properties memberof
# We can see that the 'GMSA_AD_CYLONS' service account is a member of the 'GMSA_CYLON_USERS' security group.
<#
        RunspaceId        : e8f08e24-9cbd-4bfb-93d2-a3d27eb0d416
        DistinguishedName : CN=GMSA_AD_CYLONS,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
        Enabled           : True
        MemberOf          : {CN=GMSA_CYLON_USERS,OU=GMSAs,OU=itFlee,DC=WidgetLLC,DC=Internal}
        Name              : GMSA_AD_CYLONS
        ObjectClass       : msDS-GroupManagedServiceAccount
        ObjectGUID        : e036a9a8-2385-4f33-b818-819a255196cc
        SamAccountName    : GMSA_AD_CYLONS$
        SID               : S-1-5-21-2778787315-2228761457-209862467-8609
        UserPrincipalName :
#>
