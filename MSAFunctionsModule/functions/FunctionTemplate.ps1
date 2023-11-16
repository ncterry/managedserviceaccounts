#==============================
Function Get-FunctionName {  
<#
    .SYNOPSIS
    Gather the --- this machine.

    .DESCRIPTION
    No Parameters. Simply returns the local domain.

    .Example
    Get-FunctionName

    .Example
    Get-FunctionName $writehost $true
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


    # Gather the local Domain
    $domain = Get-ADDomain -Current LocalComputer  | Select-Object -ExpandProperty DNSRoot 

    
    If ($writehost -eq $true) { # Only write if not called from a sub-function
        Write-Host -ForegroundColor Yellow ("`n------------------`nDomain:  ")
    } #End If-------------------------------


    return $domain

} #End Function Get-FunctionName
#==============================
