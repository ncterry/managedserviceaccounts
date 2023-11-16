#==============================
Function Get-TargetServices {  
<#
    .SYNOPSIS
    Gather the full schematics for an individual, targeted Managed Service Account in this AD

    .DESCRIPTION
    No Parameters. Simply returns the local domain.

    .Example
    Get-TargetServices

    .Example
    Get-TargetServices $writehost $true
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


    # Full service cycle loop. After 1 service, the loop lets user pick another service
    do {

        
        $choice, $choice1 = $null
        # Gather all services
        $services = Get-Service
        # 2 Column list will be printed, so only go halfway
        # Remove last value since array numbering starts at 0
        $cnt = ($services.Count) - 1
        # The list of numbers 1 to the amount of services.
        $cntList = 0..$cnt
    
    
        do {
            # Clear the terminal screen before the next list.
            Clear-Host
            # List out all of the numbered services
            # num will start at 0
            Write-Host -ForegroundColor Yellow ("`n----------All Active Services----------`n")
            Foreach ($num in $cntList) {

                # 40 based on longest service name
                # Used to add spaces in the terminal listing printout
                $spacing = 40 - ($services[$num].Name).Length

                # Slight formatting and aesthetic differences on list. 
                If ($num -eq 0) {
                    $srv1 = $num
                    $srv2 = $num + 1
                    $spot1 = $num + 1
                    $spot2 = $num + 2
                    # $services is accessed by array-numbering:   0 - ...        
                    Write-Host (" $spot1`)  " + $services[$srv1].Name + (" " * $spacing + "`t") + "$spot2`)  " + $services[$srv2].Name)

                # Visually adjust formatting on single  digits (change spacing)
                } ElseIf (($num -ne 1) -and ($num % 2 -ne 0) -and ($num -lt 9)) {
                    $srv1 = $num
                    $srv2 = $num + 1
                    $spot1 = $num
                    $spot2 = $num + 1
                    # $services is accessed by array-numbering:   0 - ...        
                    Write-Host (" $spot1`)  " + $services[$srv1].Name + (" " * $spacing + "`t") + "$spot2`)  " + $services[$srv2].Name)

                # Visually adjust formatting on single digits change from 9>>10 (change spacing)
                } ElseIf ($num -eq 9) {
                    $srv1 = $num
                    $srv2 = $num + 1
                    $spot1 = $num
                    $spot2 = $num + 1
                    # $services is accessed by array-numbering:   0 - ...        
                    Write-Host (" $spot1`)  " + $services[$srv1].Name + (" " * $spacing + "`t") + "$spot2`) " + $services[$srv2].Name)


                } ElseIf (($num -ne 1) -and ($num % 2 -ne 0)) {
                    $srv1 = $num
                    $srv2 = $num + 1
                    $spot1 = $num

                    # Allow for end of list. 
                    # Mark so user can see no service in this position.
                    If (($services[$srv1].Name).Length -eq 0) {$spot1 = "---"}
                    $spot2 = $num + 1
                    If (($services[$srv2].Name).Length -eq 0) {$spot2 = "---"}

                    # $services is accessed by array-numbering:   0 - ...        
                    Write-Host (" $spot1`) " + $services[$srv1].Name + (" " * $spacing + "`t") + "$spot2`) " + $services[$srv2].Name)

                }#End If/ElseIF
            }#End Foreach


            # Get user to choose one of the active services
            Write-Host -ForegroundColor Yellow ("`nChoose which service to target. `nEnter 0 to return to prior menu.`n")
            $choice1 = Read-Host " "
            
        } until (($choice1 -eq 0) -or ($cntList -contains $choice1))
        If ($choice1 -eq 0) { break }

        # Set choice service from array
        $targetService = $services[($choice1)].Name




        # Got the target service, on local host, now view property/s from that service
        $serviceProperties = @("Name", "RequiredServices", "Disposed", "Close", "Continue", "CreateObjRef", "Dispose", "Equals", "ExecuteCommand", "GetHashCode", "GetLifetimeService", "GetType", "InitializeLifetimeService", "Pause", "Refresh", "Start", "Stop", "WaitForStatus", "CanPauseAndContinue", "CanShutdown", "CanStop", "Container", "DependentServices", "DisplayName", "MachineName", "ServiceHandle", "ServiceName", "ServicesDependedOn", "ServiceType", "StartTySitepe", "StartType", "ToString", "Status")
        $cnt = $serviceProperties.Count 
        $cntList = 1..$cnt



        # Capture which property/s a user would like to see for a service.
        $propertyAction = $null
        
        do {
            Clear-Host
            Write-Host -ForegroundColor Yellow("`n`n----- Service:  $targetService `n")
            Write-Host -ForegroundColor Yellow(" 1) View all service properties")
            Write-Host -ForegroundColor Yellow(" 2) View one target service property")
            Write-Host -ForegroundColor Yellow(" 0) Return to prior menu")
            
            $propertyAction = Read-Host (" ")

        } until (0..2 -contains $propertyAction)
        If ($propertyAction -eq 0) { break }


        # For '2', user will pick a single/target property to view for a chosen service.
        # 
        If ($propertyAction -eq 2) {
            # We have the targetd Service, now list the service properties, and let user chose which to gather.
            do {
                # Clear the terminal screen before the next list.
                Clear-Host
                $num = 0
                Write-Host -ForegroundColor Yellow ("`n--- Target Service Properties ")
                Write-Host -ForegroundColor Yellow ("--- For Service: $targetService `n")
                Foreach ($property in $serviceProperties) {
                    $num++
                    Write-Host (" $num`) $property")
                }#End Foreach


                # Get user to choose one of the active service properties
                Write-Host -ForegroundColor Yellow ("`nChoose which property to view. `nEnter 0 to return to prior menu.`n")
                $choice = Read-Host " "
            }until (($choice -eq 0) -or ($cntList -contains $choice))#End do/until
            If ($choice -eq 0) { break }



            Clear-Host
            # Show users results for their chosen service, and the target property for that service
            $targetProperty = $serviceProperties[($choice - 1)]
            Write-Host -ForegroundColor Yellow ("`n Target Service: `t`t" + (Get-Service -Name $targetService).Name)
            Write-Host -ForegroundColor Yellow (" Target Service Property: `t$targetProperty `n---")
            (Get-Service -Name $targetService).$targetProperty
            Write-Host ("`n`n`n---")
            Pause
        
        } else {

            # User chose 1
            # View all properties for a target service
            Get-Service $targetService | Select-Object *
            Pause

        }#End If/Else
    # Allow user to cycle through choices until they intentionally exit
    } until ($choice1 -eq 0)


} #End Function Get-TargetServices
#==============================
