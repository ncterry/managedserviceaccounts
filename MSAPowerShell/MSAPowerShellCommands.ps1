# Get Service Account info

# Get the entire info list for a Service Account
Get-ADServiceAccount -Identity <name> -Properties *
Get-ADServiceAccount -Identity TestMSA -Properties *


<#
FULL LIST EXAMPLE
PS C:\Users\Administrator> Get-ADServiceAccount -Identity gMSAtest -Properties *

AccountExpirationDate                      : 
accountExpires                             : 9223372036854775807
AccountLockoutTime                         : 
AccountNotDelegated                        : False
AllowReversiblePasswordEncryption          : False
AuthenticationPolicy                       : {}
AuthenticationPolicySilo                   : {}
BadLogonCount                              : 0
badPasswordTime                            : 132877736708646414
badPwdCount                                : 0
CannotChangePassword                       : False
CanonicalName                              : WidgetLLC.Internal/Managed Service Accounts/gMSAtest
Certificates                               : {}
CN                                         : gMSAtest
codePage                                   : 0
CompoundIdentitySupported                  : {False}
countryCode                                : 0
Created                                    : 1/27/2022 9:59:08 AM
createTimeStamp                            : 1/27/2022 9:59:08 AM
Deleted                                    : 
Description                                : 
DisplayName                                : 
DistinguishedName                          : CN=gMSAtest,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
DNSHostName                                : gMSAtest.widgetllc.internal
DoesNotRequirePreAuth                      : False
dSCorePropagationData                      : {12/31/1600 7:00:00 PM}
Enabled                                    : True
HomedirRequired                            : False
HomePage                                   : 
HostComputers                              : {}
instanceType                               : 4
isCriticalSystemObject                     : False
isDeleted                                  : 
KerberosEncryptionType                     : {RC4, AES128, AES256}
LastBadPasswordAttempt                     : 1/27/2022 11:14:30 AM
LastKnownParent                            : 
lastLogoff                                 : 0
lastLogon                                  : 132878626216847429
LastLogonDate                              : 1/27/2022 11:50:00 AM
lastLogonTimestamp                         : 132877758000274120
localPolicyFlags                           : 0
LockedOut                                  : False
logonCount                                 : 4
ManagedPasswordIntervalInDays              : {30}
MemberOf                                   : {}
MNSLogonAccount                            : False
Modified                                   : 1/27/2022 11:50:00 AM
modifyTimeStamp                            : 1/27/2022 11:50:00 AM
msDS-GroupMSAMembership                    : System.DirectoryServices.ActiveDirectorySecurity
msDS-ManagedPasswordId                     : {1, 0, 0, 0...}
msDS-ManagedPasswordInterval               : 30
msDS-SupportedEncryptionTypes              : 28
msDS-User-Account-Control-Computed         : 0
Name                                       : gMSAtest
nTSecurityDescriptor                       : System.DirectoryServices.ActiveDirectorySecurity
ObjectCategory                             : CN=ms-DS-Group-Managed-Service-Account,CN=Schema,CN=Configuration,DC=WidgetLLC,
                                             DC=Internal
ObjectClass                                : msDS-GroupManagedServiceAccount
ObjectGUID                                 : 2535e160-fb9b-4408-ad71-810605474374
objectSid                                  : S-1-5-21-2778787315-2228761457-209862467-8613
PasswordExpired                            : False
PasswordLastSet                            : 1/27/2022 9:59:08 AM
PasswordNeverExpires                       : False
PasswordNotRequired                        : False
PrimaryGroup                               : CN=Domain Computers,CN=Users,DC=WidgetLLC,DC=Internal
primaryGroupID                             : 515
PrincipalsAllowedToDelegateToAccount       : {}
PrincipalsAllowedToRetrieveManagedPassword : {CN=gMSA-test,OU=SecurityGroups,DC=WidgetLLC,DC=Internal}
ProtectedFromAccidentalDeletion            : False
pwdLastSet                                 : 132877691481673518
SamAccountName                             : gMSAtest$
sAMAccountType                             : 805306369
sDRightsEffective                          : 15
servicePrincipalName                       : {http/gMSAtest/widgetllc, http/gMSAtes/widgetllc.internal, 
                                             http/gMSAest.widgetllc.internal.widgetllc, 
                                             http/gMSAtest.widgetllc.internal/widgetllc.internal}
ServicePrincipalNames                      : {http/gMSAtest/widgetllc, http/gMSAtes/widgetllc.internal, 
                                             http/gMSAest.widgetllc.internal.widgetllc, 
                                             http/gMSAtest.widgetllc.internal/widgetllc.internal}
SID                                        : S-1-5-21-2778787315-2228761457-209862467-8613
SIDHistory                                 : {}
TrustedForDelegation                       : False
TrustedToAuthForDelegation                 : False
UseDESKeyOnly                              : False
userAccountControl                         : 4096
userCertificate                            : {}
UserPrincipalName                          : 
uSNChanged                                 : 290939
uSNCreated                                 : 282736
whenChanged                                : 1/27/2022 11:50:00 AM
whenCreated                                : 1/27/2022 9:59:08 AM
#>



# Get the distinguished name for a Service Account
Get-ADServiceAccount -Identity gMSAtest | Select-Object -Property DistinguishedName
# DistinguishedName : CN=gMSAtest,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
<#
DistinguishedName                                               
-----------------                                               
CN=gMSAtest,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
#>




# ------------------------------
# Get list of all Managed Service Accounts
# Location in current domain: WidgetLLC.Internal/Managed Service Accounts
Get-ADServiceAccount -Filter *
<#
DistinguishedName : CN=GMSA_AD_CYLONS,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
Enabled           : True
Name              : GMSA_AD_CYLONS
ObjectClass       : msDS-GroupManagedServiceAccount
ObjectGUID        : e036a9a8-2385-4f33-b818-819a255196cc
SamAccountName    : GMSA_AD_CYLONS$
SID               : S-1-5-21-2778787315-2228761457-209862467-8609
UserPrincipalName : 

DistinguishedName : CN=gMSAtest,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
Enabled           : True
Name              : gMSAtest
ObjectClass       : msDS-GroupManagedServiceAccount
ObjectGUID        : 2535e160-fb9b-4408-ad71-810605474374
SamAccountName    : gMSAtest$
SID               : S-1-5-21-2778787315-2228761457-209862467-8613
UserPrincipalName : 
#>




Get-ADServiceAccount -Filter * | Select-Object -Property Name
<#
Name          
----          
GMSA_AD_CYLONS
gMSAtest  
#>

