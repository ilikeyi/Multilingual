<#
	.Register user interface
	.注册用户界面
#>
Function FirstExperience
{
	param
	(
		[switch]$Force,
		[switch]$Quit
	)
	if ($Quit) { $Global:QUIT = $true }

	Logo -Title $($lang.FirstDeployment)
	Write-Host "   $($lang.FirstDeployment)`n   $('-' * 80)"

	if ($Force) {
		if (Deploy_Sync -Mark "Auto_Update") {
			Write-Host "   $($lang.ForceUpdate)"
			Update -Auto -Force -IsProcess
		} else {
			Write-Host "   $($lang.UpdateSkipUpdateCheck)"
		}

		FirstExperience_Process
	} else {
		FirstExperience_Setting_UI
	}
}

Function FirstExperience_Setting_UI
{
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$GUIFECanelClick = {
		Write-Host "   $($lang.UserCancel)" -ForegroundColor Red
		$GUIFE.Close()
	}
	$GUIFEOKClick = {
		$GUIFE.Hide()

		if ($GUIFEPreAppxCleanup.Checked) {
			if ($GUIFEPreAppxCleanupEnabled.Checked) {
				Cleanup_Appx_Tasks -Enabled
			}

			if ($GUIFEPreAppxCleanupDisable.Checked) {
				Cleanup_Appx_Tasks -Disable
			}
		} else {
			Write-Host "   $($lang.PreAppxCleanup)"
			Write-Host "   $($lang.Inoperable)`n" -ForegroundColor Red
		}

		if ($GUIFELanguageComponents.Checked) {
			if ($GUIFELanguageComponentsEnabled.Checked) {
				Cleanup_Unsed_Language -Enabled
			}

			if ($GUIFELanguageComponentsDisable.Checked) {
				Cleanup_Unsed_Language -Disable
			}
		} else {
			Write-Host "   $($lang.CleanupOndemandLP)"
			Write-Host "   $($lang.Inoperable)`n" -ForegroundColor Red
		}
		
		if ($GUIFECleanupUnusedLP.Checked) {
			if ($GUIFECleanupUnusedLPEnabled.Checked) {
				Cleanup_On_Demand_Language -Enabled
			}

			if ($GUIFECleanupUnusedLPDisable.Checked) {
				Cleanup_On_Demand_Language -Disable
			}
		} else {
			Write-Host "   $($lang.CleanupUnusedLP)"
			Write-Host "   $($lang.Inoperable)`n" -ForegroundColor Red
		}

		if ($GUIFELangAndKeyboard.Checked) {
			Language_Setting
			Write-Host "   $($lang.Done)`n" -ForegroundColor Green
		} else {
			Write-Host "   $($lang.SettingLangAndKeyboard)"
			Write-Host "   $($lang.Inoperable)`n" -ForegroundColor Red
		}

		if ($GUIFEUtf8.Checked) {
			Language_Use_UTF8 -Enabled
		} else {
			Write-Host "   $($lang.SettingUTF8)"
			Write-Host "   $($lang.Inoperable)`n" -ForegroundColor Red
		}

		if ($GUIFELocale.Checked) {
			Language_Region_Setting -Force
			Write-Host "   $($lang.Done)`n" -ForegroundColor Green
		} else {
			Write-Host "   $($lang.SettingLocale)"
			Write-Host "   $($lang.Inoperable)`n" -ForegroundColor Red
		}

		Write-Host "   $($lang.DeployCleanup)"
		if ($GUIFEDeployCleanup.Checked) {
			Remove_Tree -Path "$($PSScriptRoot)\..\..\..\..\..\Deploy"
			Write-Host "   $($lang.Done)`n" -ForegroundColor Green
		} else {
			Write-Host "   $($lang.Inoperable)`n" -ForegroundColor Red
		}

		Write-Host "   $($lang.Reboot)"
		if ($GUIFEReboot.Checked) {
			Restart-Computer -Force
			Write-Host "   $($lang.Done)`n" -ForegroundColor Green
		} else {
			Write-Host "   $($lang.Inoperable)`n" -ForegroundColor Red
		}
		$GUIFE.Close()
	}
	$GUIFE             = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $lang.FirstDeployment
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
	}
	$GUIFEPanel        = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 520
		Width          = 490
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "8,5,8,0"
		Dock           = 1
		Location       = "10,5"
	}

	$GUIFEPreAppxCleanup = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.PreAppxCleanup
		Checked        = $True
		add_Click      = {
			if ($GUIFEPreAppxCleanup.Checked) {
				$GUIFEPreAppxCleanupSel.Enabled = $True
			} else {
				$GUIFEPreAppxCleanupSel.Enabled = $False
			}
		}
	}
	$GUIFEPreAppxCleanupSel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
		Padding        = "16,0,0,10"
	}
	$GUIFEPreAppxCleanupEnabled = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Enabled
	}
	$GUIFEPreAppxCleanupDisable = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Disable
		Checked        = $True
	}
	$GUIFELanguageComponents = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.CleanupOndemandLP
		Checked        = $True
		add_Click      = {
			if ($GUIFELanguageComponents.Checked) {
				$GUIFELanguageComponentsSel.Enabled = $True
			} else {
				$GUIFELanguageComponentsSel.Enabled = $False
			}
		}
	}
	$GUIFELanguageComponentsSel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
		Padding        = "16,0,0,10"
	}
	$GUIFELanguageComponentsEnabled = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Enabled
	}
	$GUIFELanguageComponentsDisable = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Disable
		Checked        = $True
	}

	$GUIFECleanupUnusedLP = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.CleanupUnusedLP
		Checked        = $True
		add_Click      = {
			if ($GUIFECleanupUnusedLP.Checked) {
				$GUIFECleanupUnusedLPSel.Enabled = $True
			} else {
				$GUIFECleanupUnusedLPSel.Enabled = $False
			}
		}
	}
	$GUIFECleanupUnusedLPSel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
		Padding        = "16,0,0,10"
	}
	$GUIFECleanupUnusedLPEnabled = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Enabled
	}
	$GUIFECleanupUnusedLPDisable = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Disable
		Checked        = $True
	}

	$GUIFELangAndKeyboard = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.SettingLangAndKeyboard
		Checked        = $True
	}
	$GUIFEUtf8         = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = $lang.SettingUTF8
	}
	$GUIFEUtf8Tips     = New-Object System.Windows.Forms.Label -Property @{
		Height         = 26
		Width          = 490
		Text           = $lang.SettingUTF8Tips
		margin         = "19,0,0,8"
	}
	$GUIFELocale       = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 490
		Text           = "$($lang.SettingLocale) ( $((Get-Culture).Name) )"
	}
	$GUIFELocaleTips   = New-Object System.Windows.Forms.Label -Property @{
		Height         = 26
		Width          = 490
		Text           = $lang.SettingLocaleTips
		margin         = "19,0,0,8"
	}
	$GUIFEDeployCleanup = New-Object System.Windows.Forms.Checkbox -Property @{
		Height         = 30
		Width          = 505
		Text           = $lang.DeployCleanup
		Location       = "12,538"
		Checked        = $True
	}
	$GUIFEReboot       = New-Object System.Windows.Forms.Checkbox -Property @{
		Height         = 30
		Width          = 505
		Text           = $lang.Reboot
		Location       = "12,565"
	}
	$GUIFEOK           = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "8,595"
		Height         = 36
		Width          = 515
		add_Click      = $GUIFEOKClick
		Text           = $lang.OK
	}
	$GUIFECanel        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "8,635"
		Height         = 36
		Width          = 515
		add_Click      = $GUIFECanelClick
		Text           = $lang.Cancel
	}
	$GUIFE.controls.AddRange((
		$GUIFEPanel,
		$GUIFEDeployCleanup,
		$GUIFEReboot,
		$GUIFEOK,
		$GUIFECanel
	))
	$GUIFEPanel.controls.AddRange((
		$GUIFEPreAppxCleanup,
		$GUIFEPreAppxCleanupSel,
		$GUIFELanguageComponents,
		$GUIFELanguageComponentsSel,
		$GUIFECleanupUnusedLP,
		$GUIFECleanupUnusedLPSel,
		$GUIFELangAndKeyboard,
		$GUIFEUtf8,
		$GUIFEUtf8Tips,
		$GUIFELocale,
		$GUIFELocaleTips
	))
	$GUIFEPreAppxCleanupSel.controls.AddRange((
		$GUIFEPreAppxCleanupEnabled,
		$GUIFEPreAppxCleanupDisable
	))
	$GUIFELanguageComponentsSel.controls.AddRange((
		$GUIFELanguageComponentsEnabled,
		$GUIFELanguageComponentsDisable
	))
	$GUIFECleanupUnusedLPSel.controls.AddRange((
		$GUIFECleanupUnusedLPEnabled,
		$GUIFECleanupUnusedLPDisable
	))
	if ($GUIFEPreAppxCleanup.Checked) {
		$GUIFEPreAppxCleanupSel.Enabled = $True
	} else {
		$GUIFEPreAppxCleanupSel.Enabled = $False
	}
	if ($GUIFELanguageComponents.Checked) {
		$GUIFELanguageComponentsSel.Enabled = $True
	} else {
		$GUIFELanguageComponentsSel.Enabled = $False
	}
	if ($GUIFECleanupUnusedLP.Checked) {
		$GUIFECleanupUnusedLPSel.Enabled = $True
	} else {
		$GUIFECleanupUnusedLPSel.Enabled = $False
	}
 
	switch ($Global:IsLang) {
		"zh-CN" {
			$GUIFE.Font = New-Object System.Drawing.Font("Microsoft YaHei", 9, [System.Drawing.FontStyle]::Regular)
		}
		Default {
			$GUIFE.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
		}
	}

	$GUIFE.FormBorderStyle = 'Fixed3D'
	$GUIFE.ShowDialog() | Out-Null
}

<#
	.Prerequisite deployment
	.先决部署
#>
Function FirstExperience_Process
{
	<#
		.Refresh all known languages installed
		.刷新已安装的所有已知语言
	#>
	Language_Known_Available

	<#
		.Determine whether all languages currently installed are multilingual versions, and add known policies to multilingual versions
		.获取已安装所有语言是否是多语版，多语版则添加已知策略
	#>
	if ($Global:LanguagesAreInstalled.count -ge 2) {
		Write-Host "   $($lang.LangMul) ( $($Global:LanguagesAreInstalled.count) )"

		<#
			.Appx cleanup maintenance tasks
			.Appx 清理维护任务
		#>
		if (Deploy_Sync -Mark "Disable_Cleanup_Appx_Tasks") {
			Write-Host "   $($lang.Operable)" -ForegroundColor Green
			Cleanup_Appx_Tasks -Disable
		} else {
			Write-Host "   $($lang.PreAppxCleanup)"
			Write-Host "   $($lang.Inoperable)" -ForegroundColor Red
		}

		<#
			.Prevent cleaning of unused language packs
			.阻止清理未使用的语言包
		#>
		if (Deploy_Sync -Mark "Disable_Cleanup_On_Demand_Language") {
			Write-Host "   $($lang.Operable)" -ForegroundColor Green
			Cleanup_On_Demand_Language -Disable
		} else {
			Write-Host "   $($lang.LanguageCleanup)"
			Write-Host "   $($lang.Inoperable)" -ForegroundColor Red
		}

		<#
			.Prevent cleanup of unused feature-on-demand language packs
			.阻止清理未使用的按需功能语言包
		#>
		if (Deploy_Sync -Mark "Disable_Cleanup_Unsed_Language") {
			Write-Host "   $($lang.Operable)" -ForegroundColor Green
			Cleanup_Unsed_Language -Disable
		} else {
			Write-Host "   $($lang.LanguageCleanup)"
			Write-Host "   $($lang.Inoperable)" -ForegroundColor Red
		}
	} else {
		Write-Host "   $($lang.LangSingle) ( $($Global:LanguagesAreInstalled.count) )"
	}

	<#
		.After using the $OEM$ mode to add files, the default is read-only. Change all files to: Normal.
		.使用 $OEM$ 模式添加文件后默认为只读，更改所有文件为：正常。
	#>
	Get-ChildItem "$($env:SystemDrive)\$($Global:UniqueID)" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object { $_.Attributes="Normal" }
	if (Test-Path -Path "$($env:SystemDrive)\Users\Public\Desktop\Office" -PathType Container) {
		Get-ChildItem "$($env:SystemDrive)\Users\Public\Desktop\Office" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object { $_.Attributes="Normal" }
	}

	<#
		.Close the pop-up after entering the system for the first time: Network Location Wizard
		.关闭第一次进入系统后弹出：网络位置向导
	#>
	Write-Host "`n   $($lang.Disable) $($lang.NetworkLocationWizard)"
	New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force -ErrorAction SilentlyContinue | Out-Null

	<#
		.Set system language, keyboard, etc.
		.设置系统语言、键盘等
	#>
	Language_Setting

	<#
		.After completing the prerequisite deployment, determine whether to restart the computer
		.完成先决条件部署后，判断是否重启计算机
	#>
	Write-Host "   $($lang.Reboot)"
	if (Deploy_Sync -Mark "Prerequisites_Reboot") {
		Write-Host "   $($lang.Operable)".PadRight(28) -NoNewline
		$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
		if (-not (Test-Path $regPath)) {
			New-Item -Path $regPath -Force -ErrorAction SilentlyContinue | Out-Null
		}

		$regValue = "cmd /c start /min """" powershell -Command ""Start-Process 'Powershell' -Argument '-ExecutionPolicy ByPass -File ""$((Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..\Engine.ps1" -ErrorAction SilentlyContinue))"" -Functions \""FirstExperience_Deploy -Quit\""' -WindowStyle Minimized -Verb RunAs"""
		New-ItemProperty -Path $regPath -Name "$($Global:UniqueID)" -Value $regValue -PropertyType STRING -Force | Out-Null

		Restart-Computer -Force
		Write-Host "   $($lang.Done)`n" -ForegroundColor Green
	} else {
		Write-Host "   $($lang.Inoperable)"
		FirstExperience_Deploy
	}
}

Function FirstExperience_Deploy
{
	param
	(
		[switch]$Force,
		[switch]$Quit
	)
	if ($Quit) { $Global:QUIT = $true }

	Logo -Title $($lang.FirstDeployment)
	Write-Host "   $($lang.FirstDeployment)`n   $('-' * 80)"

	<#
		.Prerequisite deployment rules
		.先决部署规则
	#>
	$Global:MarkRebootComputer = $False
	$FlagsClearSolutionsRure = $False

	if ($Reboot) {
		$Global:MarkRebootComputer = $True
	}
	if (Deploy_Sync -Mark "First_Experience_Reboot") {
		$Global:MarkRebootComputer = $True
	}

	if (Deploy_Sync -Mark "Clear_Solutions") {
		$FlagsClearSolutionsRure = $True
	}
	if (Deploy_Sync -Mark "Clear_Engine") {
		$FlagsClearSolutionsRure = $True
	}

	<#
		.Pop up the main interface
		.弹出主界面
	#>
	Write-Host "`n   $($lang.FirstDeploymentPopup)"
	if ($FlagsClearSolutionsRure) {
		Write-Host "   $($lang.Inoperable)`n" -ForegroundColor Red
	} else {
		if (Test-Path "$($PSScriptRoot)\..\..\..\..\..\Deploy\Popup_Engine" -PathType Leaf) {
			Write-Host "   $($lang.Operable)`n" -ForegroundColor Green
			Start-Process powershell -ArgumentList "-file $((Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..\Engine.ps1" -ErrorAction SilentlyContinue))"
		} else {
			Write-Host "   $($lang.Inoperable)`n" -ForegroundColor Red
		}
	}

	<#
		.Allow the first pre-experience, as planned
		.允许首次预体验，按计划
	#>
	Write-Host "`n   $($lang.FirstExpFinishOnDemand)"
	if (Test-Path "$($PSScriptRoot)\..\..\..\..\..\Deploy\Allow_First_Pre_Experience" -PathType Leaf)
	{
		Write-Host "   $($lang.Operable)" -ForegroundColor Green



	} else {
		Write-Host "   $($lang.Inoperable)" -ForegroundColor Red
	}

	Write-Host "`n   $($lang.FirstDeployment)"
	Deploy_Guide

	<#
		.Search for Bat and PS1
		.搜索 Bat、PS1
	#>
	write-host "`n   $($lang.DiskSearch)"

	<#
		.Search for local deployment: Bat
		.搜索本地部署：Bat
	#>
	Get-ChildItem -Path "$($PSScriptRoot)\..\..\..\..\..\Deploy\bat" -Filter "*.bat" -ErrorAction SilentlyContinue | ForEach-Object {
		write-host	"   $($lang.DiskSearchFind -f $($_.Fullname))`n" -ForegroundColor Green
		Start-Process -FilePath "$($_.Fullname)"  -wait -WindowStyle Minimized
	}

	<#
		.Search for local deployment: ps1
		.搜索本地部署：ps1
	#>
	Get-ChildItem -Path "$($PSScriptRoot)\..\..\..\..\..\Deploy\ps1" -Filter "*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
		write-host	"   $($lang.DiskSearchFind -f $($_.Fullname))`n" -ForegroundColor Green
		Start-Process "powershell" -ArgumentList "-ExecutionPolicy ByPass -file ""$($_.Fullname)""" -Wait -WindowStyle Minimized
	}

	<#
		.Full plan, search by rule: Bat
		.全盘计划，按规则搜索：Bat
	#>
	$SearchBatFile = @(
		"$($Global:UniqueID).bat"
		"$($Global:UniqueID)\$($Global:UniqueID).bat"
		"$($Global:UniqueID)\Deploy\Bat\$($Global:UniqueID).bat"
	)
	ForEach ($item in $SearchBatFile) {
		Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
			$TempFilePath = Join-Path -Path "$($_.Root)" -ChildPath "$($item)" -ErrorAction SilentlyContinue

			Write-Host "   $($TempFilePath)"
			if (Test-Path $TempFilePath -PathType Leaf) {
				write-host	"   $($lang.DiskSearchFind -f $($TempFilePath))`n" -ForegroundColor Gray
				Start-Process -FilePath "$($TempFilePath)" -wait -WindowStyle Minimized
			}
		}
	}

	<#
		.Full plan, search by rule: ps1
		.全盘计划，按规则搜索：ps1
	#>
	$SearchPSFile = @(
		"$($Global:UniqueID).ps1"
		"$($Global:UniqueID)\$($Global:UniqueID).ps1"
		"$($Global:UniqueID)\Deploy\PS1\$($Global:UniqueID).ps1"
	)
	ForEach ($item in $SearchPSFile) {
		Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
			$TempFilePath = Join-Path -Path "$($_.Root)" -ChildPath "$($item)" -ErrorAction SilentlyContinue

			Write-Host "   $TempFilePath"
			if (Test-Path $TempFilePath -PathType Leaf) {
				write-host	"   $($lang.DiskSearchFind -f $($TempFilePath))`n" -ForegroundColor Gray
				Start-Process "powershell" -ArgumentList "-ExecutionPolicy ByPass -file ""$TempFilePath""" -Wait -WindowStyle Minimized
			}
		}
	}

	<#
		.Recovery PowerShell strategy
		.恢复 PowerShell 策略
	#>
	Write-Host "   $($lang.Restricted)`n" -ForegroundColor Green
	if (Deploy_Sync -Mark "Reset_Execution_Policy") {
		Write-Host "   $($lang.Operable)" -ForegroundColor Green
		Set-ExecutionPolicy -ExecutionPolicy Restricted -Force -ErrorAction SilentlyContinue
		Write-Host "   $($lang.Done)`n" -ForegroundColor Green
	} else {
		Write-Host "   $($lang.Inoperable)" -ForegroundColor Red
	}

	<#
		.Clean up the solution
		.清理解决方案
	#>
	if (Deploy_Sync -Mark "Clear_Solutions") {
		Stop-Transcript -ErrorAction SilentlyContinue | Out-Null
		$UniqueMainFolder = Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..\.." -ErrorAction SilentlyContinue
		Remove_Tree -Path $UniqueMainFolder

		<#
			.In order to prevent the solution from being unable to be cleaned up, the next time you log in, execute it again
			.为了防止无法清理解决方案，下次登录时，再次执行
		#>
		Write-Host "   $($lang.NextDelete)`n" -ForegroundColor Green
		$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
		$regKey = "Clear $($Global:UniqueID) Folder"
		$regValue = "cmd.exe /c rd /s /q ""$($UniqueMainFolder)"""
		if (Test-Path $regPath) {
			New-ItemProperty -Path $regPath -Name $regKey -Value $regValue -PropertyType STRING -Force | Out-Null
		} else {
			New-Item -Path $regPath -Force | Out-Null
			New-ItemProperty -Path $regPath -Name $regKey -Value $regValue -PropertyType STRING -Force | Out-Null
		}
	}

	<#
		.Clean up the main engine
		.清理主引擎
	#>
	if (Deploy_Sync -Mark "Clear_Engine") {
		Stop-Transcript -ErrorAction SilentlyContinue | Out-Null
		Remove_Tree -Path "$($PSScriptRoot)\..\..\..\..\.."
	}

	<#
		.Clean up deployment configuration
		.清理部署配置
	#>
	Remove_Tree -Path "$($PSScriptRoot)\..\..\..\..\..\Deploy"

	if ($Global:MarkRebootComputer) {
		<#
			.Reboot Computer
			.重启计算机
		#>
		Restart-Computer -Force
	}
}

<#
	.Appx cleanup maintenance tasks
	.Appx 清理维护任务
#>
Function Cleanup_Appx_Tasks
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	Write-Host "   $($lang.PreAppxCleanup)"
	if ($Enabled) {
		Write-Host "   $($lang.Enabled)".PadRight(22) -NoNewline
		Enable-ScheduledTask -TaskPath "\Microsoft\Windows\AppxDeploymentClient\" -TaskName "Pre-staged app cleanup" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		Write-Host "   $($lang.Disable)".PadRight(22) -NoNewline
		Disable-ScheduledTask -TaskPath "\Microsoft\Windows\AppxDeploymentClient\" -TaskName "Pre-staged app cleanup" -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Prevent cleaning of unused language packs
	.阻止清理未使用的语言包
#>
Function Cleanup_On_Demand_Language
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)
	
	Write-Host "   $($lang.CleanupUnusedLP)"
	if ($Enabled) {
		Write-Host "   $($lang.Enabled)".PadRight(22) -NoNewline
		Enable-ScheduledTask -TaskPath "\Microsoft\Windows\MUI\" -TaskName "LPRemove" -ErrorAction SilentlyContinue | Out-Null
		Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Control Panel\International" -Name 'BlockCleanupOfUnusedPreinstalledLangPacks' -Force -ErrorAction SilentlyContinue | out-null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
	
	if ($Disable) {
		Write-Host "   $($lang.Disable)".PadRight(22) -NoNewline
		Disable-ScheduledTask -TaskPath "\Microsoft\Windows\MUI\" -TaskName "LPRemove" -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Control Panel\International" -Name "BlockCleanupOfUnusedPreinstalledLangPacks" -Type DWord -Value 1 -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Prevent cleanup of unused feature-on-demand language packs
	.阻止清理未使用的按需功能语言包
#>
Function Cleanup_Unsed_Language
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)
	
	Write-Host "   $($lang.CleanupOndemandLP)"
	if ($Enabled) {
		Write-Host "   $($lang.Enabled)".PadRight(22) -NoNewline
		Enable-ScheduledTask -TaskPath "\Microsoft\Windows\LanguageComponentsInstaller" -TaskName "Uninstallation" -ErrorAction SilentlyContinue | Out-Null
		Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Control Panel\International" -Name 'AllowLanguageFeaturesUninstall' -Force -ErrorAction SilentlyContinue | out-null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
	
	if ($Disable) {
		Write-Host "   $($lang.Disable)".PadRight(22) -NoNewline
		Disable-ScheduledTask -TaskPath "\Microsoft\Windows\LanguageComponentsInstaller" -TaskName "Uninstallation" -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput" -Name "AllowLanguageFeaturesUninstall" -Type DWord -Value 0 -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}