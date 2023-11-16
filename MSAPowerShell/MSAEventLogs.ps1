# returned from the get-serverstaus
#$serverStatus = Get-ServerStatus
#$serverStatus[0]
#$serverStatus[0].Server
#$serverStatus[0].Active



$directory1 = "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata\ServiceAccounts\msaEventLogs\"
$timestamp = Get-Date -f 'yyyy-MM-dd-HHmmss'
$domainName = $env:USERDOMAIN

        
# Create directory if it does not exist.
If (!(Test-Path -Path $directory1)) {
    New-Item -ItemType Directory $directory1
}#End If


# Gather all local Managed Service Account names.
$msanames = Get-AllManagedServiceAccounts


Write-Host -ForegroundColor Yellow ("Gathering Event Logs...")
$count = 0
# Target log attributes to save.
$logArray = @("Index", "EntryType", "InstanceId", "Message", "ReplacementStrings", "Source", "TimeWritten")
$begin = (Get-Date).AddDays(-30)
$end = Get-Date
Foreach ($msa in $msanames) {
    
# Gather list of servers in the domain
    $count++
    $complete = ($count / $msanames.Count) * 100
    Write-Progress -Activity "Gathering Event Logs from $domainName" -Status "Processing..." -PercentComplete ($count/$msanames.count*100)
    
    # Search only security logs, within this timeframe.
    $filter = @{
        LogName = 'Security'
        StartTime = $begin
        EndTime = $end
    }

    $logs = Get-WinEvent -FilterHashtable $filter | Where-Object {$_.Message.Contains($msa.name) }
    $resultsFile = $directory1 + $msa.name + "_EventLogs_$timestamp.txt"
    New-Item -ItemType File $resultsFile
    
    Foreach ($log in $logs) { 
        "*******************" | Add-Content -Path $resultsFile
        "*******************" | Add-Content -Path $resultsFile
        "*******************" | Add-Content -Path $resultsFile
        "*******************" | Add-Content -Path $resultsFile
        "*******************" | Add-Content -Path $resultsFile
        $msa.name | Add-Content -Path $resultsFile
        ForEach ($attribute in $logArray) {
            $attribute + ": " + $log.$attribute | Add-Content -Path $resultsFile

        }       
    }#End Foreach
}


    


  
  
    
    
            
    
