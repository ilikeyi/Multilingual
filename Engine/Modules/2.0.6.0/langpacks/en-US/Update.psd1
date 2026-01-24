ConvertFrom-StringData -StringData @'
	# en-US
	# English (United States)

	ChkUpdate                 = Check for updates
	UpdateServerSelect        = Automatic server selection or custom selection
	UpdateServerNoSelect      = Please select an available server
	UpdateSilent              = When updates are available, update silently
	UpdateClean               = Allows cleaning up old versions during idle time
	UpdateReset               = Reset this solution
	UpdateResetTips           = When the download address is available, it is forced to download and update automatically.
	UpdateCheckServerStatus   = Check server status ( total {0} optional )
	UpdateServerAddress       = Server address
	UpdatePriority            = has been set as priority
	UpdateServerTestFailed    = Failed server status test
	UpdateQueryingUpdate      = Querying and updating...
	UpdateQueryingTime        = Checking if the latest version is available,\n  the connection took {0} milliseconds.
	UpdateConnectFailed       = Unable to connect to remote server, check update has been aborted.
	UpdateREConnect           = Connection failed, retrying {0}/{1}
	UpdateMinimumVersion      = Meet the minimum update program version requirements,\n  the minimum required version: {0}
	UpdateVerifyAvailable     = Verify that the address is available
	UpdateDownloadAddress     = Download link
	UpdateAvailable           = Available
	UpdateUnavailable         = Unavailable
	UpdateCurrent             = \  Currently used version
	UpdateLatest              = Latest version available
	UpdateNewLatest           = Found a new version available!
	UpdateSkipUpdateCheck     = Preconfigure policy to not allow automatic updates to run for the first time.
	UpdateTimeUsed            = Time used
	UpdatePostProc            = Post-processing
	UpdateNotExecuted         = Not executed
	UpdateNoPost              = No post-processing task found
	UpdateUnpacking           = Unpacking
	UpdateDone                = Successfully updated!
	UpdateDoneRefresh         = After the update is complete, execute function processing.
	UpdateUpdateStop          = An error occurred while downloading the update and the update process was aborted.
	UpdateInstall             = Do you want to install this update?
	UpdateInstallSel          = Yes, the above update will be installed\nNo, the update will not be installed
	UpdateNotSatisfied        = \n  Does not meet the minimum update program version requirements,\n\n  Minimum required version: {0}\n\n  Please download it again.\n\n  Check for update has been aborted.\n
	IsAllowSHA256Check        = Allow SHA256 hash verification.
	GetSHAFailed              = Failed to retrieve the hash for comparison with the downloaded file.
	Verify_Done               = Verification successful.
	Verify_Failed             = Verification failed, hash mismatch.
	Auto_Update_Allow         = Allow background automatic update checks
	Auto_Update_New_Allow     = Allow automatic updates when new updates are detected
	Auto_Check_Time           = Hours, the interval between automatic checks
	Auto_Last_Check_Time      = Last automatic update check time
	Auto_Next_Check_Time      = Less than {0} hours remaining until the next check
	Auto_First_Check          = No update check has been performed yet; the first update check will now be performed.
	Auto_Update_Last_status   = Last updated status
	Auto_Update_IsLatest      = This is already the latest version.
'@