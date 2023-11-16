
        
        
        #************NOTE************
        #************NOTE************
        #************NOTE************

        # This must be called as a script
        # From Terminal:
        # > .\Get-ServiceLogonAccounts.ps1
        #
        # From another script:
        # > & "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\commands\Get-ServiceLogonAccounts.ps1"
        #
        # This will not work if called as a function.

        #************NOTE************
        #************NOTE************
        #************NOTE************
        #
        <#|=========================EXAMPLE OUTPUT===============================|
            Service account report for domain:
                WIDGETLLC

        |======================================================================|
            2 servers found:
                CN=DC01,OU=Domain Controllers,DC=WidgetLLC,DC=Internal
                CN=DC03,CN=Computers,DC=WidgetLLC,DC=Internal

        |======================================================================|
            Discovered service accounts:
            02/18/2022 13:20:38
            2 service accounts found.
                @{Account=WIDGETLLC\TestMSA123$; Usage="TestMSAservice2" service on DC01}
                @{Account=WIDGETLLC\TestMSA$; Usage="TestMSAservice" service on DC01}

        |======================================================================|
            Notifications:
            
        ------------------#>




        # Check asociated servers
            # Gather info from related service accounts
            # Generate a report with domain service accounts that are used as service logon account.      
            
            
            # Location for MSA data, and the SA results file.
            # This is a default system location:  C:\Program Files\WindowsPowerShell\Modules\
            # Checking if the MSAFunctionsModule has been run
            # If not, create the directory for the results.
            $directory1 = "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\"
            $directory2 = "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\ServiceAccounts\"
            $directory3 = "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\ServiceAccounts\msaLogonReports\"
            $timestamp = Get-Date -f 'yyyy-MM-dd-HHmmss'
            $SA_Report = $directory3 + "msa_LogonReport_$timestamp.txt"
            
            If (!(Test-Path -Path $directory1)){
                New-Item -ItemType Directory $directory1
                New-Item -ItemType Directory $directory2
                New-Item -ItemType Directory $directory3
                New-Item -ItemType File $SA_Report

            } elseIf (!(Test-Path -Path $directory2)) {
                New-Item -ItemType Directory $directory2
                New-Item -ItemType Directory $directory3
                New-Item -ItemType File $SA_Report

            } elseIf (!(Test-Path -Path $directory3)) {
                New-Item -ItemType Directory $directory3
                New-Item -ItemType File $SA_Report

            } elseIf (!(Test-Path -Path $SA_Report)) {
                New-Item -ItemType File $SA_Report

            } else {
                Remove-Item -Path $SA_Report
                New-Item -ItemType File $SA_Report
            }#End If/Elsee
            

            $domainName = $env:USERDOMAIN
            $SA_Hashtable = @{}
            [string[]]$warnings = @() 
            

            
            #------------------------------------------------------------------------------
            #------------------------------------------------------------------------------
            #------------------------------------------------------------------------------

            # Gathers services from jobs, adds to $SA table and removes completed job
            function finishedJobs(){
                $domainName = $env:USERDOMAIN

                # Get list of completed jobs
                # A job is a piece of code that is executed in the background.
                # Get-Job = gets powershell background jobs that are running in the current session.
                $listOFjobs = Get-Job -State Completed
                # When a job is completed, pull from list.
                foreach( $job in $listOFjobs ) {
                    #EX:        job = System.Management.Automation.PSRemotingJob

                    # Receive-Job = Target a specific job, and gather results info such as if completed.
                    $jobInfo = Receive-Job $job 
                    Remove-Job $job 
                    
                    if ( $jobInfo.GetType() -eq [Object[]] ) {
                        
                        # Remove null values from Jobinfo
                        $jobInfo = $jobInfo | Where-Object {$null -ne $_.StartName}

                        #EX:    $domainname = WIDGETLLC
                        $listOFservices = $jobInfo | Where-Object { $_.StartName.StartsWith( $domainName )}

                        foreach( $service in $listOFservices ) {
                            #EX:        service = Win32_Service.Name="TestMSA"
                            #EX:        TestMSA service on DC01
                            $serviceStartName = $service.StartName
                            $instance = "`"$($service.Name)`" service on $($service.SystemName)" 

                            if ( $script:SA_Hashtable.Contains( $serviceStartName ) ) {
                                $script:SA_Hashtable.Item($serviceStartName) += $instance
                            } else {
                                $script:SA_Hashtable.Add( $serviceStartName, @( $instance ) ) 
                            }#End if/else
                        }#End foreach2
                    } elseif ( $jobInfo.GetType() -eq [String] ) {
                        $script:warnings += $jobInfo
                        Write-warning $jobInfo
                    }#End if/elseif
                }#End foreach1
            }#End function finishedJobs(){


            #------------------------------------------------------------------------------
            #------------------------------------------------------------------------------
            #------------------------------------------------------------------------------


            # Gathers list of services from servers
            $gatherSAs = {

                param( $hostname )
                if ( Test-Connection -ComputerName $hostname -Count 3 -Quiet ){
                    try {
                        $listOFservices = @( gwmi -Class Win32_Service -ComputerName $hostname -Property Name,StartName, SystemName -ErrorAction Stop )

                        $listOFservices
                    } catch {
                        "Could not gather $hostname data: $($_.toString())"
                    }#End try/catch
                } else {
                    "$hostname inaccessible"
                }#End if/else        
            }#End $gatherSAs


            #------------------------------------------------------------------------------
            #------------------------------------------------------------------------------
            #------------------------------------------------------------------------------
            #------------------------------------------------------------------------------
            #------------------------------------------------------------------------------
            #------------------------------------------------------------------------------

        
            # Gather list of servers in the domain
            Write-Progress -Activity "Gather list of servers from $domainName" -Status "Processing..." -PercentComplete 0 

            $listOFservers = Get-ADComputer -Filter {OperatingSystem -like "Windows Server*"} -Properties DNSHostName, cn | Where-Object { $_.enabled } 

            # Pick data from each server
            # Be careful, and dont abuse system threads.
            Import-Module ActiveDirectory
            $numOFservers = 0

            Foreach( $server in $listOFservers ) {
                Start-Job -ScriptBlock $gatherSAs -Name "read_$($server.cn)" -ArgumentList $server.dnshostname | Out-Null
                
                ++$numOFservers
                
                Write-Progress -Activity "Gathering information from servers" -Status "Processing..." -PercentComplete ( $numOFservers * 100 / $listOFservers.Count )
                
                # Limit job state search with a threadcount of 10
                While ( ( Get-Job -State Running).count -ge 10 ) { 
                    Start-Sleep -Seconds 3 
                }#End while
                # Call Function
                finishedJobs -ErrorAction 'SilentlyContinue' 
            }#End foreach


            # Handle all jobs 
            Write-Progress -Activity "Gathering information from servers" -Status "In Progress..." -PercentComplete 100
            
            Wait-Job -State Running -Timeout 30  | Out-Null
            
            Get-Job -State Running | Stop-Job
            # Call Function
            finishedJobs -ErrorAction 'SilentlyContinue' 


            # Put the data together in a table
            Write-Progress -Activity "Creating report" -Status "In Progress..." -PercentComplete 0
            $SAtable = @()
            Foreach( $SA in $SA_Hashtable.Keys )  {
                Foreach( $instance in $SA_Hashtable.item($SA)) {

                    $row = new-object psobject
                    
                    Add-Member -InputObject $row -MemberType NoteProperty -Name "Account" -Value $SA
                    
                    Add-Member -InputObject $row -MemberType NoteProperty -Name "Usage" -Value $instance
                    
                    $SAtable  += $row
                }#End foreach2
            }#End foreach1

            $runtime = Get-Date
            

# Code formatting is justtified. Keep to the left.
Add-Content $SA_Report ("
|======================================================================|
    Service account report for domain:
        $domainName

|======================================================================|
    $($listOFservers.count) servers found:")#End Add-Content
    Foreach($server in $listOFservers) {
        Add-Content $SA_Report ("`t$server")
    }#End foreach

Add-Content $SA_Report ("
|======================================================================|
    Discovered service accounts using logon privileges:
    $runtime
    $($SA_Hashtable.count) service accounts found.")#End Write-Host
    Foreach($SA in $SAtable) {
        Add-Content $SA_Report ("`t$SA")
    }#End foreach

Add-Content $SA_Report ("
|======================================================================|
    Notifications:
    `t$( $warnings | ForEach-Object { "$_" } )
")#End Write-Host

# Print the same info to the terminal screen for the user.
Get-Content $SA_Report


            # Terminal info
            Write-Progress -Activity "Generating report" -Status "Please wait..." -Completed
            Write-Host -ForegroundColor Yellow ("------------------`n`n")
            Pause
