#-------------------------------------------------
# Function to show the MSAFunctions as a list and a summary of each.
# When caled individually, these can be viewed in PowerShell by:
#   > Get-Help <functionName> -Full
#   < Get-Help "Get-MSAsBackups" -Examples
#
# But 'Get-Help' can cause issues when called from MSAProgram
# This is a sub-function that displays the help/explanations for MSAFunctionsModule functions inside MSAProgram.

function Get-MSAFunctionsSummary {
#=================
Param(
    [Parameter(Mandatory = $true)]
    [string]
    $function
) # End Param-------------------------------
        
        Write-Host -ForegroundColor Yellow ("
    |======================================================================|
    |============--- MSAFunctionsModule Functions Summary  ---=============|
    |======================================================================|`n")
        
        If ($function -eq "Find-AllMSASettings") {
# PowerShell Formatting - Leave Indentations alone.
    Write-Host -ForegroundColor Yellow (" 
    Function Find-AllMSASettings {`n`n
    .SYNOPSIS
    View all settings, policies, preferences, and links in a single MSA


    .DESCRIPTION
    Input the name of an active MSA. (`$sourceMSAParam) This is a mandatory parameter.
    This collects all settings from that MSA both Policies and Preferences
    Exports this settings to an HTML that can be viewed in any browser.


    .EXAMPLE
    # Get full settings report for a specific MSA. Files will be saved, and displayed.
    #-------------------------------------------------
    > Find-AllMSASettings -sourceMSAParam `"MSAName`"


    .EXAMPLE
    # Get full settings report for a specific MSA. Files will be saved, and displayed.
    # HTML settings report will also be returned to the caller.
    #------------------------------------------------------------------------
    > Find-AllMSASettings -sourceMSAParam `"Install 7zip`" -returnfile `$true

    
    Param(
        [Parameter(Mandatory = `$true)]
        [String] 
        `$sourceMSAParam,

        [Parameter()]
        [bool[]]
        `$returnfile

    ) #End Param-------------------------------`n`n")

        } # End If
        #-----
        #-----
        #-----
        #-----
        #-----
        #-----
        #-----
        #-----
        #-----
        #-----
        # End section Find-AllMSASetting
        #-----
        #========================================
        If ($function -eq "Get-AllMSAs") {
# PowerShell Formatting - Leave Indentations alone.            
    Write-Host -ForegroundColor Yellow ("
    Function Get-AllMSAs {


    .SYNOPSIS
    From the Domain Controller, this collects summary info for the associated Group Policy Objects



    .Example
    # Results printed to terminal
    #------------------------------
    > Get-AllMSAs -gridview `$false
    


    .Example
    # Results printed to gridview
    #-----------------------------
    > Get-AllMSAs -gridview `$true
    


    .OUTPUTS
    (SAMPLE MSA)
    

    
    Param(
        [Parameter(Mandatory = `$true)]
        [bool] `$gridview
    ) #End Param-------------------------------`n`n")

        } # End If
        #-----
        #-----
        #-----
        #-----
        #-----
        #-----
        #-----
        #-----
        #-----
        #-----
        # End section Get-AllMSA
        #-----


} # End function Get-MSAFunctionsSummary
