#==============================
Function Get-TargetManagedServiceAccount {  
<#
    .SYNOPSIS
    Gather the full schematics for an individual, targeted Managed Service Account in this AD

    .DESCRIPTION
    No Parameters. Simply returns the local domain.

    .Example
    Get-TargetManagedServiceAccount

    .Example
    Get-TargetManagedServiceAccount $writehost $true
    # Will return the domain to a function, and write the domain in terminal.

    .OUTPUTS
    Return:
#>  
#==============================  
[CmdletBinding()]
Param(
    [Parameter()]
    [bool[]]
    $writehost = $true # Don't want to writeout if called by other function
) # End Param-------------------------------

    # Get a target service, on local host, but just one property
    $serviceProperties = @("Name", "RequiredServices", "Disposed", "Close", "Continue", "CreateObjRef", "Dispose", "Equals", "ExecuteCommand", "GetHashCode", "GetLifetimeService", "GetType", "InitializeLifetimeService", "Pause", "Refresh", "Start", "Stop", "WaitForStatus", "CanPauseAndContinue", "CanShutdown", "CanStop", "Container", "DependentServices", "DisplayName", "MachineName", "ServiceHandle", "ServiceName", "ServicesDependedOn", "ServiceType", "StartTySitepe", "StartType", "ToString", "Status")

    do {
        $num = 0
        Write-Host -ForegroundColor Yellow ("Target Service Properties")
        foreach ($property in $serviceProperties) {
            $num++
            Write-Host ("$num`) $property")
            
        }

        Write-Host ("Which property to view:")
        $choice = Read-Host " "


    }until ($num -eq 0)#End do/until
    
    (Get-Service -Name wuauserv).Name
    (Get-Service -Name wuauserv).RequiredServices
    (Get-Service -Name wuauserv).Disposed
    (Get-Service -Name wuauserv).Close
    (Get-Service -Name wuauserv).Continue
    (Get-Service -Name wuauserv).CreateObjRef
    (Get-Service -Name wuauserv).Dispose
    (Get-Service -Name wuauserv).Equals
    (Get-Service -Name wuauserv).ExecuteCommand
    (Get-Service -Name wuauserv).GetHashCode
    (Get-Service -Name wuauserv).GetLifetimeService
    (Get-Service -Name wuauserv).GetType
    (Get-Service -Name wuauserv).InitializeLifetimeService
    (Get-Service -Name wuauserv).Pause
    (Get-Service -Name wuauserv).Refresh
    (Get-Service -Name wuauserv).Start
    (Get-Service -Name wuauserv).Stop
    (Get-Service -Name wuauserv).WaitForStatus
    (Get-Service -Name wuauserv).CanPauseAndContinue
    (Get-Service -Name wuauserv).CanShutdown
    (Get-Service -Name wuauserv).CanStop
    (Get-Service -Name wuauserv).Container
    (Get-Service -Name wuauserv).DependentServices
    (Get-Service -Name wuauserv).DisplayName
    (Get-Service -Name wuauserv).MachineName
    (Get-Service -Name wuauserv).ServiceHandle
    (Get-Service -Name wuauserv).ServiceName
    (Get-Service -Name wuauserv).ServicesDependedOn
    (Get-Service -Name wuauserv).ServiceType
    (Get-Service -Name wuauserv).StartTySitepe
    (Get-Service -Name wuauserv).StartType
    (Get-Service -Name wuauserv).ToString
    (Get-Service -Name wuauserv).Status


} #End Function Get-TargetManagedServiceAccount
#==============================


<#
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
