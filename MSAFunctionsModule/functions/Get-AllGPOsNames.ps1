

Function Get-AllMSAsNames {
<#
    .SYNOPSIS
    From the Domain Controller, this collects the associated Group Policy Objects names

    .DESCRIPTION
    No Parameters. Simply returns a list of the names of all MSAS

    .Example
    Get-AllMSAsNames

    .Example
    Get-AllMSAsNames | Out-Gridview

    .OUTPUTS
    (SAMPLE List)
    abc_MSA123
    def_MSA456
    ghi_MSA789
    -------------------------------
#> 

    # Just grab the DNSroot name, (full domain example: WidgetLLC2.Internal).
    $domain = Get-MSAsDomain -writehost $false #$false=Dont print to terminal 


    $allMSAs = Get-MSA -All -Domain $domain #Grab all MSAs on this domain.
    Write-Host("`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n") # The screen can leave residual text. This overwrites before clear
    Clear-Host
    $MSANameArray = @()

    
    # Add all MSA names to an array
    $allMSAs | ForEach-Object {
        $MSANameArray += $_.DisplayName 
    } # End $allMSAs | ForEach-Object-------------------------------


    # Simple array sort in alphabetical order
    $finalNameArray = $MSANameArray | Sort-Object


    #Slight delay. Sometimes Moves too fast when returning in loops.
    Start-Sleep -s 0.5 

    return $finalNameArray

} # End Function Get-AllMSAsName-------------------------------
#============================


