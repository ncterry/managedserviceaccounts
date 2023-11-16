#==============================
Function Get-MSAeventLogs {  
<#
    .SYNOPSIS
    Gather the system Event Logs related to a target Managed Service Account. 

    .DESCRIPTION
    No Parameters. Simply returns the local domain.

    .Example
    Get-MSAeventLogs

    .Example
    Get-MSAeventLogs $days 7
    # Search event logs for all Managed Service accounts going back 7 days

    .Example
    Get-MSAeventLogs $days 7 $targetName "TestMSA123"
    # Search event logs for Managed Service account, TestMSA123, going back 7 day
    .OUTPUTS
    Return:
#>  
#==============================  
[CmdletBinding()]
Param(
    [Parameter()]
    [int]
    $days, # How many days to search back through the event logs
    [Parameter()]
    [String]
    $targetName # Target name of MSA to search for
) # End Param-------------------------------

    ###JUST AN EXAMPLE OF WHAT CAN BE PULLED FROM THE EVENT LOGS
    ###$A = Get-EventLog -LogName Security -Newest 1
    ###$A | Select-Object -Property *
    <#
    EventID            : 4634
    MachineName        : DC01.WidgetLLC.Internal
    Data               : {}
    Index              : 358834
    Category           : (12545)
    CategoryNumber     : 12545
    EntryType          : SuccessAudit
    Message            : An account was logged off.
                        
                        Subject:
                            Security ID:		S-1-5-21-2778787315-2228761457-209862467-8627
                            Account Name:		DC03$
                            Account Domain:		WIDGETLLC
                            Logon ID:		0x1b932d2
                        
                        Logon Type:			3
                        
                        This event is generated when a logon session is destroyed. It may be positively correlated with a 
                        logon event using the Logon ID value. Logon IDs are only unique between reboots on the same 
                        computer.
    Source             : Microsoft-Windows-Security-Auditing
    ReplacementStrings : {S-1-5-21-2778787315-2228761457-209862467-8627, DC03$, WIDGETLLC, 0x1b932d2...}
    InstanceId         : 4634
    TimeGenerated      : 2/28/2022 2:24:55 PM
    TimeWritten        : 2/28/2022 2:24:55 PM
    UserName           : 
    Site               : 
    Container          : 

    #>

    $directory1 = "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\ServiceAccounts\msaEventLogs\"
    $timestamp = Get-Date -f 'yyyy-MM-dd-HHmmss'

            
    # Create directory if it does not exist.
    If (!(Test-Path -Path $directory1)) {
        New-Item -ItemType Directory $directory1
    }#End If


    # Gather all local Managed Service Account names.
    # Or search for just the target MSA
    $msanames = $null
    If ($targetName -eq "") {
        $msanames = Get-AllManagedServiceAccounts
        # To get a single name:    $msanames[0].name
    } else {
        $msanames = Get-ADServiceAccount $targetName
    }#End If/else


    # Terminal progress statements.
    Write-Host -ForegroundColor Yellow ("Gathering Event Logs...")
    Write-Host -ForegroundColor Yellow ("Results stored at: `n$directory1")
    $count = 0
    # Target log attributes to save.
    $logArray = @("LogName", "Id", "TimeCreated", "MachineName",  "Message")
    # Timeframe for range to search through event logs.
    $begin = (Get-Date).AddDays(-$days)
    $end = Get-Date


    # Count of number of MSAs collected.
    $total = $msanames.Count
    Foreach ($msa in $msanames) {
        
        $count++

        # Progress bar for all MSAs vs just one target MSA
        If ($total -gt 1) {
            Write-Progress -Activity ("Event Logs  >>  Search for: " + $msa.name + "  >>  Going back $days days") -Status "This can take a significant amount of time. Processing..." -PercentComplete ($count/$total*100)
        } else {
            # There is only 1 target, just chop the progress bar in half.
            Write-Progress -Activity ("Event Logs  >>  Search for: " + $msa.name + "  >>  Going back $days days") -Status "This can take a significant amount of time. Processing..." -PercentComplete ($count/2*100)
        }#End If/Else
        
        
        # Search only security logs, within this timeframe.
        $filter = @{
            LogName = 'Security'
            StartTime = $begin
            EndTime = $end
        }#End $filter

        # Gather event logs based on filter attributes and the target MSA
        $logs = Get-WinEvent -FilterHashtable $filter | Where-Object {$_.Message.Contains($msa.name) }

        # Create results variable, and a file for the results.
        $resultsFile = $directory1 + $msa.name + "_EventLogs_$timestamp.txt"
        New-Item -ItemType File $resultsFile

        # Header text for the file before MSA event log results - state the eventlog timeframe.
        $timeFrame = "Event Log TimeFrame: $begin - $end"
        $timeFrame | Add-Content -Path $resultsFile
        
        # Add data, and aesthetic/seperation lines to the file. Easier for user to read.
        Foreach ($log in $logs) { 
            "*******************" | Add-Content -Path $resultsFile
            "*******************" | Add-Content -Path $resultsFile
            "*******************" | Add-Content -Path $resultsFile
            "*******************" | Add-Content -Path $resultsFile
            "*******************" | Add-Content -Path $resultsFile
            $msa.name | Add-Content -Path $resultsFile
            ForEach ($attribute in $logArray) {
                $attribute + ": " + $log.$attribute | Add-Content -Path $resultsFile

            }#End Foreach 3       
        }#End Foreach 2
    }#End Foreach 1

    # All results for Service Account event logs have been saved to this file
    $fullResults = Get-Content $resultsFile

    # return to display in the terminal as well.
    return $fullResults

    } #End Function Get-MSAeventLogs
    #==============================
