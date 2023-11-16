#==============================
Function Set-HTMLreport {  
<#
    .SYNOPSIS
    Gather the --- this machine.

    .DESCRIPTION
    No Parameters. Simply returns the local domain.

    .Example
    Set-HTMLreport

    .Example
    Set-HTMLreport $writehost $true
    # Will return the domain to a function, and write the domain in terminal.

    .OUTPUTS
    Return:
#>  
#==============================  
[CmdletBinding()]
Param(
    [Parameter(Mandatory = $false)]
    [string]
    $domainName


) # End Param-------------------------------

    <#    
        Check asociated servers
        Gather info from related service accounts
        Generate a report with domain accounts used as service logon account.      
    #>

    $SA_Report = "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\serviceAccountReport.html"
    $maxThreads = 10
    $domainName = $env:USERDOMAIN.ToUpper()
    $SA_Hashtable = @{}
    [string[]]$warnings = @() 


    $gatherSAs = {

    # Retrieve service list form a remote machine

        param( $hostname )
        if ( Test-Connection -ComputerName $hostname -Count 3 -Quiet ){
            try {
                $listOFservices = @( gwmi -Class Win32_Service -ComputerName $hostname -Property Name,StartName,SystemName -ErrorAction Stop )
                $listOFservices
            } catch {
                "Could not gather $hostname data: $($_.toString())"
            }#End try/catch
        } else {
            "$hostname inaccessible"
        }#End if/else        
    }#End $gatherSAs



    function finishedJobs(){
        # reads service list from completed jobs,updates $SA table and removes completed job

        $listOFjobs = Get-Job -State Completed
        foreach( $job in $listOFjobs ) {

            $jobInfo = Receive-Job $job 
            Remove-Job $job 
            
            if ( $jobInfo.GetType() -eq [Object[]] ){
                $listOFservices = $jobInfo | ? { $_.StartName.toUpper().StartsWith( $domainName )}
                foreach( $service in $listOFservices ){
                    $account = $service.StartName
                    $instance = "`"$($service.Name)`" service on $($service.SystemName)" 
                    if ( $script:SA_Hashtable.Contains( $account ) ) {
                        $script:SA_Hashtable.Item($account) += $instance
                    } else {
                        $script:SA_Hashtable.Add( $account, @( $instance ) ) 
                    }#End if/else
                }#End foreach
            } elseif ( $jobInfo.GetType() -eq [String] ) {
                $script:warnings += $jobInfo
                Write-warning $jobInfo
            }#End if/elseif
        }#End foreach
    }#End function finishedJobs(){


    #################    MAIN   #########################


    Import-Module ActiveDirectory


    # read computer accounts from current domain
    Write-Progress -Activity "Gather list of servers from $domainName" -Status "Processing..." -PercentComplete 0 
    $listOFservers = Get-ADComputer -Filter {OperatingSystem -like "Windows Server*"} -Properties DNSHostName, cn | ? { $_.enabled } 


    # start data retrieval job for each server in the list
    # use up to $maxThreads threads
    $numOFservers = 0
    foreach( $server in $listOFservers ) {
        Start-Job -ScriptBlock $gatherSAs -Name "read_$($server.cn)" -ArgumentList $server.dnshostname | Out-Null
        ++$numOFservers
        Write-Progress -Activity "Gathering information from servers" -Status "Processing..." -PercentComplete ( $numOFservers * 100 / $listOFservers.Count )
        while ( ( Get-Job -State Running).count -ge $maxThreads ) { 
            Start-Sleep -Seconds 3 
        }#End while
        # Function
        finishedJobs
    }#End foreach


    # Handle jobs 
    Write-Progress -Activity "Gathering information from servers" -Status "In Progress..." -PercentComplete 100
    Wait-Job -State Running -Timeout 30  | Out-Null
    Get-Job -State Running | Stop-Job
    # Function
    finishedJobs


    # prepare data table for report
    Write-Progress -Activity "Creating report" -Status "In Progress..." -PercentComplete 100
    $SAtable = @()
    foreach( $SA in $SA_Hashtable.Keys )  {
        foreach( $instance in $SA_Hashtable.item($SA)  ){
            $row = new-object psobject
            Add-Member -InputObject $row -MemberType NoteProperty -Name "Account" -Value $SA
            Add-Member -InputObject $row -MemberType NoteProperty -Name "Usage" -Value $instance
            $SAtable  += $row
        }#End foreach2
    }#End foreach1


    # Put data from service accounts into html report
    $report = "
    <!DOCTYPE html>
    <html>
    <head>
    <style>
    TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;white-space:nowrap;} 
    TH{border-width: 1px;padding: 4px;border-style: solid;border-color: black} 
    TD{border-width: 1px;padding: 2px 10px;border-style: solid;border-color: black} 
    </style>
    </head>
    <body> 
    <H1>Service account report for $domainName domain</H1> 
    $($listOFservers.count) servers processed. Discovered $($SA_Hashtable.count) service accounts.
    <H2>Discovered service accounts</H2>
    $( $SAtable | Sort Account | ConvertTo-Html Account, Usage -Fragment )
    <H2>Warning messages</H2> 
    $( $warnings | % { "<p>$_</p>" } )
    </body>
    </html>"  

    Write-Progress -Activity "Generating report" -Status "Please wait..." -Completed
    $report  | Set-Content $SA_Report -Force 
    Invoke-Expression $SA_Report 


} #End Function Set-HTMLreport
#==============================
