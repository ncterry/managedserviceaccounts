
# Acquired a targeted machine name: EX. DC01
# Gather services on that machine. 
# All Services, Running Services, Stopped Services
$services = Get-WmiObject -Class win32_service -ComputerName $server.Name | Where-Object {$_.StartName -like "*"}
$services = Get-WmiObject -Class win32_service -ComputerName $server.Name | Where-Object {$_.StartName -like "*" -and $_.State -eq "Running"}
$services = Get-WmiObject -Class win32_service -ComputerName $server.Name | Where-Object {$_.StartName -like "*" -and $_.State -eq "Stopped"}
<#
...
Service: TermService - Stopped
Service: TestMSAservice - Stopped
Service: TestMSAservice2 - Stopped
Service: Themes - Running
Service: TieringEngineService - Stopped
Service: tiledatamodelsvc - Running
Service: TimeBrokerSvc - Running
...
#>

Get-CimInstance -ClassName Win32_Service | Select-Object -Property Name, Caption, Description, Started

Get-WmiObject -Class win32_service | Select-Object -Property Name, Caption, Description, Started
<#
Name                Caption                                         Description                                     
----                -------                                         -----------                                     
ADWS                Active Directory Web Services                   This service provides a Web Service interface...
AJRouter            AllJoyn Router Service                          Routes AllJoyn messages for the local AllJoyn...
ALG                 Application Layer Gateway Service               Provides support for 3rd party protocol plug-...
...
#>

$ppath = "C:\Users\Administrator\Documents\MSAFunctionsModule\MSAdata\getService.txt"
New-Item -ItemType File -Path $ppath -Force
$results = Get-Service -ComputerName "DC01" | Where-Object {$_.status -eq "Running"} | Select Status, Name, MachineName
Add-Content -Path $ppath -Value $results


<#
Status Name                   MachineName
 ------ ----                   -----------
Running ADWS                   DC01       
Running BFE                    DC01       
Running BrokerInfrastructure   DC01       
Running CDPSvc                 DC01   
#>
#******************************
#******************************
#******************************
# Get all servers and associated attributes.
# Not all attributes are displayed here.
$servers = Get-ADComputer -Filter {OperatingSystem -Like "Windows *Server*"} -Property *
foreach ($server in $servers) {
    Write-Host ($server)
    Write-Host ($server.IPv4Address)
    Write-Host ($server.PasswordNotRequired)
}#End foreach

#CN=DC01,OU=Domain Controllers,DC=WidgetLLC,DC=Internal
#192.168.0.1
#False

#CN=DC03,CN=Computers,DC=WidgetLLC,DC=Internal
#192.168.0.2
#False

#******************************
#******************************
#******************************
foreach ($server in $servers) {
    # For each server, find services running under the user specified in $Account
    $services = Get-WmiObject -Class win32_service | Where-Object {$_.StartName -like "*"}

    # Gather just those services starting with 'Test'
    # These look like they start with Test, but I still needed the  *  in front. 
    $testservices = Get-WmiObject -Class win32_service | Where-Object {$_.StartName -like "*Test*"}
}#End foreach
$services
$services[0].Name

foreach($service in $services) {
    Write-host ($service.Name)
}

<## Gathers all services, running and stopped, included created services
...
ExitCode  : 0
Name      : TestMSAservice
ProcessId : 0
StartMode : Auto
State     : Stopped
Status    : OK

ExitCode  : 1077
Name      : TestMSAservice2
ProcessId : 0
StartMode : Manual
State     : Stopped
Status    : OK

ExitCode  : 0
Name      : WinHttpAutoProxySvc
ProcessId : 1028
StartMode : Manual
State     : Running
Status    : OK

ExitCode  : 0
Name      : Winmgmt
ProcessId : 812
StartMode : Auto
State     : Running
Status    : OK

ExitCode  : 0
Name      : WinRM
ProcessId : 1176
StartMode : Auto
State     : Running
Status    : OK
...
...
...
#>


# List all of the services that are running
foreach($service in $services) {
    # Write-Host($service)
    # EX: \\DC01\root\cimv2:Win32_Service.Name="TestMSAservice2"
    If($service.State -eq "Running") {
        Write-Host ($Service.Name)
        <#
            ...
            Dhcp
            DiagTrack
            DNS
            Dnscache
            DPS
            DsmSvc
            EFS
            EventLog
            ...
        #>
    }#End If
}#End foreach



# Get the processes on the local computer
# TONS of info for DC01
Get-WmiObject -Class Win32_Process
<#
__GENUS                    : 2
__CLASS                    : Win32_Process
__SUPERCLASS               : CIM_Process
__DYNASTY                  : CIM_ManagedSystemElement
__RELPATH                  : Win32_Process.Handle="652"
__PROPERTY_COUNT           : 45
__DERIVATION               : {CIM_Process, CIM_LogicalElement, CIM_ManagedSystemElement}
__SERVER                   : DC01
__NAMESPACE                : root\cimv2
__PATH                     : \\DC01\root\cimv2:Win32_Process.Handle="652"
Caption                    : winlogon.exe
CommandLine                : winlogon.exe
CreationClassName          : Win32_Process
CreationDate               : 20220215103355.885301-300
CSCreationClassName        : Win32_ComputerSystem
CSName                     : DC01
Description                : winlogon.exe
ExecutablePath             : C:\Windows\system32\winlogon.exe
ExecutionState             : 
Handle                     : 652
HandleCount                : 187
InstallDate                : 
KernelModeTime             : 937500
MaximumWorkingSetSize      : 1380
MinimumWorkingSetSize      : 200
Name                       : winlogon.exe
OSCreationClassName        : Win32_OperatingSystem
OSName                     : Microsoft Windows Server 2016 Datacenter|C:\Windows|\Device\Harddisk0\Partition3
OtherOperationCount        : 690
OtherTransferCount         : 172172
PageFaults                 : 7715
PageFileUsage              : 1792
ParentProcessId            : 564
PeakPageFileUsage          : 3200
PeakVirtualSize            : 2199095844864
PeakWorkingSetSize         : 16308
Priority                   : 13
PrivatePageCount           : 1835008
ProcessId                  : 652
QuotaNonPagedPoolUsage     : 9
QuotaPagedPoolUsage        : 144
QuotaPeakNonPagedPoolUsage : 11
QuotaPeakPagedPoolUsage    : 145
ReadOperationCount         : 2
ReadTransferCount          : 177500
SessionId                  : 1
Status                     : 
TerminationDate            : 
ThreadCount                : 2
UserModeTime               : 312500
VirtualSize                : 2199094267904
WindowsVersion             : 10.0.14393
WorkingSetSize             : 16650240
WriteOperationCount        : 0
WriteTransferCount         : 0
PSComputerName             : DC01
ProcessName                : winlogon.exe
Handles                    : 187
VM                         : 2199094267904
WS                         : 16650240
Path                       : C:\Windows\system32\winlogon.exe

$>

# Get services on a remote computer
Get-WmiObject -Class Win32_Service -ComputerName Client111
Get-WmiObject -Class Win32_Service -ComputerName 192.168.0.4
<#EX:
ExitCode  : 0
Name      : WinRM
ProcessId : 1160
StartMode : Auto
State     : Running
Status    : OK
#>


# Get named service, with target attributes, on multiple names machines
# ` Line break. All one command
Get-WmiObject -Query "Select * from Win32_Service Where name='WinRM'" -ComputerName DC01, Client111 | `
Format-List -Property PSComputerName,Name, ProcessID, State
<#
PSComputerName : DC01
Name           : WinRM
ProcessID      : 1176
State          : Running

PSComputerName : CLIENT111
Name           : WinRM
ProcessID      : 1160
State          : Running
#>


# Stop a service on a remote computer
(Get-WmiObject -Class Win32_Service -Filter "name='WinRM'" -ComputerName client111).StopService()
<# Then run the prior command again to verify.
#
PSComputerName : DC01
Name           : WinRM
ProcessID      : 1176
State          : Running

PSComputerName : CLIENT111
Name           : WinRM
ProcessID      : 0
State          : Stopped
#>



# Get the BIOS on a local machine
Get-WmiObject -Class Win32_Bios | Format-List -Property *
<#
Lots of BIOS info including:
#
...
...
Manufacturer                   : VMware, Inc.
OtherTargetOS                  : 
PrimaryBIOS                    : True
ReleaseDate                    : 20200810000000.000000+000
SerialNumber                   : VMware-56 4d 10 04 3c e3 dc ea-81 33 dd a8 de c5 05 6c
SMBIOSBIOSVersion              : VMW71.00V.16722896.B64.2008100651
SMBIOSMajorVersion             : 2
SMBIOSMinorVersion             : 7
SoftwareElementID              : VMW71.00V.16722896.B64.2008100651
SoftwareElementState           : 3
SystemBiosMajorVersion         : 255
SystemBiosMinorVersion         : 255
TargetOperatingSystem          : 0
Version                        : INTEL  - 6040000
Scope                          : System.Management.ManagementScope
Path                           : \\DC01\root\cimv2:Win32_BIOS.Name="VMW71.00V.16722896.B64.2008100651",SoftwareElementID="VMW71.00V.1672
                                 2896.B64.2008100651",SoftwareElementState=3,TargetOperatingSystem=0,Version="INTEL  - 6040000"
#>




Get-WmiObject Win32_Service -Credential WidgetLLC\Administrator -ComputerName Client111
<#EX:
Sub-Window will pop-up asking for Administrator Password. (or other target user)
Just gathers the basic service info, but allows for gathered targeted user/machine services.
...
...
ExitCode  : 0
Name      : WinRM
ProcessId : 1160
StartMode : Auto
State     : Running
Status    : OK
#>
