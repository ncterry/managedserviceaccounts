# Primary program run from '\MSAFunctionsModule\RunMSAProgram\'
# .\RunMSAProgram.ps1
#
# This MSA listing escalation can be run on its own, with all options.
# .\#--------Menu.ps1
#-------------------------------------------------
# Function to show the main menu
function Get-DomainServiceAccountsMenu {
    Write-Host("
|======================================================================|
|====================--- Domain Service Accounts ---===================|
|======================================================================|`n")
    #
    Write-Host(" Selections:
------------------------------------------------------------------------")
    #
    Write-Host -ForegroundColor Yellow ("`n   1) Gather Domain Service Logon Accounts `t`tEnter: 1")
    Write-Host -ForegroundColor Yellow ("`n   2) Gather All AD Managed Service Accounts `t`tEnter: 2")
    Write-Host -ForegroundColor Yellow ("`n   3) Permissions for All Managed Service Accounts`tEnter: 3")
    Write-Host -ForegroundColor Yellow ("`n   4) Permissions for One Managed Service Account`tEnter: 4")
    Write-Host -ForegroundColor Yellow ("`n   5) All Attributes for a Managed Service Account`tEnter: 5")
    Write-Host -ForegroundColor Yellow ("`n   6) PW Attributes for a Managed Service Account`tEnter: 6")
    #
    #
    Write-Host("`n------------------------------------------------------------------------")
    Write-Host -ForegroundColor Yellow ("`n   0) Return to Prior Menu `t`t`t`tEnter: 0`n")
    Write-Host("------------------------------------------------------------------------")
    Write-Host -ForegroundColor Yellow ("`n   HELP   - Enter the number + h  (1h, 2h, 3h...) `tEnter: `'#h`'`n")
    Write-Host -ForegroundColor Red ("   QUIT   - End the MSA Program `t`t`tEnter: `'quit`'`n") 
    Write-Host("------------------------------------------------------------------------")
}# END function Get-DomainServiceAccountsMenu Function

#--------------------------------
# Continuing do loop unless quit
# quit will resort back to the main menu unless program is executed directly by ./1_KeywordSearchMenu.ps1
do
{
    # Clearpage, write out menu, gather user input, account for simple user errors. 
    Write-Host("`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n") # The screen can leave residual text. This overwrites before clear
    Clear-Host
    Get-DomainServiceAccountsMenu #Write this menu (function)
    
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
            # Call the script location 
            $gl = $PSScriptRoot #Grab location of this function. 
            #C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAprogram\Menu
            $modulePath = $gl.TrimEnd("\Menu") # Primary MSAprogram directory
            $modulePath = $modulePath.TrimEnd("\MSAprogram") # Primary MSAprogram directory
            # Directory for saved script files
            # Need to execute this as a script instead of importing as a function
            $scriptPath = $modulePath + "\commands\Get-ServiceLogonAccounts.ps1" 
            # Execute the script from this program/
            & $scriptPath
            Get-ChildItem
            # Expected location
            #& "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\commands\Get-ServiceLogonAccounts.ps1"

        } # END 1 - Gather Domain Service Logon Accounts
        #------------------------  
        '1h' # Help/Information for 1
        {

            Get-MSAFunctionsModuleHelp -section "3.1"
            Pause

        } # End 1h
        #------------------------  
        #------------------------  
        #------------------------
        '2'
        {
            # View help section for 3.1
            Get-AllManagedServiceAccounts
            Pause

        } #End 2 - Gather All Service Accounts
        #------------------------
        '2h'
        {
            
            Get-MSAFunctionsModuleHelp -section "3.2"
            Pause

        } #End 2h - Gather All Service Accounts
        #------------------------
        #------------------------
        #------------------------
        '3'
        {
            # Gather the permissions that each AD identity has on each Managed Service Account
            Get-MSApermissions -targetMSA "all"
            Pause
            

        } #End 3 - 
        #------------------------
        '3h'
        {
            # View help section for 3.3
            Get-MSAFunctionsModuleHelp -section "3.3"
        } #End 3h - 
        #------------------------
        #------------------------
        #------------------------
        '4'
        {
            do {
                $msaName4 = Get-OneServiceAccountName
                If($msaName4 -eq 0) {break}
                Get-MSApermissions -targetMSA $msaName4
                Pause
            } until($msaName4 -eq 0) # Double-do so user can check numerous msas
                

        } #End 4 - 
        #------------------------
        '4h'
        {
            # View help section for 3.4
            Get-MSAFunctionsModuleHelp -section "3.4"
        } #End 4h - 
        #------------------------
        #------------------------
        #------------------------
        '5'
        {
            do {
                $msaName5 = Get-OneServiceAccountName
                If($msaName5 -eq 0) {break}
                Get-MSAPasswordInfo -targetMSA $msaName5 -attributes "all"
                Pause
            } until($msaName5 -eq 0) # Double-do so user can check numerous msas
            

        } #End 5 - 
        #------------------------
        '5h'
        {
            # View help section for 3.5
            Get-MSAFunctionsModuleHelp -section "3.5"
        } #End 5h - 
        #------------------------
        #------------------------
        #------------------------
        '6'
        {
            do {
                $msaName6 = Get-OneServiceAccountName
                If($msaName6 -eq 0) {break}
                Get-MSAPasswordInfo -targetMSA $msaName6 -attributes "password"
                Pause
            } until($msaName6 -eq 0) # Double-do so user can check numerous msas
            

        } #End 6 - 
        #------------------------
        '6h'
        {
            # View help section for 3.6
            Get-MSAFunctionsModuleHelp -section "3.6"
        } #End 6h - 
        #------------------------
        #------------------------
        #------------------------
        
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
