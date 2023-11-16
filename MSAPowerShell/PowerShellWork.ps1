# Check the Domain
(Get-ADDomain).DNSRoot
# WidgetLLC.Internal

# Check if a root key exists. No return = no current root key
Get-KdsRootKey


# I created a user through AD Users and Computers
#Full name(One word including underscore): Twilight_Sparkle
#User logon name: twilight_sparkle@WidgetLLC.Internal
#PW = Simple pick@6


# Check what services currently exists
Services.msc


# You can create a service
# NOTE - THIS COMMAND ONLY WORKED IN CMD
Set-Content create "Carly is a UNICORN" binPath= "C:\Windows\notepad.exe"


# Now view the services, and see that one in there.
# Right click on "Carly is a UNICORN" --> Properties
# Click on the Log On tab
# Check 'This Account'
# Click 'Browse'
# 'From this location:'  --> Choose 'Entire Directory'
# Input the name of the target user --> twilight_sparkle --> Check Names
# Should recognize the name now -> OK
# Enter a Password --> Standard Pick@6
# Apply --> OK --> OK
# It should indicate that the use has been granted the Log on as a service right. --> OK
# Then go back to that sevice Properties, and change 'Startup Type' to 'Automatic' --> Apply --> OK


# Check on the permissions to HKEY_LOCAL_MACHNE\SECURITY
regedit.exe
# Right click on HKEY_LOCAL_MACHNE\SECURITY --> Permissions
<#
There are 2 current selections: SYSTEM; Administrators(WIDGETLLC\Administrators)
Under each, are the Permissions: Full Control; Read;
SYSTEM has both checked.
Administrators(WIDGETLLC\Administrators) has neither checked.
#>


# Open a new windows as a different executive user.
# This was done in CMD, and requires the tool to be installed first. 
# This will allow us to check twilight_sparkle's PW but is not required for anything else.
psexec.exe -s -i -d cmd.exe
<#
psexec tool to open another cmd window with specific permissions.
-s run as local system account which has permission to read Security
-i = interactive
-d = run in seperate window

In this new windows, whoami should get:   > nt authority\system
There is another tool, which you may need to download:  CQSecretDumper
#>
cqsecretdumper.exe /service "Carly is a UNICORN"
# IF installed, should return the PW in both hex and ascii
#
#
#
#
# Now for the GMSA
# Create a new sub-OU for GMSA and GMSA GSG
# GSG: Global Security Group
(Get-ADDomain).DNSRoot
#WidgetLLC.Internal

# Domain Controller components, and find the target OU from ADUC
# Example:   OU=itFlee, DC=WidgetLLC, DC=Internal
New-ADOrganizationalUnit -Name "GMSAs" -Path "OU=itFlee, DC=WidgetLLC, DC=Internal"
# Create Global Security Group for users/services to allow access the gMSA
$GMSA_Group = "GMSA_AD_Agency_USERS"
# New child Organizational Unit # NOTE the ``` mark line breaks. All one command.
New-ADGroup -Name $GMSA_Group -SamAccountName $GMSA_Group `
-GroupCategory Security -GroupScope Global -DisplayName $GMSA_Group `
-Path "OU=GMSAs, OU=itFlee, DC=WidgetLLC, DC=Internal" `
-Description "Global Security Group with access to GMSA --> GMSA_AD_Agency_USERS"


# Add computer accounts to GSG that will make use of the GMSA
# For members, adding the $ after the name indicates that it is a computer, not a user.
# Can add multiple members:  "DESKTOP-8ALRUCQ$", "comp2$", "comp3$";
Add-ADGroupMember "CN=GMSA_AD_Agency_USERS, OU=GMSAs, OU=itFlee, DC=WidgetLLC, DC=Internal" `
-Members "Client1111$"

Add-ADGroupMember "CN=GMSA_AD_Agency_USERS, OU=GMSAs, OU=itFlee, DC=WidgetLLC, DC=Internal" `
-Members "DC01$"

# To remove a member (Not Done Here)
Remove-ADGroupMember "CN=GMSA_AD_Agency_USERS, OU=GMSAs, OU=itFlee, DC=WidgetLLC, DC=Internal" `
-Members "DESKTOP-8ALRUCQ$"

# Create the KDS root key. From DC with Enterprise/Domain admin privs.
# With:  -EffectiveImmediately param, can still take up to 10 hours to apply itself. 
# Security Measure
# Line below allows a bypass 10 hour security delay
Add-KdsRootKey -EffectiveTime ((Get-Date).AddHours(-10))
#Add-KdsRootKey -EffectiveImmediately
# KDSRootKey Added:
#                   Guid                                
#                   dda800d2-13be-e7cc-bf4d-cb611600c148



# Test KDS root key. Views all active KdsRootKey's
Get-KdsRootKey
<#
...
...
...
AttributeOfWrongFormat : 
KeyValue               : {184, 233, 149, 201...}
EffectiveTime          : 2/2/2022 1:24:58 AM
CreationTime           : 2/2/2022 11:24:58 AM
IsFormatValid          : True
DomainController       : CN=DC01,OU=Domain Controllers,DC=WidgetLLC,DC=Internal
ServerConfiguration    : Microsoft.KeyDistributionService.Cmdlets.KdsServerConfiguration
KeyId                  : 44b46cef-5d05-10b6-2de5-05a3ba9e8392
VersionNumber          : 1
#>


Test-KdsRootKey -KeyId "dda800d2-13be-e7cc-bf4d-cb611600c148"
#True


# Create a GMSA account (SAM/NAME must be no more than 15 chars)
$GMSA_Name = "GMSA_AD_Agency"
$GMSA_Group = "GMSA_AD_Agency_USERS"
$GMSA_FQDN = "GMSA_AD_Agency.WidgetLLC.Internal" #Fully Qualified Domain Name
$GMSA_Servers = Get-ADGroupMember -Identity $GMSA_Group | Select-Object -ExpandProperty Name



$GMSA_Server_IDs = $GMSA_Servers | ForEach-Object {Get-ADComputer -Identity $_}
# NOTE the ``` mark line breaks. All one command.
New-ADServiceAccount -Name $GMSA_Name -Enabled $true `
-Description "AD Managed Service Acount for Agency Servers" `
-DisplayName $GMSA_Name -PrincipalsAllowedToRetrieveManagedPassword $GMSA_Server_IDs `
-DNSHostName $GMSA_FQDN

# There are no noticable results in the terminal.


# Verify GMSA Account
Get-ADServiceAccount $GMSA_Name
<#
    DistinguishedName : CN=GMSA_AD_Agency,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    Enabled           : True
    Name              : GMSA_AD_Agency
    ObjectClass       : msDS-GroupManagedServiceAccount
    ObjectGUID        : 8e963ff1-73f7-4706-a467-94c7e7485014
    SamAccountName    : GMSA_AD_Agency2$
    SID               : S-1-5-21-2778787315-2228761457-209862467-9112
    UserPrincipalName : 
#>

#Remove-ADServiceAccount $GMSA_Name


# Up to this point all actions have been done on the DC
# It was stated, but not tested, that if you have AD installed, if could be done on a Windows 10 connected machine

# Now go to the workstaion and install there, not the DC
Install-ADServiceAccount -Identity "GMSA_AD_Agency2"

<#
GSG = global security group.
The next step/example is to install GMSA on a computer
MSAs (not GMSAs) can only be active and linked to a single computer at one time.
If you attempt to install the same MSA account on another server, it will ask for confirmation.
It will then disable the MSA for the previous server.
So if you want to use MSAs for multiple servers, you need to create one for each server.
Otherwise, use a GMSA so you can use it with multiple servers by adding themto the GSG associated with it.
#>


# View the user and location
hostname
#DC01

whoami
#widgetllc\administrator

Get-ADUser "Nate Terry"
<#

DistinguishedName : CN=Nate Terry,OU=Office,OU=itFlee,DC=WidgetLLC,DC=Internal
Enabled           : True
GivenName         : Nate
Name              : Nate Terry
ObjectClass       : user
ObjectGUID        : 2672935d-fff2-4f22-a1ac-e07481af5b98
SamAccountName    : Nate Terry
SID               : S-1-5-21-2778787315-2228761457-209862467-1113
Surname           : Terry
UserPrincipalName : Nate.Terry@WidgetLLC.Internal
#>
