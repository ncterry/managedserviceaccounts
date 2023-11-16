# Primary program run from '\MSAFunctionsModule\RunMSAProgram\'
# .\RunMSAProgram.ps1
#
# This MSA listing escalation can be run on its own, with all options.
# .\#--------Menu.ps1
#-------------------------------------------------
# Function to show the main menu
function Get-MenuTemplate {
    Write-Host("
|======================================================================|
|================--- Managed Service Account Events ---================|
|======================================================================|`n")
    #
    Write-Host(" Selections:
------------------------------------------------------------------------")
    #
    Write-Host -ForegroundColor Yellow ("`n   1) Get Server Status `t`t`t`tEnter: 1")
    Write-Host -ForegroundColor Yellow ("`n   2) Event Logs for Target Managed Service Account `tEnter: 2")
    Write-Host -ForegroundColor Yellow ("`n   3) Event Logs for All Managed Service Accounts `tEnter: 3")
    #
    #
    Write-Host("`n------------------------------------------------------------------------")
    Write-Host -ForegroundColor Yellow ("`n   0) Return to Prior Menu `t`t`t`tEnter: 0`n")
    Write-Host("------------------------------------------------------------------------")
    Write-Host -ForegroundColor Yellow ("`n   HELP   - Enter the number + h  (1h, 2h, 3h...) `tEnter: `'#h`'`n")
    Write-Host -ForegroundColor Red ("   QUIT   - End the MSA Program `t`t`tEnter: `'quit`'`n") 
    Write-Host("------------------------------------------------------------------------")
}# END function Get-MenuTemplate Function

#--------------------------------
# Continuing do loop unless quit
# quit will resort back to the main menu unless program is executed directly by ./1_KeywordSearchMenu.ps1
do
{
    # Clearpage, write out menu, gather user input, account for simple user errors. 
    Write-Host ($Global:lineclear)# Screen can leave residual text. This overwrites before clear
    #Write-Host ("n`n`n")
    Clear-Host
    Get-MenuTemplate #Write this menu (function)
    $choice = Read-Host "`nEnter Choice"  #Ask user for menu choice
    Write-Host ($Global:lineclear)# Screen can leave residual text. This overwrites before clear
    Clear-Host
    $choice = $choice -replace '\s', ''     #In case user enter spaces
    $choice = $choice.ToLower()             #In case user uses any capitol letters.

    # If User input is acceptable, pick from switch list.
    switch ($choice) 
    {
        #------------------------ 
        '1' 
        {
            Get-ServerStatus
            Write-Host -ForegroundColor Yellow ("------------------`n`n")
            Pause

        } # END 1 - Domain
        #------------------------  
        '1h' # Help/Information for 1
        {
            Get-MSAFunctionsModuleHelp -section "1.1"
            Pause

        } # End 2h
        #------------------------  
        #------------------------  
        #------------------------
        '2' 
        {
            $targetNames = Get-AllManagedServiceAccounts
            $nameChoice = $null
            do {
                $count = 0
                Write-Host -ForegroundColor Green ("Choose what MSA/s to search through the Event Logs for:`n")
                #
                Foreach ($name in $targetNames) {
                    $count++
                    Write-Host -ForegroundColor Yellow (" $count`) " + $targetNames[$count - 1].Name)
                }#End Foreach

                # Grab user choice
                $nameChoice = Read-Host ("-------------`n ")
                $nameChoice = $nameChoice -replace '\s', ''     # In case user enter spaces

            } until ($nameChoice -in 0..($targetNames.Count))

            If ($nameChoice -eq 0) {
                break
            } else {
                $msaName = $targetNames[$nameChoice - 1].Name
            }#End If/Else
            

            $daysChoice = $null
            do {
                Write-Host -ForegroundColor Green ("`nHow many days back to search through Event Logs? 1-30 `nEnter 0 to exit.")
                $daysChoice = Read-Host " "                  # Ask user for days to search back on event logs
                $daysChoice = $daysChoice -replace '\s', ''     # In case user enter spaces
            } until ($daysChoice -in 0..30)
            If ($daysChoice -eq 0) {
                break
            }else{
                Get-MSAeventLogs -days $daysChoice -targetName $msaName
            }#End If/Else

            Pause

        } # END 2 - Domain Controller
        #------------------------  
        '2h' # Help/Information for 2
        {
            Pause

        } # End 2h
        #------------------------
        #------------------------  
        #------------------------  
        '3' 
        {
            Write-Host("`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n") # The screen can leave residual text. This overwrites before clear
            Clear-Host
            $daysChoice = $null
            do {
                Write-Host -ForegroundColor Green ("`nHow many days back to search through Event Logs? 1-30 `nEnter 0 to exit.")
                $daysChoice = Read-Host " "                  # Ask user for days to search back on event logs
                $daysChoice = $daysChoice -replace '\s', ''     # In case user enter spaces
            } until ($daysChoice -in 0..30)
            If ($daysChoice -eq 0) {
                break
            }else{
                # "" --> No Text = All
                Get-MSAeventLogs -days $daysChoice -targetName ""
            }#End If/Else

            Pause


        } # END 3 - Domain Controller Advertising Services
        #------------------------  
        '3h' # Help/Information for 3
        {
            Pause

        } # End 3h

        #------------------------ 
        #------------------------  
        #------------------------  
        'quit' 
        {
            $Global:quit = "quit"
            $choice = "0"
        }        
    }#END switch()
    
} until (($choice -eq '0'))  #END do()==================
