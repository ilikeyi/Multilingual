ConvertFrom-StringData -StringData @'
	# Main page
	Mainname                  = Solutions
	Mainpage                  = Solutions Toolbox
	Update                    = Check for updates
	Reset                     = Reset
	Disable                   = Disabled
	Done                      = Complete
	OK                        = OK
	Cancel                    = Cancel
	Exit                      = Exit
	AllSel                    = Select all
	AllClear                  = Clear all
	Operable                  = Operable
	Inoperable                = Inoperable
	ForceUpdate               = Forcibly check and update
	SettingLangAndKeyboard    = Set system language and keyboard
	SwitchLanguage            = Switch language
	RefreshModules            = Reload the module
	Choose                    = Please select
	FailedCreateFolder        = Failed to create directory: \
	ToMsg                     = \n   Automatically return to the main menu after {0} seconds.
	ToQuit                    = \n   Exit the main menu in {0} seconds.
	DiskSearch                = Search plan:
	DiskSearchFind            = Searched, running: {0}
	DeployCleanup             = Clean up the Deploy directory
	FirstDeployment           = First experience deployment
	FirstDeploymentWarning    = Do not turn off the PowerShell icon displayed in the taskbar.
	FirstDeploymentDone       = The deployment has been completed.
	FirstDeploymentPopup      = Pop up the main interface
	FirstExpFinishOnDemand    = Allow the first pre-experience, as planned
	DeployTask                = Deployment tasks: \
	Reboot                    = When finished, restart the computer

	DeployPackerTips          = There are deployment packages available
	DeployPackerTipsDone      = The deployment package has been completed.
	DeployOfficeTips          = Office deployment plan available
	DeployOfficeTipsDone      = The Office deployment plan is complete.

	NetworkLocationWizard     = Network Location Wizard
	UseZip                    = Use {0} decompression software
	UseOSZip                  = Use the decompression software that comes with the system
	UserCancel                = The user has cancelled the operation.
	SetLang                   = Set system preferred language: \
	KeyboardSequence          = Keyboard sequence: \
	Wubi                      = Wubi
	Pinyi                     = Pinyin

	# update
	UpdateServerSelect        = Automatic server selection or custom selection
	UpdateServerNoSelect      = Please select an available server
	UpdateSilent              = When updates are available, update silently
	UpdateReset               = Reset this solution
	UpdateResetTips           = When the download address is available, it is forced to download and update automatically.
	UpdateExit                = The automatic update script will automatically exit after {0} seconds.
	UpdateCheckServerStatus   = Check server status ( total {0} optional )
	UpdateServerAddress       = Server address: {0}
	UpdateServeravailable     = Status: Available
	UpdateServerUnavailable   = Status: Unavailable
	UpdatePriority            = has been set as priority
	UpdateServerTestFailed    = Failed server status test
	UpdateQueryingUpdate      = Querying and updating...
	UpdateQueryingTime        = Checking if the latest version is available,\n   the connection took {0} milliseconds.
	UpdateConnectFailed       = Unable to connect to remote server, check update has been aborted.
	UpdateMinimumVersion      = Meet the minimum update program version requirements,\n   the minimum required version: {0}
	UpdateVerifyAvailable     = Verify that the address is available
	UpdateDownloadAddress     = Download link: \
	UpdateAvailable           = Available
	UpdateUnavailable         = Unavailable
	UpdateCurrent             = \  Currently used version: \
	UpdateLatest              = Latest version available: \
	UpdateNewLatest           = Found a new version available!
	UpdateForce               = An update is being forced.
	UpdateSkipUpdateCheck     = The pre-configured policy does not allow automatic updates to be run for the first time.
	UpdateTimeUsed            = Time used: \
	UpdatePostProc            = Post-processing
	UpdateNotExecuted         = Not executed
	UpdateNoPost              = No post-processing task found
	UpdateUnpacking           = Unpacking: \
	UpdateDone                = Successfully updated!
	UpdateUpdateStop          = An error occurred while downloading the update and the update process was aborted.
	UpdateInstall             = Do you want to install this update?
	UpdateInstallSel          = Yes, the above update will be installed\nNo, the update will not be installed
	UpdateNoUpdateAvailable   = \n   No updates available.\n\n   You are running the latest available version of {0}'s Solutions.\n
	UpdateNotSatisfied        = \n   Does not meet the minimum update program version requirements,\n\n   Minimum required version: {0}\n\n   Please download a copy of {1}'s Solutions again to update this tool.\n\n   Check for update has been aborted.\n

	# Create Update
	UpdateCreate              = Create upgrade package
	UpdateLow                 = Minimum requirement: \
	UpCreateRear              = What needs to be done after creation
	UpCreateASC               = Add PGP signature to the upgrade package, certificate password:
	UpCreateSHA256            = Generate .SHA-256 for the upgrade package
	Uping                     = Generating
	SkipCreate                = Skip generation, not found
	ZipStatus                 = 7-Zip is not installed.
	ASCStatus                 = Gpg4win is not installed.
'@