@{
	RootModule        = 'Engine.psm1'
	ModuleVersion     = '2.1.9.0'
	GUID              = '881d5082-017d-48e6-9422-0049a1f60e8d'
	Author            = 'Yi'
	Copyright         = 'FengYi, Inc. All rights reserved.'
	Description       = ''
	PowerShellVersion = '5.1'
	NestedModules     = @()
	FunctionsToExport = '*'
	CmdletsToExport   = '*'
	VariablesToExport = '*'
	AliasesToExport   = '*'

	PrivateData = @{
		PSData = @{
			Tags         = @("Multilingual")
			LicenseUri   = 'https://opensource.org/license/mit'
			ProjectUri   = @(
				'https://github.com/ilikeyi/Multilingual'
			)
#			IconUri      = ''
#			ReleaseNotes = ''
			Buildstring    = 'yi_release.1.26.2026'
			MinimumVersion = '1.0.0.0'
			UpdateServer = @(
				"https://fengyi.tel/solutions/update/Multilingual/latest.json"
				"https://github.com/ilikeyi/Multilingual/raw/main/update/latest.json"
			)
		}
	}
	HelpInfoURI = 'https://fengyi.tel'
#	DefaultCommandPrefix = ''
}