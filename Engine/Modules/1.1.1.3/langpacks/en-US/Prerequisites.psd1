ConvertFrom-StringData -StringData @'
	# en-US
	# English (United States)

	Prerequisites                   = Prerequisites
	Check_PSVersion                 = Checking PS version 5.1 and above
	Check_OSVersion                 = Checking Windows version > 10.0.16299.0
	Check_Higher_elevated           = Checking Must be elevated to higher authority
	Check_execution_strategy        = Check execution strategy

	Check_Pass                      = Pass
	Check_Did_not_pass              = Did not pass
	Check_Pass_Done                 = Congratulations, it has passed.
	How_solve                       = How to solve it
	UpdatePSVersion                 = Please install the latest PowerShell version
	UpdateOSVersion                 = 1. Go to the official Microsoft website to download the latest\n      version of the operating system\n\n   2. Install the latest version of the operating system and try again
	HigherTermail                   = 1. Open "Terminal" or "PowerShell ISE" as an administrator, \n      set PowerShell execution policy: Bypass, PS command line: \n\n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n   2. Once resolved, rerun the command.
	HigherTermailAdmin              = 1. Open Terminal or PowerShell ISE as an administrator.\n    2. Once resolved, rerun the command.
'@