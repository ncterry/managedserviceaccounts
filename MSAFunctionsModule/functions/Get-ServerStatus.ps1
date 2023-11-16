#==============================
Function Get-ServerStatus {  
<#
    .SYNOPSIS
    Gather the status of domain-based servers. 
    Check if they are accessible, and returns an object array with the
    server names, and each associated status.

    .Example
    Get-ServerStatus


    .OUTPUTS
    Checking Servers..

    Server      : DC01
    active      : True


    Server      : DC03
    Active      : False
#>  
#==============================  
[CmdletBinding()]
Param(
    [Parameter()]
    [bool[]]
    $writehost = $true # Don't want to writeout if called by other function
) # End Param-------------------------------


    # Gather server names from AD
    $serverNames = Get-ServerNames -writehost $true #DC01, DC03
    Write-Host -ForegroundColor Yellow ("`nChecking Server status...")

    $serverArray = @()
    Foreach ($server in $serverNames) {
        $server = $server.Trim()
        
        $smb = $null
        $object = $null
        $status = $null

        # Testing if primary disk in Server is active
        # A true would require connection and admin privileges
        $smb = Test-Path "\\$server\c$"

        # If active, mark and save in array
        If ($smb -eq $true) {
            $status = $true

            $object = New-Object PSObject -Property ([ordered]@{
                Server          = $server
                Active          = $status
            })#End object

            # Add object with active server/status 
            $serverArray += $object


        # If NOT active, mark and save in array
        } else {
            $status = $false

            $object = New-Object PSObject -Property ([ordered]@{
                Server          = $server
                Active          = $status   
            })#End $object

            $serverArray += $object
        }#End If/else
    }#End Foreach


    
    return $serverArray
    #ex.
    #$serverArray[0].server
    #$serverArray[1].active
    

} #End Function Get-ServerStatus
#==============================
