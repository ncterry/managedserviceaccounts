# This is just a direct collection for notes, of potential PowerShell options

<#
Use server logs and PowerShell to investigate
You can use server logs to determine which servers, and how many servers, 
an application is running on. To get a listing of the Windows Server version 
for all servers on your network, you can run the following PowerShell command. 
#>
# Note: Below is all 1 command with both `drops and |extensions.
Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' `
-Properties Name, Operatingsystem, Operatingsystemversion, IPv4Address | 
Sort-Object -Property Operatingsyste | 
Select-Object -Property Name, Operatingsystem, Operatingsystemversion, IPv4Address | 
Out-GridView
