--------------------------
README - MSAProgam Summary
--------------------------

  This is a built around a PowerShell Module implementation.
  The 'MSAProgram' focuses on local Group Policy Objects, with the primary goal 
  to create/merge/import MSAs with full settings. 


  The standard Windows backup/import etc., functions associated with 
  PowerShell, will backup/import MSA Policies, but not MSA Preferences. Prior 
  Windows MSA backups/imports will also not re-link new MSAs to the 
  Organizational Units associated with the original MSA. This program, and 
  associated module was built to fully re-create all aspects of a Group Policy Object.


  ------------------------------------------------------------------
  The 'MSAFunctionsModule' was built to accomplish all of this, and most of the 
  associated functions can be run independantly once they are imported. 
  These all have related instructions that can be viewed with:

    > Get-Help <function name> -full


  Step1: 
  ------
  Install the MSAFunctionsModule
  Once downloaded, or cloned, then move to the downloaded "MSAFunctionsModule" directory.
  From PowerShell:    
  	  > .\InstallMSAFunctionsModule.ps1
  
  This is the installation file for the entire module.
  Run this and the entire MSAFunctionsModule will be installed as a PowerShell module.

  You can also right-click on "InstallMSAFunctionsModule.ps1" and click:
    "Run with Powershell"

  You only need to run this once, and it will be installed; however, if changes are made 
    to MSAFunctionsModule source code, this installation file must be run again
    for those changes to be applied to the functions and MSAProgram stored in PowerShell.

  Once installed, through PowerShell you can run functions individually, or run the "MSAProgram".
  Once 'MSAFunctionsModule has been installed, it is best to access, run, and make changes 
    from the primary directory: 'C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule'
  The downloaded/cloned 'MSAFunctionsModule' should be deleted to prevent any confusion.



  All functions associated were built to be run primarily from the 'MSAProgram'.
  Once "InstallMSAFunctionsModule.ps1" has been run, from PowerShell, in the directory location:  
      C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAProgram\
  From PowerShell:
      > .\RunMSAProgram.ps1

      Or you can right click on "RunMSAProgram.ps1" and click "Run with PowerShell"

  ALSO - once "InstallMSAFunctionsModule.ps1" has been run, and MSAFunctionsModule has been 
  installed in the PowerShell cache, you can then copy the "RunMSAProgram - Shortcut" anywhere
  on the machine. For example, once "MSAFunctionsModule" has been installed, 
      Right click on  "RunMSAProgram - Shortcut"
      Click:  "Pin to Taskbar"

  Now if you click on this Taskbar icon, the MSAProgrm will run anytime.
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
  Or you can right click on "InstallMSAFunctionsModule.ps1" and click "Run with PowerShell"


	3) This will automatically:
		a) Copy the 'MSAFunctionsModule' into 'C:\Program Files\WindowsPowerShell\Modules'
		b) Import the modules into the PowerShell memory cache.
		c) This only needs to be done 1-time, when you first download MSAFunctionsModule



  As stated, the 'GPFunctionsModule' was built to be used through the 'MSAProgram'; but 
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

    > Copy-Item .\MSAFunctionsModule\ -Destination "C:\Program Files\WindowsPowerShell\Modules" -Force -Recurse




  2c) Then from PowerShell, execute the target module import:

    > Import-Module -Name "MSAFunctionsModule"




  Now all 'MSAFunctionsModule' functions will be active.
  It is still recommended to operate 'MSAFunctionsModule' through the:

    > .\RunMSAProgram.ps1






  To Remove the MSAFunctionsModule:
  ------------------------------------------------------------------
  NOTE - There may be an error in PowerShell if you have this directory open 
  in Windows Finder while you try to execute this Remove-Item:

    > Remove-Item -Path "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\" -Force -Recurse




   Once you have removed the directory, then remove the module from the memory cache: 

    > cd "C:\Program Files\WindowsPowerShell\Modules"

    > Remove-Item .\MSAFunctionsModule -Recurse -Force

    > $Module = Get-Module MSAFunctionsModule

    > Remove-Module $Module.Name

    > Remove-Item $Module.ModuleBase -Recurse -Force
