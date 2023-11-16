#==============================
Function Get-MSAPasswordInfo {  
<#
    .SYNOPSIS
    Gather the information and attributes about this Managed Service Account.
    Example:  Get-Help Get-MSAPasswordInfo -Examples

    .DESCRIPTION
    -targetMSA is a required parameters. You can get a list of service accounts with:
    > Get-OneServiceAccountName

    .Example
    Get-MSAPasswordInfo -targetMSA "TestMSA" -attributes "all"
    # Gather all attributes for a target Managed Service Account

    .Example
    Get-MSAPasswordInfo -targetMSA "TestMSA" -attributes "password"
    # Gather just password related attributes for a target Managed Service Account

    .OUTPUTS
    Password related attributes for Service Account: TestMSA
    -----------

    AccountExpirationDate                      :
    AllowReversiblePasswordEncryption          : False
    BadLogonCount                              : 0
    badPasswordTime                            : 0
    badPwdCount                                : 0
    CannotChangePassword                       : False
    createTimeStamp                            : 2/8/2022 9:56:10 AM
    DistinguishedName                          : CN=TestMSA,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    Enabled                                    : True
    KerberosEncryptionType                     : {RC4, AES128, AES256}
    LastBadPasswordAttempt                     :
    LastLogonDate                              : 3/9/2022 4:15:11 PM
    LockedOut                                  : False
    logonCount                                 : 20
    ManagedPasswordIntervalInDays              : {30}
    Name                                       : TestMSA
    ObjectClass                                : msDS-GroupManagedServiceAccount
    ObjectGUID                                 : 850ad035-f87e-4846-b6bf-403235381858
    PasswordExpired                            : False
    PasswordLastSet                            : 2/8/2022 9:56:10 AM
    PasswordNeverExpires                       : False
    PasswordNotRequired                        : False
    PrincipalsAllowedToDelegateToAccount       : {}
    PrincipalsAllowedToRetrieveManagedPassword : {S-1-5-21-2778787315-2228761457-209862467-8605}
    ProtectedFromAccidentalDeletion            : False
    pwdLastSet                                 : 132888057700882186
    SamAccountName                             : TestMSA$
    SID                                        : S-1-5-21-2778787315-2228761457-209862467-8625
    UserPrincipalName                          :


    .OUTPUTS
    ---------------------
    Full MSA Attributes :
    -----------

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
#==============================  
[CmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [string]
    $targetMSA,

    [Parameter()]
    [string]
    $attributes
) # End Param-------------------------------

    $targetMSA = $targetMSA -replace '\s', ''       #In case user enter spaces
    $attributes = $attributes -replace '\s', ''     #In case user enter spaces
    $attributes = $attributes.ToLower()             #In case user uses any capitol letters.

    If ($attributes -eq "all") {

        Write-Host -ForegroundColor Yellow ("`n`nAll Attributes for Service Account: $targetMSA `n-----------")
        $results = Get-ADServiceAccount -Identity $targetMSA -Properties *
        return $results
        

    } else {
        Write-Host -ForegroundColor Yellow ("`n`nPassword Attributes for Service Account: $targetMSA `n-----------")
        $results = Get-ADServiceAccount -Identity $targetMSA -Properties "AccountExpirationDate", "AllowReversiblePasswordEncryption", "BadLogonCount", "badPasswordTime", "badPwdCount", "CannotChangePassword", "createTimeStamp", "KerberosEncryptionType", "LastBadPasswordAttempt", "LastLogonDate", "LockedOut", "logonCount", "ManagedPasswordIntervalInDays", "PasswordExpired", "PasswordLastSet", "PasswordNeverExpires", "PasswordNotRequired", "PrincipalsAllowedToDelegateToAccount", "PrincipalsAllowedToRetrieveManagedPassword", "ProtectedFromAccidentalDeletion", "pwdLastSet"
        return $results
        
    }#End If/Else
    

} #End Function Get-MSAPasswordInfo
#==============================
