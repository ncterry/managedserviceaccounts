#Get-Service 

Get-Service
<#
Status   Name               DisplayName                           
------   ----               -----------                           
Running  ADWS               Active Directory Web Services         
Stopped  AJRouter           AllJoyn Router Service                
Stopped  ALG                Application Layer Gateway Service     
Stopped  AppIDSvc           Application Identity                  
#>



# Save those results to a file in that format
$ppath = "C:\Users\Administrator\Documents\MSAFunctionsModule\MSAdata\getService.txt"
Get-Service | Out-File $ppath


# Get results in that format, of 2 known services
Get-Service bits, wuauserv



# Get services that are running
# Local host or target machine
Get-Service | Where-Object {$_.Status -eq "Running"}
<#
Status   Name               DisplayName                           
------   ----               -----------                           
Running  ADWS               Active Directory Web Services         
Running  BFE                Base Filtering Engine                 
Running  BrokerInfrastru... Background Tasks Infrastructure Ser...
Running  CDPSvc             Connected Devices Platform Service   
#>


Get-Service -ComputerName "DC01" | Where-Object {$_.Status -eq "Stopped"} | Format-Table Name, Status, MachineName -AutoSize
<#
Name                     Status MachineName
----                      ------ -----------
AJRouter                 Stopped DC01       
ALG                      Stopped DC01       
AppIDSvc                 Stopped DC01       
Appinfo                  Stopped DC01       
AppMgmt                  Stopped DC01       
AppReadiness             Stopped DC01
#>


Get-Service winrm, wudfsvc, wuauserv -ComputerName "DC01" | Format-Table Name, Status, MachineName -AutoSize
<#
Name      Status MachineName
----      ------ -----------
winrm    Running DC01       
wuauserv Stopped DC01       
wudfsvc  Running DC01 
#>


# Options associated with Get-Service
Get-Service | Get-Member
<#
   TypeName: System.ServiceProcess.ServiceController

Name                      MemberType    Definition                                                                                                
----                      ----------    ----------                                                                                                
Name                      AliasProperty Name = ServiceName                                                                                        
RequiredServices          AliasProperty RequiredServices = ServicesDependedOn                                                                     
Disposed                  Event         System.EventHandler Disposed(System.Object, System.EventArgs)                                             
Close                     Method        void Close()                                                                                              
Continue                  Method        void Continue()                                                                                           
CreateObjRef              Method        System.Runtime.Remoting.ObjRef CreateObjRef(type requestedType)                                           
Dispose                   Method        void Dispose(), void IDisposable.Dispose()                                                                
Equals                    Method        bool Equals(System.Object obj)                                                                            
ExecuteCommand            Method        void ExecuteCommand(int command)                                                                          
GetHashCode               Method        int GetHashCode()                                                                                         
GetLifetimeService        Method        System.Object GetLifetimeService()                                                                        
GetType                   Method        type GetType()                                                                                            
InitializeLifetimeService Method        System.Object InitializeLifetimeService()                                                                 
Pause                     Method        void Pause()                                                                                              
Refresh                   Method        void Refresh()                                                                                            
Start                     Method        void Start(), void Start(string[] args)                                                                   
Stop                      Method        void Stop()                                                                                               
WaitForStatus             Method        void WaitForStatus(System.ServiceProcess.ServiceControllerStatus desiredStatus), void WaitForStatus(Sys...
CanPauseAndContinue       Property      bool CanPauseAndContinue {get;}                                                                           
CanShutdown               Property      bool CanShutdown {get;}                                                                                   
CanStop                   Property      bool CanStop {get;}                                                                                       
Container                 Property      System.ComponentModel.IContainer Container {get;}                                                         
DependentServices         Property      System.ServiceProcess.ServiceController[] DependentServices {get;}                                        
DisplayName               Property      string DisplayName {get;set;}                                                                             
MachineName               Property      string MachineName {get;set;}                                                                             
ServiceHandle             Property      System.Runtime.InteropServices.SafeHandle ServiceHandle {get;}                                            
ServiceName               Property      string ServiceName {get;set;}                                                                             
ServicesDependedOn        Property      System.ServiceProcess.ServiceController[] ServicesDependedOn {get;}                                       
ServiceType               Property      System.ServiceProcess.ServiceType ServiceType {get;}                                                      
Site                      Property      System.ComponentModel.ISite Site {get;set;}                                                               
StartType                 Property      System.ServiceProcess.ServiceStartMode StartType {get;}                                                   
Status                    Property      System.ServiceProcess.ServiceControllerStatus Status {get;}                                               
ToString                  ScriptMethod  System.Object ToString();                                                                                 


#>


# Get target service, on localhost, and with 3 properties along with all properties starting with Can
Get-Service wuauserv | Select DisplayName, Status, ServiceName, Can*
<#
DisplayName         : Windows Update
Status              : Stopped
ServiceName         : wuauserv
CanPauseAndContinue : False
CanShutdown         : False
CanStop             : False
#>


# Find all services that can be paused and resumed without Windows restart.
Get-Service | Where-Object {$_.CanPauseAndContinue -eq $true}
<#
Status   Name               DisplayName                           
------   ----               -----------                           
Running  DNS                DNS Server                            
Running  LanmanWorkstation  Workstation                           
Running  Netlogon           Netlogon                              
Running  VMTools            VMware Tools                          
Running  Winmgmt            Windows Management Instrumentation   
#>



#Get all services, but just pick 2 propeties
Get-Service | select -Property name, StartType
<#
Name                                     StartType
----                                     ---------
ADWS                                     Automatic
AJRouter                                    Manual
ALG                                         Manual
AppIDSvc                                    Manual
Appinfo                                     Manual
AppMgmt                                     Manual
AppReadiness                                Manual
AppVClient                                Disabled
AppXSvc                                     Manual
#>


# Get a target service, on local host, but just one property
(Get-Service -Name wuauserv).StartType
<#
Manual
#>



Get-Service -Name Win*
<#
Status   Name               DisplayName                           
------   ----               -----------                           
Running  WinDefend          Windows Defender Service              
Running  WinHttpAutoProx... WinHTTP Web Proxy Auto-Discovery Se...
Running  Winmgmt            Windows Management Instrumentation    
Running  WinRM              Windows Remote Management (WS-Manag...
#>

Get-Service -Name Win* -Exclude WinRM
<#
Status   Name               DisplayName                           
------   ----               -----------                           
Running  WinDefend          Windows Defender Service              
Running  WinHttpAutoProx... WinHTTP Web Proxy Auto-Discovery Se...
Running  Winmgmt            Windows Management Instrumentation 
#>


# Create list of machines
# Check if service exists on those machines
# If service exists on a machine, then do an action
list.txt --> [dc01, dc02, dc03]
$list = Get-Content 'list.txt'
foreach ($server in $list) {
    if (get-service $servicename -ComputerName $server -ErrorAction 'SilentlyContinue') {
        Write-host ("$servicename exists on $server")
    }




# Restart a service on a machine
Get-Service wuauserv -ComputerName DC01 | Restart-Service



# Return other services that are dependant on a service
Get-Service -Name LanmanWorkstation -DependentServices
<#
Status   Name               DisplayName                           
------   ----               -----------                           
Stopped  SessionEnv         Remote Desktop Configuration          
Stopped  TestMSAservice2    Test MSA Service Number2              
Running  Netlogon           Netlogon                              
Running  Dfs                DFS Namespace                         
Stopped  Browser            Computer Browser
#>



# Commands to control a service
Get-Command -Noun Service
<#
CommandType     Name                                               Version    Source                                           
-----------     ----                                               -------    ------                                           
Cmdlet          Get-Service                                        3.1.0.0    Microsoft.PowerShell.Management                  
Cmdlet          New-Service                                        3.1.0.0    Microsoft.PowerShell.Management                  
Cmdlet          Restart-Service                                    3.1.0.0    Microsoft.PowerShell.Management                  
Cmdlet          Resume-Service                                     3.1.0.0    Microsoft.PowerShell.Management                  
Cmdlet          Set-Service                                        3.1.0.0    Microsoft.PowerShell.Management                  
Cmdlet          Start-Service                                      3.1.0.0    Microsoft.PowerShell.Management                  
Cmdlet          Stop-Service                                       3.1.0.0    Microsoft.PowerShell.Management                  
Cmdlet          Suspend-Service                                    3.1.0.0    Microsoft.PowerShell.Management                  

#>


# Stop a service
Stop-Service -Name WinDefend

# Stop a service no matter what
Stop-Service -Name WinDefend -Force

# STart a service
Start-Service -Name WinDefend


# Dont let a service start automatically
Set-Service 'WinRM' -StartupType Disabled


