# Primary program run from '\MSAFunctionsModule\RunMSAProgram\'
# .\RunMSAProgram.ps1
#
# This MSA listing escalation can be run on its own, with all options.
# .\1_MSAsDomainMenu.ps1
#-------------------------------------------------
# Function to show the main menu
function Get-MSAsDomainMenu {
    Write-Host("
|======================================================================|
|=========================--- MSAs System ---==========================|
|======================================================================|`n")
    #
    Write-Host(" Selections:
------------------------------------------------------------------------")
    #
    Write-Host -ForegroundColor Yellow ("`n   1) View Domain `t`t`t`t`tEnter: 1")
    Write-Host -ForegroundColor Yellow ("`n   2) View Domain Controller `t`t`t`tEnter: 2")
    Write-Host -ForegroundColor Yellow ("`n   3) Domain Controller Public Test `t`t`tEnter: 3")
    Write-Host -ForegroundColor Yellow ("`n   4) Domain NL Test `t`t`t`t`tEnter: 4")
    Write-Host -ForegroundColor Yellow ("`n   5) View Server Status `t`t`t`tEnter: 5")
    #
    #
    Write-Host("`n------------------------------------------------------------------------")
    Write-Host -ForegroundColor Yellow ("`n   0) Return to Prior Menu `t`t`t`tEnter: 0`n")
    Write-Host("------------------------------------------------------------------------")
    Write-Host -ForegroundColor Yellow ("`n   HELP   - Enter the number + h  (1h, 2h, 3h...) `tEnter: `'#h`'`n")
    Write-Host -ForegroundColor Red ("   QUIT   - End the MSA Program `t`t`tEnter: `'quit`'`n") 
    Write-Host("------------------------------------------------------------------------")
}# END function Get-MSAsDomainMenu Function

#--------------------------------
# Continuing do loop unless quit
# quit will resort back to the main menu unless program is executed directly by ./1_KeywordSearchMenu.ps1
do
{
    # Clearpage, write out menu, gather user input, account for simple user errors. 
    Write-Host("`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n") # The screen can leave residual text. This overwrites before clear
    Clear-Host
    Get-MSAsDomainMenu #Write this menu (function)
    
    $choice = Read-Host "`nEnter Choice"   #Ask user for menu choice
    Write-Host("`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n") # The screen can leave residual text. This overwrites before clear
    Clear-Host
    $choice = $choice -replace '\s', ''     #In case user enter spaces
    $choice = $choice.ToLower()             #In case user uses any capitol letters.

    # If User input is acceptable, pick from switch list.
    switch ($choice) 
    {
        #------------------------ 
        '1' 
        {
            Get-MSAsDomain
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
            Get-MSAsDomainController
            Write-Host -ForegroundColor Yellow ("------------------`n`n")
            Pause

        } # END 2 - Domain Controller
        #------------------------  
        '2h' # Help/Information for 2
        {
            Get-MSAFunctionsModuleHelp -section "1.2"
            Pause

        } # End 2h
        #------------------------
        #------------------------  
        #------------------------  
        '3' 
        {
            # Note there will be extensive process pseudo-errors if you have encrypted files.
            # Not an issue for the test, but it will extend the test and indicate the encrypted files.
            $dc = Get-MSAsDomainController -writehost $false
            dcdiag /v /s:$dc
            Write-Output "--------------"
            Pause

        } # END 3 - Domain Controller Advertising Services
        #------------------------  
        '3h' # Help/Information for 3
        {
            Get-MSAFunctionsModuleHelp -section "1.3"
            Pause

        } # End 3h
        #------------------------  
        #------------------------  
        #------------------------
        '4' 
        {
            $dc = Get-MSAsDomainController -writehost $false
            $domain = Get-MSAsDomain -writehost $false
            Write-Output "--------------"
            nltest /server:$dc /dsgetdc:$domain
            Write-Output "--------------"
            Pause

        } # END 4 - Domain Controller Advertising Services
        #------------------------  
        '4h' # Help/Information for 4
        {
            Get-MSAFunctionsModuleHelp -section "1.4"
            Pause

        } # End 4h
        #------------------------  
        #------------------------  
        #------------------------
        '5' 
        {
            Get-ServerStatus
            Pause

        } # END 5
        #------------------------  
        '5h' # Help/Information for 5
        {
            Get-MSAFunctionsModuleHelp -section "1.5"
            Pause

        } # End 5h
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
