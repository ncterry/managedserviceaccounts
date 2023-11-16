#==============================
Function Get-Services {  
<#
    .SYNOPSIS
    Gather the all services from an active machine.

    .DESCRIPTION
    This will gather all services from a target server; however, only if the server is currently running.

    .Example
    # Default gather all services, from all running servers
    Get-Services

    .Example
    # Gather all services from machine DC01
    Get-Services -machineName "DC01"
    
    .Example
    # Gather all services from machine DC01. that are Running
    Get-Services -machineName "DC01" -status "Running"

    .OUTPUTS
    ...
    ExitCode  : 1077
    Name      : TestMSAservice2
    ProcessId : 0
    StartMode : Manual
    State     : Stopped
    Status    : OK
    ...
#>  
#==============================  
[CmdletBinding()]
Param(
    [Parameter()]
    [String]
    $machineName = "All", #Start as null unless sent in from function call

    [Parameter()]
    [String]
    $status = "All", #Services Status: 'All', 'Running', 'Stopped'

    [Parameter()]
    [bool[]]
    $writehost = $true # Don't want to writeout if called by other function

) # End Param-------------------------------

    # Sent in target machine name via Parameter
    # Or else:
    # Can gather a list of local servers:
    $services = $null
    $domain = Get-ADDomain -Current LocalComputer  | Select-Object -ExpandProperty DNSRoot 
    $gl = $PSScriptRoot #Grab location of this function. Should be in ...MSAFunctionModule\functions
    $functionPath = $gl.TrimEnd("\functions") # Primary MSAprogram directory
    $msaDataPath = $functionPath + "\MSAdata\Services\" # Directory for saved result files
    $timestamp = Get-Date -f 'yyyy-MM-dd-HHmmss'


    # Collect services from all active servers since no target machine was sent in.
    If ($null -eq $Global:servers) {
        $Global:servers = Get-ServerStatus
    }#End If
                

    # Gather all services from all active machines
    # If no machine target is entered as a param, then default to All
    If (($machineName -eq "") -or ($machineName -eq "All")) {
        Foreach ($num in (0..($Global:servers.Count - 1))) {
            Write-Host -ForegroundColor Yellow ("**********")
            Write-Host -ForegroundColor Yellow ("View Services for:")
            Write-Host -ForegroundColor Yellow ("Domain: $domain")
            Write-Host -ForegroundColor Yellow ("Server: ")
            $Global:servers[$num].server # Need to seperate this format from Write-Host
            Write-Host -ForegroundColor Yellow ("**********")
            If($Global:servers[$num].active -eq $false) {
                Write-Host -ForegroundColor Red ("Machine:")
                $Global:servers[$num].server # Need to seperate this format from Write-Host
                Write-Host -ForegroundColor Red ("is not active.")
            }
            #Pause #Displays target server, then collects/displays services once user presses enter.
            
            
            If (($status -eq "All") -and ($Global:servers[$num].active -eq $true)) {
                # Gather All services on each active server
                # Define title for results file.
                $fileName = $msaDataPath +  $Global:servers[$num].server + "_" + $timestamp + "_AllServices.txt"
                # Get ALL services on target machine, and print to file
                Get-Service -ComputerName $Global:servers[$num].server | Format-Table Name, Status, MachineName -AutoSize | Out-File $fileName
                # Print content to terminal also
                Get-Content $fileName

            
            } elseif (($status -eq "Running") -and ($Global:servers[$num].active -eq $true)) {
                # Only gather Running services on each active server
                # Define title for results file.
                $fileName = $msaDataPath +  $Global:servers[$num].server + "_" + $timestamp + "_RunningServices.txt"
                # Get running services on target machine, and print to file
                Get-Service -ComputerName $Global:servers[$num].server | Where-Object {$_.Status -eq "Running"} | Format-Table Name, Status, MachineName -AutoSize | Out-File $fileName
                # Print content to terminal also
                Get-Content $fileName


            } elseif (($status -eq "Stopped") -and ($Global:servers[$num].active -eq $true)) {
                # Only gather Stopped services on each active server                
                # Define title for results file.
                $fileName = $msaDataPath +  $Global:servers[$num].server + "_" + $timestamp + "_StoppedServices.txt"
                # Get stopped services on target machine, and print to file
                Get-Service -ComputerName $Global:servers[$num].server | Where-Object {$_.Status -eq "Stopped"} | Format-Table Name, Status, MachineName -AutoSize | Out-File $fileName
                # Print content to terminal also
                Get-Content $fileName


            }#End If/elseif/elseif
            

            # Print services to terminal screen. Not needed?
            #$services  

            Write-Host -ForegroundColor Yellow ("**********")


        }#End Foreach
        # Tell user in terminal the location of the results file.
        Write-Host -ForegroundColor Green ("Results stored at: $msaDataPath`n Timestamp: $timestamp")
        Pause
        # Don't print all services, and return them since we arent targeted above.
        break


    # If user wants RUNNING services from a target machine
    } elseif (($machineName -ne $null) -and ($status -eq "All")) {    
        # For each server, find services running
        # Print service results to a results file. 
        $fileName = $msaDataPath +  $machineName + "_" + $timestamp + "_AllServices.txt"
        # Tell user in terminal the location of the results file.
        Get-Service -ComputerName $machineName | Format-Table Name, Status, MachineName -AutoSize | Out-File $fileName
        # Print content to terminal also
        Get-Content $fileName

        Write-Host -ForegroundColor Green ("Results stored at: $msaDataPath`n Timestamp: $timestamp")
        Pause
    
    
    # If user wants RUNNING services from a target machine
    } elseif (($machineName -ne $null) -and ($status -eq "Running")) {    
        # For each server, find services running
        # Print service results to a results file. 
        $fileName = $msaDataPath +  $machineName + "_" + $timestamp + "_RunningServices.txt"
        # Tell user in terminal the location of the results file.
        Get-Service -ComputerName $machineName | Where-Object {$_.Status -eq "Running"} | Format-Table Name, Status, MachineName -AutoSize | Out-File $fileName
        # Print content to terminal also
        Get-Content $fileName

        Write-Host -ForegroundColor Green ("Results stored at: $msaDataPath`n Timestamp: $timestamp")
        Pause


    # If user wants STOPPED services from a target machine
    } elseif (($machineName -ne $null) -and ($status -eq "Stopped")){
        # For each server, find services running
        # Print service results to a results file. 
        $fileName = $msaDataPath +  $machineName + "_" + $timestamp + "_StoppedServices.txt"
        # Tell user in terminal the location of the results file.
        Get-Service -ComputerName $machineName | Where-Object {$_.Status -eq "Stopped"} | Format-Table Name, Status, MachineName -AutoSize | Out-File $fileName
        # Print content to terminal also
        Get-Content $fileName

        Write-Host -ForegroundColor Green ("Results stored at: $msaDataPath`n Timestamp: $timestamp")
        Pause
        
    }#End if/elseif/else


    # Example: Gather just those services starting with 'Test'
    # These look like they start with Test, but still needed the  *  in front. 
    #$testservices = Get-WmiObject -Class win32_service | Where-Object {$_.StartName -like "*Test*"}


     return $services

} #End Function Get-Services
#==============================
