#==============================
Function Get-ServerInfo {  
<#
    .SYNOPSIS
    Gather the associated servers and related attributes.

    .DESCRIPTION
    No Parameters. Simply returns the local domain.

    .Example
    Get-ServerInfo

    .Example
    Get-ServerInfo $writehost $true
    # Will return the server information to a function, and write the domain in terminal.

    .OUTPUTS
    ----------------
    Name:                   DC01
    DistinguishedName:      CN=DC01,OU=Domain Controllers,DC=WidgetLLC,DC=Internal
    BadLogonCount:          0
    CannotChangePassword:   False
    DNSHostName:            DC01.WidgetLLC.Internal
    IPv4Address:            192.168.0.1
    LastLogonDate:          02/16/2022 07:36:44
    OperatingSystem:        Windows Server 2016 Datacenter
    MemberOf:               CN=GMSA_AD_Agency_USERS,OU=GMSAs,OU=itFlee,DC=WidgetLLC,DC=Internal CN=GMSA_CYLON_USERS,OU=GMSAs,OU=itFlee,DC=WidgetLLC,DC=Internal
    ----------------
#>  
#==============================  
[CmdletBinding()]
Param(
    [Parameter()]
    [bool[]]
    $writehost # Don't want to writeout if called by other function
) # End Param-------------------------------


    # Gather the local Domain
    $domain = Get-ADDomain -Current LocalComputer  | Select-Object -ExpandProperty DNSRoot 
    If ($writehost -eq $true) { # Only write if not called from a sub-function
        Write-Host -ForegroundColor Yellow ("`n------------------`nDomain:  ")
        Write-Host -ForegroundColor Yellow ("`n------------------`n$domain `n------------------  ")
    } #End If-------------------------------


    # Get all servers and associated attributes.
    # Not all attributes are displayed here.
    $servers = Get-ADComputer -Filter {OperatingSystem -Like "Windows *Server*"} -Property *
    $serverNames = @()
    foreach ($server in $servers) {

        # View all listed properties of a server:
        #$server | Select-Object -Property *
        #
        # Only print to terminal if $false is not called
        # Get-ServerInfo $writehost $false --> To just return the server names.
        If ($writehost -eq $true) {
            # Common server properties
            Write-Host -ForegroundColor Yellow ("----------------") 
            Write-Host ("Name: `t`t`t" +  $server.Name)
            Write-Host ("DistinguishedName: `t" +  $server.DistinguishedName)
            Write-Host ("BadLogonCount: `t`t" +   $server.BadLogonCount)
            Write-Host ("CannotChangePassword: `t" +   $server.CannotChangePassword)
            Write-Host ("DNSHostName: `t`t" +   $server.DNSHostName)
            Write-Host ("IPv4Address: `t`t" +   $server.IPv4Address)
            Write-Host ("LastLogonDate: `t`t" +   $server.LastLogonDate)
            Write-Host ("OperatingSystem: `t" +   $server.OperatingSystem)
            Write-Host ("MemberOf: `t`t" +   $server.MemberOf) 
            Write-Host -ForegroundColor Yellow ("----------------`n") 
        }#End If
        
        # Capture the server names, and store them in array for later use if needed.
        $serverNames += $server.Name
    }#End foreach




    return $serverNames

} #End Function Get-FunctionName
#==============================
