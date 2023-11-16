# gMSA Manual Setup Instructions

<#
> What is a gMSA
> Create a gMSA on a DC
> Use gMSA to install SQL on a local SQL server
> Use gMSA to set up task scheduler that will open Notepad on a local client machine.

This setup is manual, by a user through AD/Registry etc.
MSA - Managed Service Accounts
gMSA - Group Managed Service Accounts


Group managed service accounts are managed domain accounts that you use to help secure services. 
gMSAs can run on a single server, or on a server farm, such as a sstems behind a network load balancing or
Internet Information Services (IIS) server.


Managed Service Accounts have an automatically managed, complex password that removes the requirement of 
manually dealing with password rotation and security.


An MSA can be used on only one computer in a domain.
Click on the container in Active Directory where gMSAs are created by default.


Benefits of Managed Service Accounts:
> Automatic password management.
> Simplified service principle name (SPN) management.
> Cannot be used to interactively log into Windows
> Easily control which computers are authorized to authenticate MSAs and run code in their context.


A service account is a user account that is created explicity to provide a security context for services 
that are running on Windows Server Operating systems. The security context determnes the service's ability 
to access local and network resources. The Windows OS's rely on services to run various features.


Can a gMSA be a domain admin?
 - Running the AD PowerShell cmdlet Get-ADServiceAccount, we can retrieve information about the gMSA,
 including specific gMSA attributes. (EX) This gMSA is a member of the domain Administrators group which has full
 AD and DC admin rights to the domain. 


 Group Managed Service Accounts became available starting with Windows Server 2012. 
 - Nobody knows the password for the MSAs/gMSAs.
 - gMSAs can be shared by more than one computer, hence the name 'group'.
 - The password is managed by AD so computers that are members of a group can use the service account.


 A computer manages an sMSA
 A Domain Controller manages a gMSA


 The password for a gMSA is managed by the DC
 DC's require a root-key to generate passwords for a gMSA
 There are built in time-constraints from when a DC creates a key, and when it can be applied.
 - This is a security measure so that a gMSA cannot be abused, and that it can be accessed by all needed domain objects.
 - If you have numerous machines connected, this key will not be distributed immediately.
 - You can cheat and create a key with a start time of 10 hours ago that will be effective immediately.
    
    > Add-KdsRootKey -EffectiveTime ((Get-Date).addhours(-10))


KDS root keys are stored in an Active Directory container:
> "CN=Master Root Keys, CN=Group Key Distribution, CN=Services, CN=Configuration, DC="


They have an attribute 'msKds-DomainID' that links to the computer account of the Domain Controller that created
the object. When this domain controller is demoted and removed from the domain, the value will refer to the tombstone
of the computer account. You can ignore the broken value as it is only used to help the administrator track the object
when it is freshly created. You may also change the attribute value and point it to the computer object of another
domain controller in your forest.


- Create a security group in the AD
--Active Directory Users and Computers
---Expand the target Domain
---Create a new Organizational Unit --> 'Action'(menu option) --> 'New' --> 'Organizational Unit'
---Name that new Organizaitonal Unit: 'SecurityGroups'
----Right click on 'SecurityGroups'
-----Select: New --> Group
------Give a 'Group name' --> 'gMSA-test'
------Select 'Group scope' --> Default to 'Domain local'
------Select 'Group type' --> Default to 'Security'
-------OK
-------Once created, in 'SecurityGroups', right-click 'gMSA-test' --> Properties
--------Click Members Tab --> Add
--------These additions should be machines that are already in the domain.
--------'Enter the object names to select' --> We gave this 'tus-sql1' --> Click OK
---------IF 'Name Not Found' window --> Click 'Object Types'
---------Check: 'Other Objects', 'Service Accounts', 'Computers', 'Groups', 'Users' --> OK --> OK
--------Click Members Tab --> Add
--------'Enter the object names to select' --> 'win10a
---------Name Not Found window --> Click 'Object Types'
---------Check: 'Other Objects', 'Service Accounts', 'Computers', 'Groups', 'Users' --> OK --> OK

The end goal is to:
- Install SQL on the TUS-SQL1
- Configure a scheduled task that opens Notepad on WIN10A

Both using the same service account. This may not be what you should do in a real environment, but this shows us 
setting a service on one server, and a scheduled task on another machine, but done by using the same gMSA, even
if you do not know the account password.

Once these are added, reboot the servers.
#>

<#
# The next simple step is "Provisioning Group Managed Service Accounts"
# Up to this point he only official steps were to deploy a master roo key for the Active Directory (which we did) and
# that there is at least one Windows server (post 2012) in the Domain whre the gMSA will be created.
#>
# The next command to create the Service account. 
# Shows the structure:
# Video Example that worked**************************
# NOTE the ``` mark line breaks. All one command.
New-ADServiceAccount -Name gMSAtest -DNSHostName gMSAtest.aaco.local `
-KerberosEncryptionType RC4, AES128, AES256 `
-PrincipalsAllowedToRetrieveManagedPassword gMSA-Test `
-SamAccountName gMSAtest -ServicePrincipalNames `
http/gMSAtest.aaco.local/aaco.local, http/gMSAtest.aaco.local.aaco, http/gMSAtest/aaco.local, http/gMSAtest/aaco
#****************************************************


# NCT Try - mimics video naming, but uses our domain
# Passes through terminal with no confirmation.
# NOTE the ``` mark line breaks. All one command.
New-ADServiceAccount -Name GMSA_AD_Agency `
-DNSHostName GMSA_AD_Agency.widgetllc.internal 
-KerberosEncryptionType RC4, AES128, AES256 `
-PrincipalsAllowedToRetrieveManagedPassword gMSA-AgencyTest `
-SamAccountName GMSA_AD_Agency `
-ServicePrincipalNames http/GMSA_AD_Agency.widgetllc.internal/widgetllc.internal, `
http/GMSA_AD_Agency.widgetllc.internal.widgetllc, `
http/GMSA_AD_Agency/widgetllc.internal, `
http/GMSA_AD_Agency/widgetllc
# To View, a Server Manager restart is required
# In AD Users and Computers, under WidgetLLC.Internal --> Managed Service Accounts
# Now exists:   'GMSA_AD_Agency'    



# Check for it in PowerShell
Get-ADServiceAccount GMSA_AD_Agency
<#
DistinguishedName : CN=GMSA_AD_Agency,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
Enabled           : True
Name              : GMSA_AD_Agency
ObjectClass       : msDS-GroupManagedServiceAccount
ObjectGUID        : d86b51be-fb0f-4c2d-ae88-b98aeeaec586
SamAccountName    : GMSA_AD_Agency$
SID               : S-1-5-21-2778787315-2228761457-209862467-8615
UserPrincipalName : 
#>


#***THIS COMMAND ADDED AFTER - TRYING TO GET GMSA_AD_Agency to start a service on Client1111
# Managed Service Account was created through the Domain Controller.
# Now associate the MSA with a target machine >> Computer with it's Domain title.
# This allows the target machine to request and access the MSA password.
# CLIENT1111 is the name of the target machine. INCLUDE a $ after a target machine.
Set-ADServiceAccount -Identity GMSA_AD_Agency -PrincipalsAllowedToRetrieveManagedPassword CLIENT1111$
# You need to restart the server for any further work with this MSA



#Now that we have a gMSA created on our DC
#Click/Open a target server
#Steps for setting up SQL on server in UWE OneNote. Not enough space to create a new server currently.


# We have 2 other machines on our domain(DC01), DC02, and DESKTOP-8ALRUCQ
# We added 'DESKTOP-8ALRUCQ' as a member to the Security Group - 'gMSA-AgencyTest'


# Now to create a task to open notepad, this will open/run notepad in the background, not as a GUI
# Go to the machine: 'DESKTOP-8ALRUCQ' 
# Open 'Task Scheduler'
# There are options to create a task, these will not work here.
# There is a PowerShell workaround.
# To create in PowerShell, and view in Task Scheduler, open both as an Administrator
# PowerShell:
$action = New-ScheduledTaskAction "notepad.exe"
$trigger = New-ScheduledTaskTrigger -Daily -At 12:00PM

# widgetllc\gMSA-AgencyTest$ is the Group Managed Service Account created in the Active Directory
# Password is a property, not a value. It implies it will use the built in GMSA password
$principal = New-ScheduledTaskPrincipal -UserId widgetllc\gMSA-AgencyTest$ -LogonType Password

# 'Service' is the name of the task, you need to change that for another task: 'Sevice2' etc.
# You can create another task, that does the exact same thing, but it needs that new name.
Register-ScheduledTask Service -Description "Notepad, Daily 12:00PM" -Action $action -Trigger $trigger -Principal $principal
# Created 3 vars, and registered Task.
# After running, we opend Task Scheduler as an admin, and this task 'Service' was there.
# It then ran notepad at the scheduled time, but you did not see it. Though we could see it running in Task Manager

