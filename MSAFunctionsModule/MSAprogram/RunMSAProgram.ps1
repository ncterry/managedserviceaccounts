<###########################################################################
# This script, "RunMSAProgram.ps1" depends on if "InstallMSAFunctionsModule.ps1" has been run first, just once for the stated 'installation'.
# If "InstallMSAFunctionsModule.ps1" has been executed, just that first time, you can then execute:
#     "RunMSAProgram.ps1" any time after that.
#
# From PowerShell 
#     > .\RunMSAProgram.ps1
#
# Or right click on "RunMSAProgram.ps1" and click:
#     "Run with PowerShell"
#
# ALSO - once "InstallMSAFunctionsModule.ps1" has been run, and MSAFunctionsModule has been 
# installed in the PowerShell cache, you can then copy the "RunMSAProgram - Shortcut"
# anywhere on the machine. For example, once "MSAFunctionsModule" has been installed: 
#     Right click on "RunMSAProgram - Shortcut"
#     Click:  "Pin to Taskbar"
# 
#     Now if you click on this Taskbar icon, the MSAFunctionsModule will run anytime.
# 
# 
# Within the 'MSAFunctionsModule' directory, the 'MSAProgram' can be run from 
# any location on the machine; however, regardless of where it is executed from, 
# the default location that the 'MSAProgram' will always use for data, reports, 
# backups etc., is the 'WindowsPowerShell' location that the program copies 
# itself to during execution:
# 
#   'C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule'
# ###########################################################################
#
#
#>
Import-Module MSAFunctionsModule -Force -Verbose
Import-Module ActiveDirectory
# RSAT is requried for certain features.
Install-WindowsFeature RSAT 

function Set-MainMenu
{
    Write-Host("
|======================================================================|
|==================--- Mananged Service Accounts ---===================|
|======================================================================|") # END WRITE-HOST
    #
    Write-Host("`n Selections:
------------------------------------------------------------------------`n")
    #
    Write-Host -ForegroundColor Yellow ("   1) System\Domain Info `t`t`t`tEnter: 1`n")
    Write-Host -ForegroundColor Yellow ("   2) Services Information `t`t`t`tEnter: 2`n")
    Write-Host -ForegroundColor Yellow ("   3) Managed Service Accounts `t`t`t`tEnter: 3`n")
    Write-Host -ForegroundColor Yellow ("   4) Service Account Event Logs `t`t`tEnter: 4`n")

     #
    Write-Host("------------------------------------------------------------------------")
    Write-Host -ForegroundColor Yellow ("`n   README - Program Summary `t`t`t`tEnter: `'readme`'`n")
    Write-Host("------------------------------------------------------------------------")
    Write-Host -ForegroundColor Yellow ("`n   HELP   - Enter the number + h  (1h, 2h, 3h...) `tEnter: `'#h`'`n")
    Write-Host -ForegroundColor Red ("   QUIT   - End the MSA Program `t`t`tEnter: `'quit`'`n") 
    Write-Host("------------------------------------------------------------------------")
} # End function Set-MainMenu


#--------------------------
# Continuing do loop unless user quits
# Other menus/functions will resort back here when they are completed.
$Global:quit = ""   # Var allows for a full session quit from sub menus.
$Global:servers = $null
$Global:lineclear = "`n"*100
do
{
    If ($Global:quit -eq "quit") {break}
    # The screen can leave residual text. This overwrites before clear
    Write-Host("`n`n`n`n`n`n`n`n`n`nn`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n") 
    Clear-Host        # Clear terminal 
    Set-MainMenu      # Call local function. Print menu to screen
    $choice = Read-Host "`nEnter Choice"  #Ask user for menu choice
    # The screen can leave residual text. This overwrites before clear
    Write-Host("`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n") 
    Clear-Host
    $choice = $choice -replace '\s', ''   #In case user enters spaces
    $choice = $choice.ToLower()           #In case user uses any capitol letters.

    switch ($choice)  # If menu options are chosen correctly.
    {
        #--------------------------------------------------
        #--------------------------------------------------
        # Option 1 - System\Domain Information-------------
        '1' 
        {

            Write-Host "1) You chose To view the System\Domain Information"
            # Assumes execution of .\RunMSAProgram.ps1 was done from inside \MSAProgam
            .\Menu\1_MSAsDomainMenu.ps1    # Execute MSA Search Menu script.
            If ($Global:quit -eq "quit") {break}
            

        }#END option 1-------------------------------------
        #--------------------------------------------------
        #--------------------------------------------------
        '1h' # Help/Information for 1
        {

# Write-Host ==> Pressed left for formatting; Leave on the left.
Write-Host -ForegroundColor Yellow ("
----------
1) System\Domain Information
----------
Several options that gather basic information such as the Domain,  
Domain Controller, and network tests related to the System and 
Domain that contain the Group Policy Objects that are targeted 
in this MSAFunctionModule") # END WRITE-HOST

            Pause

        } # End 1h-----------------------------------------
        #--------------------------------------------------
        #--------------------------------------------------
        # Option 2 - Gather Domain Related Services-------------
        '2' 
        {
            
            # Assumes execution of .\RunMSAProgram.ps1 was done from inside \MSAProgam
            .\Menu\2_ServiceInfoMenu.ps1    # Execute MSA Search Menu script.
            

        }#END option 2-------------------------------------
        #--------------------------------------------------
        #--------------------------------------------------
        '2h' # Help/Information for 2
        {

# Write-Host ==> Pressed left for formatting; Leave on the left.
Write-Host -ForegroundColor Yellow ("
----------
2) Managed Service Account Information
----------
Several options that gather information related to local Managed Service Accounts.
Including all MSA listings, MSAs that hold logon credentials, and any internal 
accounts on the domain that hold privileges over an MSA, and what level of 
privileges they are.

") # END WRITE-HOST

            Pause
        }#END option 2h-------------------------------------
        #--------------------------------------------------
        #--------------------------------------------------
        '3' 
        {

            # Assumes execution of .\RunMSAProgram.ps1 was done from inside \MSAProgam
            .\Menu\3_DomainServiceAccountsMenu.ps1    # Execute MSA Search Menu script.
            

        }#END option 3-------------------------------------
        #--------------------------------------------------
        #--------------------------------------------------
        '3h' # Help/Information for 3
        {

# Write-Host ==> Pressed left for formatting; Leave on the left.
Write-Host -ForegroundColor Yellow ("
----------
3) System Service Information
----------
Gather information on system services, such as whether these services are running, 
or stopped, which server these services are associated with, and extensive 
properties for each service. 

") # END WRITE-HOST
        }#END option 3h-------------------------------------
        #--------------------------------------------------
        #--------------------------------------------------
        '4' 
        {

            # Assumes execution of .\RunMSAProgram.ps1 was done from inside \MSAProgam
            .\Menu\4_MSAeventsMenu.ps1    # Execute MSA Search Menu script.
            
            

        }#END option 4-------------------------------------
        #--------------------------------------------------
        '4h' # Help/Information for 4
        {

# Write-Host ==> Pressed left for formatting; Leave on the left.
Write-Host -ForegroundColor Yellow ("
----------
3) Managed Service Account EventLogs
----------
Gather information on Managed Service Accounts that is stored in the system 
Event Logs.  

") # END WRITE-HOST
        }#END option 4h-------------------------------------
        #--------------------------------------------------
        #--------------------------------------------------
        'readme' # Help/Information for main
        {
# Write-Host ==> Pressed left for formatting; Leave on the left.
Write-Host -ForegroundColor Yellow ("
-------------------------------------------------
README - MSAFunctionsModule and MSAProgam Summary
-------------------------------------------------

  This is a built around a PowerShell Module implementation.
  The 'MSAProgram' focuses on local Managed Service Account Objects. 

  ------------------------------------------------------------------
  The 'MSAFunctionsModule' was built to accomplish all of this, and most of the 
  associated functions can be run independantly once they are imported. 
  These all have related instructions that can be viewed with:

    > Get-Help <function name> -full


  Step1: 
  Install the MSAFunctionsModule
  Once downloaded, or cloned, then move to the downloaded `"MSAFunctionsModule`" directory.
  From PowerShell:    
  	  > .\InstallMSAFunctionsModule.ps1
  

  This is the installation file for the entire module.
  Run this and the entire MSAFunctionsModule will be installed as a PowerShell module.
  You can also right-click on `"InstallMSAFunctionsModule.ps1`" and click:
    `"Run with Powershell`"


  You only need to run this once, and it will be installed. 
  Once installed, you can run functions individually or run the `"MSAProgram`".



  All functions associated were built to be run primarily from the 'MSAProgram'.
  Once `"InstallMSAFunctionsModule.ps1`" has been installed,
  From the directory location:       .....\MSAFunctionsModule\MSAProgram\
  From PowerShell:
      > .\RunMSAProgram.ps1

      Or you can right click on `"RunMSAProgram.ps1`" and click `"Run with PowerShell`"


  ALSO - once `"InstallMSAFunctionsModule.ps1`" has been run, and MSAFunctionsModule has been 
  installed in the PowerShell cache, you can then copy the `"RunMSAProgram - Shortcut`" anywhere
  on the machine. For example, once `"MSAFunctionsModule`" has been installed, 
      Right click on  `"RunMSAProgram - Shortcut`"
      Click:  `"Pin to Taskbar`"


  Now if you click on this Taskbar icon, the MSAFunctionsModule will run anytime.
  However, regardless of where it is executed from, the default location that 
  the 'MSAProgram' will always use for data, reports, backups etc., is the 
  'WindowsPowerShell' location that the program copies itself to during execution:

    'C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule'



  ------------------------------------------------------------------
  This Module setup can be done automatically by running the 'InstallMSAFunctionsModule.ps1'.
  As an Administrator in PowerShell:


	1) Move to where the directory was downloaded to 'cd ....\MSAFunctionsModule\'
	2) Once at the \MSAFunctionsModule location, from PowerShell Terminal run:

	  > .\InstallMSAFunctionsModule.ps1

  Or you can right click on `"InstallMSAFunctionsModule.ps1`" and click `"Run with PowerShell`"


	3) This will automatically:
		a) Copy the 'MSAFunctionsModule' into 'C:\Program Files\WindowsPowerShell\Modules'
		b) Import the modules into the PowerShell memory cache.
		c) This only needs to be done 1-time, when you first download MSAFunctionsModule



  As stated, the 'MSAFunctionsModule' was built to be used through the 'MSAProgram'; but 
  most of these functions can be run individually IF they have been installed/imported into 
  the PowerShell Module cache. This can be done in two ways:

  1) Easiest is to follow the instructions above.


  OR


  2) Standard PowerShell Module Installation:
  ------------------------------------------------------------------
  2a) First action is to copy the 'MSAFunctionsModule' directory to:

    'C:\Program Files\WindowsPowerShell\Modules'




  2b) This can be done through PowerShell.
      First, move TO the downloaded \MSAFunctionsModule location such as, 
      \Desktop, \Downloads, etc., then copy the directory to the target:

    > Copy-Item .\MSAFunctionsModule\ -Destination `"C:\Program Files\WindowsPowerShell\Modules`" -Force -Recurse




  2c) Then from PowerShell, execute the target module import:

    > Import-Module -Name `"MSAFunctionsModule`"




  Now all 'MSAFunctionsModule' functions will be active.
  It is still recommended to operate 'MSAFunctionsModule' through the:

    > .\RunMSAProgram.ps1






  To Remove the MSAFunctionsModule:
  ------------------------------------------------------------------
  NOTE - There may be an error in PowerShell if you have this directory open 
  in Windows Finder while you try to execute this Remove-Item:

    > Remove-Item -Path `"C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\`" -Force -Recurse




  Once you have removed the directory, then remove the module from the memory cache: 

    > Remove-Module -Name `"MSAFunctionsModule`"
 ") # END WRITE-HOST

            Pause
        } # End readme-----------------------------------------
        #--------------------------------------------------
        #--------------------------------------------------
        #------------------------  
        'quit' 
        {
            $Global:quit = "quit"
            $choice = "q"
        } # End quit       
    }# END Switch

    Set-MainMenu #Refresh main menu

} until (($choice -eq '0')) #END do Loop
