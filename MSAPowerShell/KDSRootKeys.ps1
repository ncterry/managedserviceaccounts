Add-KdsRootKey -EffectiveTime (Get-Date).AddHours((-10))
<#
Guid                                
----                                
ab0651fc-c516-5a67-e35b-ac0487beece6
#>

Add-KdsRootKey -EffectiveImmediately
<#
Guid                                
----                                
ff251748-b92b-cb18-54c0-448722b88632
#>

(Get-ADDomain).DNSRoot
#WidgetLLC.Internal

Whoami
#widgetllc\administrator

hostname
#DC01


<#
    TestMSA6 = Name of the MSA account to be created
    DC01.WidgetLLC.Internal = DNS Server Name
    Service Account - Allow Interactive Logon = Name of security group already created.
#>
New-ADServiceAccount -Name TestMSA6 -DNSHostName DC01.WidgetLLC.Internal `
-PrincipalsAllowedToRetrieveManagedPassword "Service Account - Allow Interactive Logon"
