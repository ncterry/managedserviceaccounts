# Several tools/commands need the machines to have RSAT (module)tools intalled in the active PowerShell.
<#--------------------------------------------
On the Domain Controller (As of 2022)
Server Manager >> Manage >> Add Roles and Features >> Next >> Next >> Next >> Next >> Features

Expand:   '.NET Framework 4.6 Features'
>>>>>> Check: '.NET Framework 4.6' 
Expand:   'Remote Server Administration Tools'
Expand:   'AD DS and AD LDS Tools'
>>>>>> Check: 'Active Directory Module for Windows PowerShell'
Expand:   'AD DS Tools'
>>>>>> Check: 'Active Directory Adminstrative Center'
>>>>>> Check: 'AD DS Snap-Ins and Command-Line Tools'

Next >> Install >> Restart Server after installation of services.
----------------------------------------------#>

Import Module ActiveDirectory
# A key distribution services root key needs to be created for the domain.
# It is stated that a system can really only have 1 root key.
# A root key created after another, would replace the first, not be-another.
Add-KdsRootKey -EffectiveTime ((Get-Date).AddHours(-10))

# Create a Managed Service Account in a default location, in the local domain.
# Gather the host, and the Domain Controller target domain.
hostname # EX: DC01

(Get-ADDomain).DNSRoot #EX: WidgetLLC.Internal

# NOTE: Includes ` (Line Breaks) - All One Command
New-ADServiceAccount -Name TestMSA456 `
-Path "CN=Managed Service Accounts, DC=WidgetLLC, DC=Internal" `
-DNSHostName "DC01.WidgetLLC.Internal" `
-Enabled $true

# MSA created through the Domain Controller.
# Now associate the MSA with a target machine i.e. Computer with it's Domain title.
# Allows the target machine to request and access via the MSA password.
# 'CLIENT1111' is the name of the target machine. INCLUDE a $ after a target machine.
Set-ADServiceAccount -Identity TestMSA456 -PrincipalsAllowedToRetrieveManagedPassword DC01$
# You need to restart the server for any further work with this MSA

# Test if MSA is accessable. The MSA can be created from the Domain Controller
# BUT this test should only return True if run in the Client machine itself.
Test-ADServiceAccount -Identity TestMSA456 | Format-List # True/False

# Test = True, from Client machine. Now Install the MSA on the target machine.
Install-ADServiceAccount -Identity TestMSA456

# Get list of all MSAs
Get-ADServiceAccount -Filter * 

# Get info for a target MSA
Get-ADServiceAccount TestMSA456
<#
    DistinguishedName : CN=TestMSAx,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    Enabled           : True
    Name              : TestMSAx
    ObjectClass       : msDS-GroupManagedServiceAccount
    ObjectGUID        : 184ad9fe-8c74-47c6-9982-b20beaabf44c
    SamAccountName    : TestMSAx$
    SID               : S-1-5-21-2778787315-2228761457-209862467-9106
    UserPrincipalName : 
#>
#
# The information/MSA can also be accessed in a User Interface by:
# > Run --> dsa.msc --> 'the target domain' --> Managed Service Accounts.
#------------------------------------------------------------------------


# Add a Service to a Managed Service Account
<#
A service account is a user account that is created to run a particular service or software. 
For security, a service account should be created for every service/app on the network.
This may be inefficient as every password would need to be managed for every service.
A Managed Service Account
- No password management
- Has a complex, random, 240-Character password.
- Changes automatically across the domain when needed. 

sMSA - Standalone MSA - The MSA properties as stated, but only applied to one machine.
gMSA - Group MSA - The MSA properties as stated, but can be applied to multiple machines. 
#>


# An MSA has been created already, now create/attach a service to that account
New-Service -Name TestMSAservice456 -BinaryPathName "C:\Windows\notepad.exe"


#OR, get more detailed.
#--------------
# Create a hashtable with Service parameters
$params = @{
    Name = "TestMSAservice789"
    BinaryPathName = "C:\Windows\notepad.exe"
    DependsOn = "NetLogon"
    DisplayName = "TestMSAservice789"
    StartupType = "Manual"
    Description = "This is a test service for a Managed Service Account"
}#End $params
#--------------

# Now create a service with those parameters.
New-Service @params


# Once created, this can now be viewed in 2 ways:
# Run --> Services.msc
# This is where it should be started/stopped/refreshed.
# Or it can be found in the Registry, which is the only location it can be deleted from.
#       HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TestMSAservice2
#--------------


# To remove a target MSA
Remove-ADServiceAccount "TestMSAx"



# dca.msc - active directory users and computers
# services.msc - services

Import-Module ActiveDirectory
New-ADServiceAccount -Name AskDS -Enabled $true