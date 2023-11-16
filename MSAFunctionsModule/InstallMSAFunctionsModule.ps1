# Group Policy Object Merge\Copy Program
# Run this script from the downloaded/cloned  \MSAFunctionsModule  directory.
# This is the installation file for the entire module.
# Run this and the entire MSAFunctionsModule will be installed as a PowerShell module.
#
# From PowerShell, move to the downloaded directory for "MSAFunctionsModule"
# From PowerShell:    
#		  > .\InstallMSAFunctionsModule.ps1
#
# OR, You can also right-click on "InstallMSAFunctionsModule.ps1" and click:
#   "Run with Powershell"
#
# You only need to run this once, and it will be installed; however,
# If changes are made to MSAFunctionsModule source code, this installation file must be run again
# for those changes to be applied to the functions and MSAProgram stored in PowerShell.
# Once installed, you can run functions individually or run the MSAProgram.
#
# Once 'MSAFunctionsModule has been installed it is best to access, run, and make changes 
# from the primary directory: 'C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule'
# The downloaded/cloned 'MSAFunctionsModule' should be deleted to prevent any confusion.
#--------------------------
#
#--------------------------
# FOR WORKING SETUP
# Changes to associated modules are in an outside directory, need to be copied into the Modules directory
# Get the path to the function files. $PSScriptRoot = Script path
# This is built to be an imported Windows PowerShell script.
# The default location will be in: C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\functions
$gl = $PSScriptRoot # Based on assumption above, Gather the location of this script
# Grab the current address of the 'MSAFunctionsModule'
$functionPath = $gl


# Simple prelim test if user has required admin abilities needed for MSAFunctions Module.
New-Item -ItemType Directory "C:\Program Files\WindowsPowerShell\Modules\admintest"
If (Test-Path -Path "C:\Program Files\WindowsPowerShell\Modules\admintest") {
  New-Item -ItemType File "C:\Program Files\WindowsPowerShell\Modules\admintest\admintest.txt"
  Add-Content -Path "C:\Program Files\WindowsPowerShell\Modules\admintest\admintest.txt" -Value "Admin Test"
} Else {
  Write-Warning ("User does not have required admin credentials to create in: `nC:\Program Files\WindowsPowerShell\Modules\ `n`nThe MSAFunctionsModule will not be operable without admin credentials.")
  Pause
} # End If/Else
# Delete the test.
Remove-Item -Path "C:\Program Files\WindowsPowerShell\Modules\admintest" -Recurse -Force


# Copy MSAFunctionsModule to the PowerShell module location.
Copy-Item $functionPath -Destination "C:\Program Files\WindowsPowerShell\Modules" -Recurse -Force
Write-Host ("Copied MSAFunctionsModule to C:\Program Files\WindowsPowerShell\Modules")
# Above will copy the full MSAFunctionsModule Directory



# This MSAprogram is directly tied to the MSAFunctionsModule
# Inside the MSAFunctionsModule directory is the "MSAFunctionsModule.psm1"
# This only works once the MSAFunctionsModule has been placed=copied=installed into a PowerShell Directory
# If the Copy-Item above does not work, such as user has no admin privs, it cant import then.
# Import uses the instructions on that local "MSAFunctionsModule.psm1"
Import-Module MSAFunctionsModule -Force -Verbose


# All data from this program/functions will be stored here.
# Create the MSAdata directory if it does not exist already. It should have been copied over already.
$resultsPath = "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\MSAdata" 
If(!(Test-Path -Path $resultsPath)) {
    New-Item -ItemType Directory $resultsPath
    New-Item -ItemType File "$resultsPath\README.txt"
    Add-Content -Path "$resultsPath\README.txt" -Value "This directory holds data collected by MSAFunctionsModule"
    (Get-ChildItem -Path $resultsPath).Encrypt() #Lock, access only by creator.
} # End If



# Open the new PowerShell Modulde directory for MSAFunctionsModule
explorer.exe "C:\Program Files\WindowsPowerShell\Modules\MSAFunctionsModule\"

