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

	Logo -Title $lang.FirstDeployment
	write-host "  $($lang.FirstDeployment)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	if ($Force) {
		FirstExperience_Process
	} else {
		FirstExperience_Setting_UI
	}

	if ($Quit) {
		Stop-Process $PID
	}
}

Function FirstExperience_Setting_UI
{
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$GUIFE             = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $lang.FirstDeployment
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#FFFFFF"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\..\Assets\icon\Yi.ico")
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
		Height         = 40
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
		Padding        = "16,0,0,20"
	}
	$GUIFEPreAppxCleanupEnabled = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Enable
		Checked        = $True
	}
	$GUIFEPreAppxCleanupDisable = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Disable
	}
	$GUIFELanguageComponents = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
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
		Padding        = "16,0,0,20"
	}
	$GUIFELanguageComponentsEnabled = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Enable
		Checked        = $True
	}
	$GUIFELanguageComponentsDisable = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Disable
	}

	$GUIFECleanupUnusedLP = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
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
		Padding        = "16,0,0,20"
	}
	$GUIFECleanupUnusedLPEnabled = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Enable
		Checked        = $True
	}
	$GUIFECleanupUnusedLPDisable = New-Object System.Windows.Forms.RadioButton -Property @{
		autosize       = 1
		Padding        = "0,0,20,0"
		Text           = $lang.Disable
	}

	$GUIFELangAndKeyboard = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 490
		Text           = $lang.SettingLangAndKeyboard
		Checked        = $True
	}
	$GUIFEUtf8         = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 490
		Text           = $lang.SettingUTF8
	}
	$GUIFEUtf8Tips     = New-Object System.Windows.Forms.Label -Property @{
		Height         = 26
		Width          = 490
		Text           = $lang.SettingUTF8Tips
		margin         = "19,0,0,0"
	}
	$GUIFEUtf8_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 25
		Width          = 490
	}

	$GUIFELocale       = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 40
		Width          = 490
		Text           = "$($lang.SettingLocale) ( $((Get-Culture).Name) )"
	}
	$GUIFELocaleTips   = New-Object System.Windows.Forms.Label -Property @{
		Height         = 26
		Width          = 490
		Text           = $lang.SettingLocaleTips
		margin         = "19,0,0,0"
	}
	$GUIFELocale_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 25
		Width          = 490
	}

	$GUIFEDeployCleanup = New-Object System.Windows.Forms.Checkbox -Property @{
		Height         = 40
		Width          = 505
		Text           = $lang.DeployCleanup
		Location       = "12,550"
		Checked        = $True
	}
	$GUIFEReboot       = New-Object System.Windows.Forms.Checkbox -Property @{
		Height         = 40
		Width          = 505
		Text           = $lang.Reboot
		Location       = "12,585"
	}
	$GUIFEOK           = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 515
		Location       = "8,635"
		Text           = $lang.OK
		add_Click      = {
			$GUIFE.Hide()

			if ($GUIFEPreAppxCleanup.Checked) {
				if ($GUIFEPreAppxCleanupEnabled.Checked) {
					Cleanup_Appx_Tasks -Enabled
				}

				if ($GUIFEPreAppxCleanupDisable.Checked) {
					Cleanup_Appx_Tasks -Disable
				}
			} else {
				write-host "  $($lang.PreAppxCleanup)"
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			if ($GUIFELanguageComponents.Checked) {
				if ($GUIFELanguageComponentsEnabled.Checked) {
					Cleanup_Unsed_Language -Enabled
				}

				if ($GUIFELanguageComponentsDisable.Checked) {
					Cleanup_Unsed_Language -Disable
				}
			} else {
				write-host "  $($lang.CleanupOndemandLP)"
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			if ($GUIFECleanupUnusedLP.Checked) {
				if ($GUIFECleanupUnusedLPEnabled.Checked) {
					Cleanup_On_Demand_Language -Enabled
				}

				if ($GUIFECleanupUnusedLPDisable.Checked) {
					Cleanup_On_Demand_Language -Disable
				}
			} else {
				write-host "  $($lang.CleanupUnusedLP)"
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			if ($GUIFELangAndKeyboard.Checked) {
				Language_Setting
				write-host "  $($lang.Done)`n" -ForegroundColor Green
			} else {
				write-host "  $($lang.SettingLangAndKeyboard)"
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			if ($GUIFEUtf8.Checked) {
				Language_Use_UTF8 -Enabled
			} else {
				write-host "  $($lang.SettingUTF8)"
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			if ($GUIFELocale.Checked) {
				Language_Region_Setting -Force
				write-host "  $($lang.Done)`n" -ForegroundColor Green
			} else {
				write-host "  $($lang.SettingLocale)"
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			write-host "  $($lang.DeployCleanup)"
			if ($GUIFEDeployCleanup.Checked) {
				Remove_Tree -Path "$($PSScriptRoot)\..\..\..\..\..\Deploy"
				write-host "  $($lang.Done)`n" -ForegroundColor Green
			} else {
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}

			write-host "  $($lang.Reboot)"
			if ($GUIFEReboot.Checked) {
				Restart-Computer -Force
				write-host "  $($lang.Done)`n" -ForegroundColor Green
			} else {
				write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
			}
			$GUIFE.Close()
		}
	}
	$GUIFE.controls.AddRange((
		$GUIFEPanel,
		$GUIFEDeployCleanup,
		$GUIFEReboot,
		$GUIFEOK
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
		$GUIFEUtf8_Wrap,
		$GUIFELocale,
		$GUIFELocaleTips,
		$GUIFELocale_Wrap
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
		write-host "  $($lang.LangMul) ( $($Global:LanguagesAreInstalled.count) )"

		<#
			.Appx cleanup maintenance tasks
			.Appx 清理维护任务
		#>
		if (Deploy_Sync -Mark "Disable_Cleanup_Appx_Tasks") {
			write-host "  $($lang.Operable)" -ForegroundColor Green
			Cleanup_Appx_Tasks -Disable
		} else {
			write-host "  $($lang.PreAppxCleanup)"
			write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}

		<#
			.Prevent cleanup of unused feature-on-demand language packs
			.阻止清理未使用的按需功能语言包
		#>
		if (Deploy_Sync -Mark "Disable_Cleanup_On_Demand_Language") {
			write-host "  $($lang.Operable)" -ForegroundColor Green
			Cleanup_On_Demand_Language -Disable
		} else {
			write-host "  $($lang.CleanupOndemandLP)"
			write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}

		<#
			.Prevent cleaning of unused language packs
			.阻止清理未使用的语言包
		#>
		if (Deploy_Sync -Mark "Disable_Cleanup_Unsed_Language") {
			write-host "  $($lang.Operable)" -ForegroundColor Green
			Cleanup_Unsed_Language -Disable
		} else {
			write-host "  $($lang.CleanupUnusedLP)"
			write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}
	} else {
		write-host "  $($lang.LangSingle) ( $($Global:LanguagesAreInstalled.count) )"
	}

	<#
		.Network Location Wizard
		.网络位置向导
	#>
	if (Deploy_Sync -Mark "Disable_Network_Location_Wizard") {
		Network_Location_Wizard -Disable
	} else {
		write-host "  $($lang.NetworkLocationWizard)"
		write-host "  $($lang.Inoperable)" -ForegroundColor Red
	}

	<#
		.After using the $OEM$ mode to add files, the default is read-only. Change all files to: Normal.
		.使用 $OEM$ 模式添加文件后默认为只读，更改所有文件为：正常。
	#>
	Get-ChildItem "$($env:SystemDrive)\$($Global:Author)" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object { $_.Attributes="Normal" }
	if (Test-Path -Path "$($env:SystemDrive)\Users\Public\Desktop\Office" -PathType Container) {
		Get-ChildItem "$($env:SystemDrive)\Users\Public\Desktop\Office" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object { $_.Attributes="Normal" }
	}

	<#
		.Set system language, keyboard, etc.
		.设置系统语言、键盘等
	#>
	Language_Setting

	<#
		.After completing the prerequisite deployment, determine whether to restart the computer
		.完成先决条件部署后，判断是否重启计算机
	#>
	write-host "  $($lang.Reboot)"
	if (Deploy_Sync -Mark "Prerequisites_Reboot") {
		write-host "  $($lang.Operable)".PadRight(28) -NoNewline

		<#
			.Setting: Forcibly bypass UAC prompts
			.设置：强行绕过 UAC 提示
		#>
		$Uac_Bypass = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
		if (Get-ItemProperty -Path $Uac_Bypass -Name "ConsentPromptBehaviorAdmin" -ErrorAction SilentlyContinue) {
			$GetLanguagePrompt = Get-ItemPropertyValue -Path $Uac_Bypass -Name "ConsentPromptBehaviorAdmin" -ErrorAction SilentlyContinue
			Set-ItemProperty -Path $Uac_Bypass -Name "ConsentPromptBehaviorAdmin_Bak" -Value $GetLanguagePrompt -ErrorAction SilentlyContinue

			Set-ItemProperty -Path $Uac_Bypass -Name "ConsentPromptBehaviorAdmin" -Value 0 -ErrorAction SilentlyContinue
		}

		$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
		if (-not (Test-Path $regPath)) {
			New-Item -Path $regPath -Force -ErrorAction SilentlyContinue | Out-Null
		}

		$regValue = "cmd /c start /min """" powershell -Command ""Start-Process 'Powershell' -Argument '-ExecutionPolicy ByPass -File ""$((Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..\Engine.ps1" -ErrorAction SilentlyContinue))"" -Functions \""FirstExperience_Deploy -Quit\""' -WindowStyle Minimized -Verb RunAs"""
		New-ItemProperty -Path $regPath -Name "$($Global:Author)" -Value $regValue -PropertyType STRING -Force | Out-Null

		Restart-Computer -Force
		write-host "  $($lang.Done)`n" -ForegroundColor Green
	} else {
		write-host "  $($lang.Inoperable)"
		FirstExperience_Deploy
	}
}

<#
	.First Deployment
	.首次部署
#>
Function FirstExperience_Deploy
{
	param
	(
		[switch]$Quit
	)

	Logo -Title $lang.FirstDeployment
	write-host "  $($lang.FirstDeployment)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

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
		.Restore last setting: Bypass the UAC prompt
		.恢复上次设置：绕过 UAC 提示
	#>
	$Uac_Bypass = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
	if (Get-ItemProperty -Path $Uac_Bypass -Name "ConsentPromptBehaviorAdmin_Bak" -ErrorAction SilentlyContinue) {
		$GetLanguagePrompt = Get-ItemPropertyValue -Path $Uac_Bypass -Name "ConsentPromptBehaviorAdmin_Bak" -ErrorAction SilentlyContinue
		Set-ItemProperty -Path $Uac_Bypass -Name "ConsentPromptBehaviorAdmin" -Value $GetLanguagePrompt -ErrorAction SilentlyContinue

		Remove-ItemProperty -LiteralPath $Uac_Bypass -Name 'ConsentPromptBehaviorAdmin_Bak' -Force -ErrorAction SilentlyContinue | Out-Null
	}

	<#
		.Pop up the main interface
		.弹出主界面
	#>
	write-host "`n  $($lang.FirstDeploymentPopup)"
	if ($FlagsClearSolutionsRure) {
		write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
	} else {
		if (Test-Path "$($PSScriptRoot)\..\..\..\..\..\Deploy\Popup_Engine" -PathType Leaf) {
			write-host "  $($lang.Operable)`n" -ForegroundColor Green
			Start-Process powershell -ArgumentList "-file $((Convert-Path -Path "$($PSScriptRoot)\..\..\..\..\..\Engine.ps1" -ErrorAction SilentlyContinue))"
		} else {
			write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
		}
	}

	<#
		.Allow the first pre-experience, as planned
		.允许首次预体验，按计划
	#>
	write-host "`n  $($lang.FirstExpFinishOnDemand)"
	if (Test-Path "$($PSScriptRoot)\..\..\..\..\..\Deploy\Allow_First_Pre_Experience" -PathType Leaf) {
		write-host "  $($lang.Operable)" -ForegroundColor Green



	} else {
		write-host "  $($lang.Inoperable)" -ForegroundColor Red
	}

	write-host "`n  $($lang.FirstDeployment)"
	Deploy_Guide

	<#
		.Search for Bat and PS1
		.搜索 Bat、PS1
	#>
	write-host "`n  $($lang.DiskSearch)"

	<#
		.Search for local deployment: Bat
		.搜索本地部署：Bat
	#>
	Get-ChildItem -Path "$($PSScriptRoot)\..\..\..\..\..\Deploy\bat" -Filter "*.bat" -ErrorAction SilentlyContinue | ForEach-Object {
		Write-Host	"   $($lang.DiskSearchFind): " -NoNewline
		Write-host $_.Fullname -ForegroundColor Green
		Start-Process -FilePath $_.Fullname -wait -WindowStyle Minimized
	}

	<#
		.Search for local deployment: ps1
		.搜索本地部署：ps1
	#>
	Get-ChildItem -Path "$($PSScriptRoot)\..\..\..\..\..\Deploy\ps1" -Filter "*.ps1" -ErrorAction SilentlyContinue | ForEach-Object {
		Write-Host	"   $($lang.DiskSearchFind): " -NoNewline
		Write-host $_.Fullname -ForegroundColor Green
		$arguments = @(
			"-ExecutionPolicy",
			"ByPass",
			"-File",
			"""$($_.Fullname)"""
		)

		Start-Process "powershell" -ArgumentList $arguments -Wait -WindowStyle Minimized
	}

	<#
		.Full plan, search by rule: Bat
		.全盘计划，按规则搜索：Bat
	#>
	$SearchBatFile = @(
		"$($Global:Author).bat"
		"$($Global:Author)\$($Global:Author).bat"
		"$($Global:Author)\Deploy\$($Global:Author).bat"
		"$($Global:Author)\Deploy\Bat\$($Global:Author).bat"
	)
	ForEach ($item in $SearchBatFile) {
		Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
			$TempFilePath = Join-Path -Path $_.Root -ChildPath $item

			write-host "  $($TempFilePath)"
			if (Test-Path $TempFilePath -PathType Leaf) {
				Write-Host	"   $($lang.DiskSearchFind): " -NoNewline
				Write-host $TempFilePath -ForegroundColor Green
				Start-Process -FilePath $TempFilePath -wait -WindowStyle Minimized
			}
		}
	}

	<#
		.Full plan, search by rule: ps1
		.全盘计划，按规则搜索：ps1
	#>
	$SearchPSFile = @(
		"$($Global:Author).ps1"
		"$($Global:Author)\$($Global:Author).ps1"
		"$($Global:Author)\Deploy\$($Global:Author).ps1"
		"$($Global:Author)\Deploy\PS1\$($Global:Author).ps1"
	)
	ForEach ($item in $SearchPSFile) {
		Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
			$TempFilePath = Join-Path -Path $_.Root -ChildPath $item

			write-host "  $($TempFilePath)"
			if (Test-Path $TempFilePath -PathType Leaf) {
				Write-Host	"   $($lang.DiskSearchFind): " -NoNewline
				Write-host $TempFilePath -ForegroundColor Green

				$arguments = @(
					"-ExecutionPolicy",
					"ByPass",
					"-File",
					"""$($TempFilePath)"""
				)

				Start-Process "powershell" -ArgumentList $arguments -Wait -WindowStyle Minimized
			}
		}
	}

	<#
		.Recovery PowerShell strategy
		.恢复 PowerShell 策略
	#>
	write-host "`n  $($lang.Restricted)`n" -ForegroundColor Green
	if (Deploy_Sync -Mark "Reset_Execution_Policy") {
		write-host "  $($lang.Operable)" -ForegroundColor Green
		Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope LocalMachine -Force
		Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser -Force
		write-host "  $($lang.Done)`n" -ForegroundColor Green
	} else {
		write-host "  $($lang.Inoperable)" -ForegroundColor Red
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
		write-host "  $($lang.NextDelete)`n" -ForegroundColor Green
		$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
		$regKey = "Clear $($Global:Author) Folder"
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

	if ($Quit) {
		Stop-Process $PID
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

	write-host "`n  $($lang.PreAppxCleanup)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Enable-ScheduledTask -TaskPath "\Microsoft\Windows\AppxDeploymentClient\" -TaskName "Pre-staged app cleanup" -ErrorAction SilentlyContinue | Out-Null
		Write-Host $lang.Done -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Disable-ScheduledTask -TaskPath "\Microsoft\Windows\AppxDeploymentClient\" -TaskName "Pre-staged app cleanup" -ErrorAction SilentlyContinue | Out-Null
		Write-Host $lang.Done -ForegroundColor Green
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

	write-host "`n  $($lang.CleanupUnusedLP)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Enable-ScheduledTask -TaskPath "\Microsoft\Windows\MUI\" -TaskName "LPRemove" -ErrorAction SilentlyContinue | Out-Null

		Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Control Panel\International" -Name 'BlockCleanupOfUnusedPreinstalledLangPacks' -Force -ErrorAction SilentlyContinue | out-null
		Write-Host $lang.Done -ForegroundColor Green
	}
	
	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Disable-ScheduledTask -TaskPath "\Microsoft\Windows\MUI\" -TaskName "LPRemove" -ErrorAction SilentlyContinue | Out-Null

		If (-not (Test-Path "HKLM:\Software\Policies\Microsoft\Control Panel\International")) {
			New-Item -Path "HKLM:\Software\Policies\Microsoft\Control Panel\International" -Force | Out-Null
		}
		Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Control Panel\International" -Name "BlockCleanupOfUnusedPreinstalledLangPacks" -Type DWord -Value 1 -ErrorAction SilentlyContinue | Out-Null
		Write-Host $lang.Done -ForegroundColor Green
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

	write-host "`n  $($lang.CleanupOndemandLP)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Enable-ScheduledTask -TaskPath "\Microsoft\Windows\LanguageComponentsInstaller" -TaskName "Uninstallation" -ErrorAction SilentlyContinue | Out-Null

		Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput" -Name 'AllowLanguageFeaturesUninstall' -Force -ErrorAction SilentlyContinue | out-null
		Write-Host $lang.Done -ForegroundColor Green
	}
	
	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Disable-ScheduledTask -TaskPath "\Microsoft\Windows\LanguageComponentsInstaller" -TaskName "Uninstallation" -ErrorAction SilentlyContinue | Out-Null

		If (-not (Test-Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput")) {
			New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput" -Force | Out-Null
		}
		Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\TextInput" -Name "AllowLanguageFeaturesUninstall" -Type DWord -Value 0 -ErrorAction SilentlyContinue | Out-Null
		Write-Host $lang.Done -ForegroundColor Green
	}
}

<#
	.Network Location Wizard
	.网络位置向导
#>
Function Network_Location_Wizard
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "`n  $($lang.NetworkLocationWizard)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
		Write-Host $lang.Done -ForegroundColor Green
	}
	
	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force -ErrorAction SilentlyContinue | Out-Null
		Write-Host $lang.Done -ForegroundColor Green
	}
}