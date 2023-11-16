# Primary program run from '\MSAFunctionsModule\RunMSAProgram\'
# .\RunMSAProgram.ps1
#
# This MSA listing escalation can be run on its own, with all options.
# .\ServiceInfoMenu.ps1
#-------------------------------------------------
# -----------------------------------------
# -----------------------------------------
# Function to gather user choice for which machine to target on 3 sections here.
function Get-Choice {
#==============  
[CmdletBinding()]
Param(
    [Parameter()]
    [string]
    $action = "All" #Running, Stopped, or All --> Default to All
) # End Param-------------------------------

    $num = 0
    $choice = $null
    Write-Host -ForegroundColor Yellow ("`n ---------Servers---------")
    Foreach ($server in $servers) {
        $num++
        Write-Host -ForegroundColor Yellow (" $num) " + $servers[$num-1].Name)
    }#End Foreach


    Write-Host -ForegroundColor Yellow ("`n 0) Return to Prior Menu `t`tEnter: 0`n")
    Write-Host -ForegroundColor Yellow (" Choose which server to gather $action services from.")
    $numEnd = $servers.count
    Write-Host ("`n Enter Choice: `(1 - $numEnd`)")  #Ask user for menu choice
    
    do {
        $choice = Read-Host (" ")  #Ask user for menu choice
        $choice = $choice -replace '\s', ''   #In case user enters spaces
    }until (($choice -le $numEnd) -and ($choice -ne ""))
    # Break out of loop if user picks 0
    return $choice
}#End function Get-Choice
# -----------------------------------------
# -----------------------------------------
# -----------------------------------------
# Function to show the main menu
function Get-MenuTemplate {
    Write-Host("
|======================================================================|
|======================--- Service Info Menu ---=======================|
|======================================================================|`n")
    #
    Write-Host(" Selections:
------------------------------------------------------------------------")
    #
    Write-Host -ForegroundColor Yellow ("`n   1) Server Info `t`t`t`t`tEnter: 1")
    Write-Host -ForegroundColor Yellow ("`n   2) Domain: ALL Services  `t`t`t`tEnter: 2")
    Write-Host -ForegroundColor Yellow ("`n   3) Domain: RUNNING Services `t`t`t`tEnter: 3")
    Write-Host -ForegroundColor Yellow ("`n   4) Domain: STOPPED Services `t`t`t`tEnter: 4")
    Write-Host -ForegroundColor Yellow ("`n   ----------")
    Write-Host -ForegroundColor Yellow ("`n   5) Target Machine: ALL Services  `t`t`tEnter: 5")
    Write-Host -ForegroundColor Yellow ("`n   6) Target Machine: RUNNING Services `t`t`tEnter: 6")
    Write-Host -ForegroundColor Yellow ("`n   7) Target Machine: STOPPED Services `t`t`tEnter: 7")
    Write-Host -ForegroundColor Yellow ("`n   ----------")
    Write-Host -ForegroundColor Yellow ("`n   8) Targeted Service and Related Properties `t`tEnter: 8")

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
    Write-Host("`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n") # The screen can leave residual text. This overwrites before clear
    Clear-Host
    Get-MenuTemplate #Write this menu (function)
    
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
            Get-ServerNames -writehost $true
            Write-Host -ForegroundColor Yellow ("------------------`n`n")
            Pause

        } # END 1 - Domain
        #------------------------  
        '1h' # Help/Information for 1
        {
            Get-MSAFunctionsModuleHelp -section "3.1"
            Pause

        } # End 2h
        #------------------------  
        #------------------------  
        #------------------------
        '2' 
        {
            # Get ALL Services from all running servers
            Get-Services -machineName "All" -status "All"
            Pause

        } # END 2 - Domain Controller
        #------------------------  
        '2h' # Help/Information for 2
        {
            Get-MSAFunctionsModuleHelp -section "3.2"
            Pause

        } # End 2h
        #------------------------
        #------------------------  
        #------------------------  
        '3' 
        {
            # Get RUNNING Services from all servers
            Get-Services -machineName "All" -status "Running"
            Pause


        } # END 3 - Domain Controller Advertising Services
        #------------------------  
        '3h' # Help/Information for 3
        {
            Get-MSAFunctionsModuleHelp -section "3.3"
            Pause

        } # End 3h
        #------------------------
        #------------------------  
        #------------------------  
        '4' 
        {
            # Get STOPPED Services from all servers
            Get-Services -machineName "All" -status "Stopped"
            
            Pause


        } # END 4 - Domain Controller Advertising Services
        #------------------------  
        '4h' # Help/Information for 4
        {
            Get-MSAFunctionsModuleHelp -section "3.4"
            Pause

        } # End 4h
        #------------------------
        #------------------------  
        #------------------------  
        '5' 
        {
            # Get ALL services for a target machine if machine is running
            # Get all servers, then gather services from a target server
            # Server 'name' is chosed by a user here, which is sent to the function as a parameter
            $servers = Get-ADComputer -Filter {OperatingSystem -Like "Windows *Server*"} -Property *
            $choice = ""
            do { 

                # Gather user choice for which machine, for this section
                $choice = Get-Choice -action "All"
                # Break out of loop if user picks 0
                If ($choice -eq 0) {break}
                       
                # User chose, now grab just the server name to apply to the function
                $machineName = ($servers[$choice - 1].name)
                Get-Services -machineName $machineName -status "All"
                
            } until ($choice -eq 0)

        } # END 5 - Domain Controller Advertising Services
        #------------------------  
        '5h' # Help/Information for 5
        {
            Get-MSAFunctionsModuleHelp -section "3.5"
            Pause

        } # End 5h
        #------------------------
        #------------------------  
        #------------------------ 
        '6' 
        {
            # Get all RUNNING services for a target machine if machine is running
            # Get all servers, then gather services from a target server
            # Server 'name' is chosed by a user here, which is sent to the function as a parameter
            $servers = Get-ADComputer -Filter {OperatingSystem -Like "Windows *Server*"} -Property *
            $choice = ""
            do { 
                # Gather user choice for which machine, for this section
                $choice = Get-Choice -action "Running"
                # Break out of loop if user picks 0
                If ($choice -eq 0) {break}
                
                # User chose, now grab just the server name to apply to the function
                $machineName = ($servers[$choice - 1].name)
                Get-Services -machineName $machineName -status "Running"
                
            } until ($choice -eq 0)


        } # END 6 - Domain Controller Advertising Services
        #------------------------  
        '6h' # Help/Information for 6
        {
            Get-MSAFunctionsModuleHelp -section "3.6"
            Pause

        } # End 6h
        #------------------------ 
        #------------------------  
        #------------------------  
        '7' 
        {
            # Get all STOPPED services for a target machine if machine is running
            # Get all servers HERE, then gather services from a target server
            # Server 'name' is chosed by a user here, which is sent to the function as a parameter
            $servers = Get-ADComputer -Filter {OperatingSystem -Like "Windows *Server*"} -Property *
            $choice = ""
                        
            do { 
                # Gather user choice for which machine, for this section
                $choice = Get-Choice -action "Stopped"
                If ($choice -eq 0) {break}
                
                # User chose, now grab just the server name to apply to the function
                $machineName = ($servers[$choice - 1].name)
                Get-Services -machineName $machineName -status "Stopped"
                
            } until ($choice -eq 0)


        } # END 7 - Domain Controller Advertising Services
        #------------------------  
        '7h' # Help/Information for 7
        {
            Get-MSAFunctionsModuleHelp -section "3.7"
            Pause

        } # End 7h
        #------------------------ 
        #------------------------  
        #------------------------ 
        '8' 
        {
            # View the service + property results
            Get-TargetServices
            # Pause set in function
            #Pause

        } # END 8 - Domain Controller Service Properties
        #------------------------  
        '8h' # Help/Information for 8
        {
            Get-MSAFunctionsModuleHelp -section "3.8"
            Pause

        } # End 8h
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
