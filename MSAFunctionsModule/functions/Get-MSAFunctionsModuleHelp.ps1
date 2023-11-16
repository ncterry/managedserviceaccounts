
#-------------------------------------------------
# Function to show the MSAFunctionsModule help
# This is a sub-function that displays the help/explanations for MSAProgram sections.

function Get-MSAFunctionsModuleHelp {
<#
    .SYNOPSIS
    Help sections for the entire module are individually displayed here.

    .DESCRIPTION
    From each menu, there are sections 1,2,3 and associated sub-sections 1h,2h,3h.
    These sub-sections are there to offer help/instructions on what the primary
    sections are actually doing.
    Example:
        Run the MSAfunctionModule program.
        Go to Menu 1
        Execute section 3 - which does a diag check on your machine.

    To get help on what section 1.3 does, while on menu 1, enter '3h' which will
    call this help function, and return the data/information that is related
    to section 1.3. 

    .Example
    Get-MSAFunctionsModuleHelp -section "1.3"

    .OUTPUTS
    ---------
    Section 1.3 - dcdiag `nDomain Controller Health Check
    ---------
    `'dcdiag`' - Is one of the oldest and most useful tools to figure out 
    what's going on in your Active Directory environment. This tool comes 
    with Windows, and allows Admins to run various diagnostic checks.

    This can be extensive, and may result in a successful test, with 
    pseudo-errors if there is encrypted data assocated with the Domain 
    such as encrypted MSA backups. These will be registered, and 
    acknowledged by this test, but cannot be tested through dcdiag, 
    even with Administrator privileges. 
#>
Param(
    [Parameter(Mandatory = $true)]
    [string]
    $section
) # End Param-------------------------------
    
    Write-Host -ForegroundColor Yellow ("
|======================================================================|
|==================--- MSAFunctionsModule Help  ---====================|
|======================================================================|`n")
    
    
    If ($section -eq "1.1") {

Write-Host -ForegroundColor Yellow ("
---------
Section 1.1 - Display the associated Domain`n") # END WRITE-HOST

    #---------- These are just visual display seperations
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    # End of Section 1.1

    } ElseIf ($section -eq "1.2") {

Write-Host -ForegroundColor Yellow ("
---------
Section 1.2 - Display the associated Domain Controller`n") # END WRITE-HOST

    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    # End of Section 1.2

    } ElseIf ($section -eq "1.3") {

Write-Host -ForegroundColor Yellow ("
---------
Section 1.3 - dcdiag `nDomain Controller Health Check
---------
`'dcdiag`' - Is one of the oldest and most useful tools to figure out 
what's going on in your Active Directory environment. This tool comes 
with Windows, and allows Admins to run various diagnostic checks.

This can be extensive, and may result in a successful test, with 
pseudo-errors if there is encrypted data assocated with the Domain 
such as encrypted MSA backups. These will be registered, and 
acknowledged by this test, but cannot be tested through dcdiag, 
even with Administrator privileges. `n") # END WRITE-HOST-------------------------------

    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    # End of Section 1.3

    } ElseIf ($section -eq "1.4") {

Write-Host -ForegroundColor Yellow ("
---------
Section 1.4 - nltest - Domain Controller Health Check
---------
`'nltest`' - A comprehensive trust/communications testing tool for 
a domain, which will display basic information for the Domain and 
Domain Controller. `n") # END WRITE-HOST-------------------------------

    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    # End of Section 1.4
    } ElseIf ($section -eq "1.5") {

Write-Host -ForegroundColor Yellow ("
---------
Section 1.5 - Server Status Check
---------
This gathers all servers that are attached to the domain and scans
to verify if these servers are currently active or not.
Checking Servers..
    
    Server     : DC01
    Is Online? : True

    Server     : DC03
    Is Online? : False

 `n") # END WRITE-HOST-------------------------------

        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        # End of Section 1.5
    # END GP0 FUNCTIONS MODULE SECTION 1 -------------------------------
    #----------
    } ElseIf ($section -eq "2.1") {  # Start Help Section
    #----------
    
    Write-Host -ForegroundColor Yellow ("
    Section 2.1
    This script will scan for Service Accounts on the domain that are being 
    used as a service logon account. These results will be saved to a file in
    the MSAdata directory. 
    C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata


    Return Data Example
    Service account report for domain:
        WIDGETLLC

    2 servers found. 
        CN=DC01,OU=Domain Controllers,DC=WidgetLLC,DC=Internal 
        CN=DC02,OU=Domain Controllers,DC=WidgetLLC,DC=Internal

    Discovered service accounts using logon privileges:
    02/22/2022 08:30:38
        2 service accounts found.
        @{Account=WIDGETLLC\TestMSA123$; Usage=`"TestMSAservice2`" service on DC01}
        @{Account=WIDGETLLC\TestMSA$; Usage=`"TestMSAservice`" service on DC01} 

    Notifications:
        DC02.WidgetLLC.Internal inaccessible
            ")#End Write-Host



    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    # End of Section 2.1
    } ElseIf ($section -eq "2.2") {  # Start Help Section
        
    Write-Host -ForegroundColor Yellow ("
    ---------
    Section 2.2 - 
    Cycle through the Active Directory and Gather the Managed Service Accounts.
        This will list all MSA domain addresses, and then more specific details about each one.
        For Example:

        ---------------Active Directory Managed Service Accounts---------------

        > CN=GMSA_AD_CYLONS,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal

        > CN=gMSAtest,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal

        > CN=GMSA_AD_Agency,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal

        > CN=TestMSA,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal

        > CN=TestMSA123,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal


        DistinguishedName      : CN=GMSA_AD_CYLONS,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
        Enabled                : True
        Name                   : GMSA_AD_CYLONS
        ObjectClass            : msDS-GroupManagedServiceAccount
        ObjectGUID             : e036a9a8-2385-4f33-b818-819a255196cc
        SamAccountName         : GMSA_AD_CYLONS$
        SID                    : S-1-5-21-2778787315-2228761457-209862467-8609
        ...
        ...
        ...


    `n") # END WRITE-HOST-------------------------------
        
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    # End of Section 2.2
    } ElseIf ($section -eq "2.3") {  # Start Help Section

    Write-Host ("
    .SYNOPSIS
    Gather the Managed Service Accounts that are associated with the Active Directory 
    as well the AD Identities, for example: 'BUILTIN\Administrators',  and view the permissions
    that each AD Identity has, in regards to each Managed Service Account.  

    .DESCRIPTION
    Need: 
    - Active Directory for PowerShell
    - Admin privileges or the Domain in order gather attribute GUIDs and gMSA permissions.
        
    The focus is to look up permissions in the Active Directory for an Organizational Unit.
    This will allow viewing of who has what access to Managed Service Accounts

    .Example
    Get-MSApermissions

    .OUTPUTS
    ...
    ...
    ...
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
                ...
                ...
                ...
#>  
#==============================  
")#End Write-Host
            
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    # End of Section 2.3
    } ElseIf ($section -eq "3.1") {  # Start Help Section
                
       Write-Host ("
       3) Services Information
       Help Section 3.1) - Gather Server Info
       Example:
       
       
       ------------------
       Domain:

       ------------------
       WidgetLLC.Internal
       ------------------
       ----------------
       Name:                   DC01
       DistinguishedName:      CN=DC01,OU=Domain Controllers,DC=WidgetLLC,DC=Internal
       BadLogonCount:          0
       CannotChangePassword:   False
       DNSHostName:            DC01.WidgetLLC.Internal
       IPv4Address:            192.168.0.1
       LastLogonDate:          02/16/2022 07:36:44
       OperatingSystem:        Windows Server 2016 Datacenter
       MemberOf:               CN=GMSA_AD_Agency_USERS,OU=GMSAs,OU=itFlee,DC=WidgetLLC,DC=Internal CN=GMSA_CYLON_USERS,OU=GMSAs
       ,OU=itFlee,DC=WidgetLLC,DC=Internal
       ----------------
       ")#End Write-Host

       
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        # End of Section 3.1
    } ElseIf ($section -eq "3.2") {  # Start Help Section
        Write-Host ("
        3) Services Information
        Help Section 3.2) Domain: ALL Services
        Gather ALL of the associated services, their status, and with which machine.
        These services will be gathered from each server in the domain.
        This data will be displayed in the terminal, and saved to file.
        Example:
        
        **********
        View Services for:
        Domain: WidgetLLC.Internal
        Server: CN=DC03,CN=Computers,DC=WidgetLLC,DC=Internal
        **********

        Name                                      Status MachineName
        ----                                      ------ -----------
        ADWS                                     Stopped DC03
        AJRouter                                 Stopped DC03
        ALG                                      Stopped DC03
        AppHostSvc                               Running DC03
        AppIDSvc                                 Stopped DC03
        Appinfo                                  Stopped DC03
        AppMgmt                                  Stopped DC03
        AppReadiness                             Stopped DC03
        AppVClient                               Stopped DC03
        AppXSvc                                  Stopped DC03
        aspnet_state                             Stopped DC03
        AudioEndpointBuilder                     Running DC03
        Audiosrv                                 Running DC03
        AxInstSV                                 Stopped DC03
        BFE                                      Running DC03
        ...
        ...
        ...
        ")#End Write-Host


        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        # End of Section 3.2
    } ElseIf ($section -eq "3.3") {  # Start Help Section
        Write-Host ("
        3) Services Information
        Help Section 3.3) Domain: RUNNING Services
        This section will cycle through all associated servers, then gather all 
        RUNNING services on each machine. It will print that list to the terminal
        and save the combined results to a file.

        **********
        **********
        View Services for:
        Domain: WidgetLLC.Internal
        Server: CN=DC03,CN=Computers,DC=WidgetLLC,DC=Internal
        **********

        Name                    Status MachineName
        ----                    ------ -----------
        AppHostSvc             Running DC03
        AudioEndpointBuilder   Running DC03
        Audiosrv               Running DC03
        BFE                    Running DC03
        BrokerInfrastructure   Running DC03
        CDPSvc                 Running DC03
        CDPUserSvc_6871d       Running DC03
        CertPropSvc            Running DC03
        ClipSVC                Running DC03
        COMSysApp              Running DC03
        ...
        ...
        ...

        **********
        Results stored at: C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\Services\
        Timestamp: 2022-02-24-095053
        ")#End Write-Host
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        # End of Section 3.3
    } ElseIf ($section -eq "3.4") {  # Start Help Section
        Write-Host ("
        3) Services Information
        Help Section 3.4) Domain: STOPPED Services
        This section will cycle through all associated servers, then gather all 
        STOPPED services on each machine. It will print that list to the terminal
        and save the combined results to a file.
        
        **********
        **********
        View Services for:
        Domain: WidgetLLC.Internal
        Server: CN=DC03,CN=Computers,DC=WidgetLLC,DC=Internal
        **********
        
        Name                                      Status MachineName
        ----                                      ------ -----------
        ADWS                                     Stopped DC03
        AJRouter                                 Stopped DC03 
        ...
        ...
        ... 
        WdiServiceHost                           Stopped DC03
        WdNisSvc                                 Stopped DC03
        Wecsvc                                   Stopped DC03
        WEPHOSTSVC                               Stopped DC03
        wercplsupport                            Stopped DC03
        WerSvc                                   Stopped DC03
        WiaRpc                                   Stopped DC03
        wisvc                                    Stopped DC03
        wmiApSrv                                 Stopped DC03
        WMPNetworkSvc                            Stopped DC03
        WPDBusEnum                               Stopped DC03
        WSearch                                  Stopped DC03
        wuauserv                                 Stopped DC03


        **********
        Results stored at: C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\Services\
        Timestamp: 2022-02-24-095252
        ")#End Write-Host
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        # End of Section 3.4
    } ElseIf ($section -eq "3.5") {  # Start Help Section
        Write-Host ("
        3) Services Information
        Help Section 3.5) Target Machine: ALL Services

        This section will cycle through a user-targeted server, then gather ALL 
        services on a machine. It will print that list to the terminal
        and save the combined results to a file.
        
        
        ---------Servers---------
        1) DC01
        2) DC03

        0) Return to Prior Menu                Enter: 0

        Choose which server to gather ALL services from.
        Enter Choice: (1 - 2)
        : 1

        Name                                      Status MachineName
        ----                                      ------ -----------
        ADWS                                     Running DC01
        AJRouter                                 Stopped DC01
        ALG                                      Stopped DC01
        AppIDSvc                                 Stopped DC01
        Appinfo                                  Stopped DC01
        AppMgmt                                  Stopped DC01
        AppReadiness                             Stopped DC01
        AppVClient                               Stopped DC01
        AppXSvc                                  Stopped DC01
        AudioEndpointBuilder                     Stopped DC01
        Audiosrv                                 Stopped DC01
        AxInstSV                                 Stopped DC01
        BFE                                      Running DC01
        BITS                                     Stopped DC01
        BrokerInfrastructure                     Running DC01
        ...
        ...
        ...
        Results stored at: C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\Services\
        Timestamp: 2022-02-24-095439
        ")#End Write-Host
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        # End of Section 3.5
    } ElseIf ($section -eq "3.6") {  # Start Help Section
        Write-Host ("
        3) Services Information
        Help Section 3.6) Target Machine: RUNNING Services

        This section will cycle through a user-targeted server, then gather all 
        RUNNING services on a machine. It will print that list to the terminal
        and save the combined results to a file.
        
        ---------Servers---------
        1) DC01
        2) DC03
       
        0) Return to Prior Menu                Enter: 0
       
        Choose which server to gather RUNNING services from.
        Enter Choice: (1 - 2)
        : 1

        Name                    Status MachineName
        ----                    ------ -----------
        ADWS                   Running DC01
        BFE                    Running DC01
        BrokerInfrastructure   Running DC01
        CDPSvc                 Running DC01
        CDPUserSvc_47392       Running DC01
        ...
        ...
        ...
        Winmgmt                Running DC01
        WinRM                  Running DC01
        WpnService             Running DC01
        wudfsvc                Running DC01


        Results stored at: C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\Services\
        Timestamp: 2022-02-24-095827   
        ")#End Write-Host
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        # End of Section 3.6
    } ElseIf ($section -eq "3.7") {  # Start Help Section
        Write-Host ("
        3) Services Information
        Help Section 3.7) Target Machine: STOPPED Services

        This section will cycle through a user-targeted server, then gather all 
        STOPPED services on a machine. It will print that list to the terminal
        and save the combined results to a file.


        ---------Servers---------
        1) DC01
        2) DC03
       
        0) Return to Prior Menu                Enter: 0
       
        Choose which server to gather STOPPED services from.
        Enter Choice: (1 - 2)
        : 1
        
        Name                                      Status MachineName
        ----                                      ------ -----------
        AJRouter                                 Stopped DC01
        ALG                                      Stopped DC01
        AppIDSvc                                 Stopped DC01
        Appinfo                                  Stopped DC01
        ...
        ...
        ...    
        WPDBusEnum                               Stopped DC01
        WpnUserService_47392                     Stopped DC01
        WSearch                                  Stopped DC01
        wuauserv                                 Stopped DC01
        XblAuthManager                           Stopped DC01
        XblGameSave                              Stopped DC01


        Results stored at: C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\Services\
        Timestamp: 2022-02-24-100022
        ")#End Write-Host
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        # End of Section 3.7
    } ElseIf ($section -eq "3.8") {  # Start Help Section
        Write-Host ("
        3) Services Information
        Help Section 3.8) Targeted Service and Related Properties
        Allow a user to locally target a service, and associated properties of that service.
        
        
        ---------All Active Services----------
        1)  ADWS                                       2)  AJRouter
        3)  AppIDSvc                                   4)  Appinfo
        5)  AppMgmt                                    6)  AppReadiness
        7)  AppVClient                                 8)  AppXSvc
        9)  AudioEndpointBuilder                       10) Audiosrv
        11) AxInstSV                                   12) BFE
        13) BITS                                       14) BrokerInfrastruc
        15) Browser                                    16) bthserv
        17) Carly is a UNICORN                         18) CDPSvc
        19) CDPUserSvc_47392                           20) CertPropSvc
        21) ClipSVC                                    22) COMSysApp
        ...
        ...
        ... 
        Choose which service to target.
        Enter 0 to return to prior menu.
        : 5
            
        

        ----- Service:  AppMgmt
        1) View all service properties
        2) View one target service property
        0) Return to prior menu
        : 1



        Name                : AppMgmt
        RequiredServices    : {}
        CanPauseAndContinue : False
        CanShutdown         : False
        CanStop             : False
        DisplayName         : Application Management
        DependentServices   : {}
        MachineName         : .
        ServiceName         : AppMgmt
        ServicesDependedOn  : {}
        ServiceHandle       : SafeServiceHandle
        Status              : Stopped
        ServiceType         : Win32ShareProcess
        StartType           : Manual
        Site                :
        Container           :
        ")#End Write-Host
                
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        # End of Section 3.8
    } ElseIf ($section -eq "") {  # Start Help Section
                
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        # End of Section .
    } ElseIf ($section -eq "") {  # Start Help Section
                
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        # End of Section .
    } ElseIf ($section -eq "") {  # Start Help Section
                
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        # End of Section .
    } ElseIf ($section -eq "") {  # Start Help Section
                
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        #----------
        # End of Section .
    } ElseIf ($section -eq "") {  # Start Help Section
                
    }
} # End  function Get-MSAFunctionsModuleHelp
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
    #----------
