
$targetName = "TestMSA456"

#$targetName = ""
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

write-host -ForegroundColor Green ("msanames = " + $msanames)

Write-Host -ForegroundColor Yellow ("Gathering Event Logs...")
Write-Host -ForegroundColor Yellow ("Results stored at: `n$directory1")
$count = 0
# Target log attributes to save.
$logArray = @("Index", "EntryType", "InstanceId", "Message", "ReplacementStrings", "Source", "TimeWritten")
$begin = (Get-Date).AddDays(-$days)
$end = Get-Date


Foreach ($msa in $msanames) {
        
# Gather list of servers in the domain
    $count++
    Write-Progress -Activity ("Event Logs  >>  Search for: "+ $msa.name + "  >>  Going back $days days") -Status "This can take a significant amount of time. Processing..." -PercentComplete ($count/$msanames.count*100)
     }   
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
