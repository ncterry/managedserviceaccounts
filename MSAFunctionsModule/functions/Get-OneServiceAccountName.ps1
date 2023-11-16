#==============================
Function Get-OneServiceAccountName {  
<#
    .SYNOPSIS
    Gather a single Managed Service Account Name

    .DESCRIPTION
    Often a user must send the name of a Service Account to the system for further services.
    This function is a simple 'ask' and gathering of a Service Account name, so that
    users do not have to create future loops for name requests. This function can just be called.

    .Example
    Get-OneServiceAccountName

    .OUTPUTS
    Simply return the name of a chosen MSA:
    "TestMSA"
#>  
#==============================  
[CmdletBinding()]
Param(
    [Parameter()]
    [bool[]]
    $writehost = $true # Don't want to writeout if called by other function
) # End Param-------------------------------


    $msaName = $null
    do {
        Clear-Host
        # Get all manages services accounts that are active
        $names = Get-AllManagedServiceAccounts
        # For loop choices, gather how many were collected.
        $length = $names.Length
        Write-Host -ForegroundColor Yellow ("Choose a local Managed Service Account:")
        $count = 0
        # List all of the names of the service accounts along with a choice number
        Foreach ($name in $names) {
            $count++
            Write-Host (" $count`) " + $name.Name)
        }#End Foreach
        Write-Host -ForegroundColor Yellow ("Enter 0 to return to prior menu.")
        $choice = $null
        $choice = Read-Host (" ")               #Ask user for menu choice
        $choice = $choice -replace '\s', ''     #In case user enter spaces
        # MSA name is only the name, no other data
        $msaName = ($names[$choice - 1].Name)
        
    # Loop until user chooses a legit number
    } until($choice -in 0..$length) 
    If($choice -eq 0) {
        # Return zero so progam also knows to break.
        $msaName = 0
        break
    }#End If

    return $msaName

} #End Function Get-OneServiceAccountName
#==============================
