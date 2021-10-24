<#
 .Synopsis
  Signup

 .Description
  Signup Feature Modules

 .NOTES
  Author:  Yi
  Website: http://fengyi.tel
#>

<#
	.Register user interface
	.注册用户界面
#>
Function Signup
{
	param
	(
		[switch]$FirstExperience,
		[switch]$Quit
	)
	if ($Quit) { $Global:QUIT = $true }

	Logo -Title $($lang.Reset)
	Write-Host "   $($lang.Reset)`n   ---------------------------------------------------"

	if ($FirstExperience) {
		if (Test-Path -Path "$($PSScriptRoot)\..\..\Deploy\DoNotUpdate" -PathType Leaf) {
			Write-Host "   - $($lang.UpdateSkipUpdateCheck)"
		} else {
			Write-Host "   - $($lang.ForceUpdate)"
			Update -Auto -Force -IsProcess
		}

		<#
			.Usage
			.用法

			-Reboot | Restart the computer
			          重新启动计算机
		#>
		SignupProcess
	} else {
		SignupGUI
	}
}

Function SignupGUI
{
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Write-Host "`n   $($lang.Reset)"

	$GUISignupCanelClick = {
		Write-Host "   $($lang.UserCancel)" -ForegroundColor Red
		$GUISignup.Close()
	}
	$GUISignupOKClick = {
		$GUISignup.Hide()

		if ($GUISignupLangAndKeyboard.Checked) {
			LanguageSetting
			Write-Host "   - $($lang.Done)`n" -ForegroundColor Green
		} else {
			Write-Host "   $($lang.Inoperable)`n" -ForegroundColor Red
		}

		if ($GUISignupDeployCleanup.Checked) {
			RemoveTree -Path "$($PSScriptRoot)\..\..\Deploy"
		}

		if ($GUISignupReboot.Checked) {
			Restart-Computer -Force
		}
		$GUISignup.Close()
	}
	$GUISignup         = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 600
		Width          = 450
		Text           = $lang.Reset
		TopMost        = $True
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
	}
	$GUISignupPanel    = New-Object system.Windows.Forms.Panel -Property @{
		Height         = 438
		Width          = 450
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = 0
		Dock           = 1
	}
	$GUISignupLangAndKeyboard = New-Object System.Windows.Forms.CheckBox -Property @{
		Location       = "10,5"
		Height         = 22
		Width          = 390
		Text           = $lang.SettingLangAndKeyboard
		Checked        = $True
	}
	$GUISignupDeployCleanup = New-Object System.Windows.Forms.Checkbox -Property @{
		Height         = 22
		Width          = 300
		Text           = $lang.DeployCleanup
		Location       = "12,458"
		Checked        = $True
	}
	$GUISignupReboot   = New-Object System.Windows.Forms.Checkbox -Property @{
		Height         = 22
		Width          = 300
		Text           = $lang.Reboot
		Location       = "12,485"
	}
	$GUISignupOK       = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "10,515"
		Height         = 36
		Width          = 202
		add_Click      = $GUISignupOKClick
		Text           = $lang.OK
	}
	$GUISignupCanel    = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "218,515"
		Height         = 36
		Width          = 202
		add_Click      = $GUISignupCanelClick
		Text           = $lang.Cancel
	}
	$GUISignup.controls.AddRange((
		$GUISignupPanel,
		$GUISignupDeployCleanup,
		$GUISignupReboot,
		$GUISignupOK,
		$GUISignupCanel
	))
	$GUISignupPanel.controls.AddRange((
		$GUISignupLangAndKeyboard
	))
 
	switch ($Global:IsLang) {
		"zh-CN" {
			$GUISignup.Font = New-Object System.Drawing.Font("Microsoft YaHei", 9, [System.Drawing.FontStyle]::Regular)
		}
		Default {
			$GUISignup.Font = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Regular)
		}
	}

	$GUISignup.FormBorderStyle = 'Fixed3D'
	$GUISignup.ShowDialog() | Out-Null
}

<#
	.Start processing registration tasks
	.开始处理注册任务
#>
Function SignupProcess
{
	param (
		[switch]$Reboot
	)

	<#
		.According to the official requirements of Microsoft, add the strategy: Prevent Windows 10 from automatically deleting unused language packs
		.按照微软官方要求，添加策略：防止 Windows 10 自动删除未使用的语言包
	#>
	Disable-ScheduledTask -TaskPath "\Microsoft\Windows\AppxDeploymentClient\" -TaskName "Pre-staged app cleanup" -ErrorAction SilentlyContinue | Out-Null
	Disable-ScheduledTask -TaskPath "\Microsoft\Windows\MUI\" -TaskName "LPRemove" -ErrorAction SilentlyContinue | Out-Null
	Disable-ScheduledTask -TaskPath "\Microsoft\Windows\LanguageComponentsInstaller" -TaskName "Uninstallation" -ErrorAction SilentlyContinue | Out-Null

	If (-not (Test-Path "HKLM:\Software\Policies\Microsoft\Control Panel\International")) { New-Item -Path "HKLM:\Software\Policies\Microsoft\Control Panel\International" -Force | Out-Null }
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Control Panel\International" -Name "BlockCleanupOfUnusedPreinstalledLangPacks" -Type DWord -Value 1 -ErrorAction SilentlyContinue | Out-Null

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
	LanguageSetting

	<#
		.After completing the prerequisite deployment, determine whether to restart the computer
		.完成先决条件部署后，判断是否重启计算机
	#>
	if (Test-Path -Path "$($PSScriptRoot)\..\..\Deploy\PrerequisitesReboot" -PathType Leaf) {
		$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
		if (-not (Test-Path $regPath)) {
			New-Item -Path $regPath -Force -ErrorAction SilentlyContinue | Out-Null
		}
	
		$regValue = "powershell -Command ""Start-Process 'Powershell' -Argument '-ExecutionPolicy ByPass -File ""$($Global:UniqueMainFolder)\Engine\Engine.ps1"" -Functions \""FirstDeployment -Quit\""' -WindowStyle Minimized -Verb RunAs"""
		New-ItemProperty -Path $regPath -Name "$($Global:UniqueID)" -Value $regValue -PropertyType STRING -Force | Out-Null

		Restart-Computer -Force
	} else {
		FirstDeployment
	}
}

Function FirstDeployment
{
	param
	(
		[switch]$Force,
		[switch]$Quit
	)
	if ($Quit) { $Global:QUIT = $true }

	Logo -Title $($lang.FirstDeployment)
	Write-Host "   $($lang.FirstDeployment)`n   ---------------------------------------------------"

	<#
		.Prerequisite deployment rules
		.先决部署规则
	#>
	$FlagsRebootComputer = $False
	$FlagsClearSolutionsRure = $False

	if ($Reboot) {
		$FlagsRebootComputer = $True
	}
	if (Test-Path -Path "$($PSScriptRoot)\..\..\Deploy\FirstExperienceReboot" -PathType Leaf) {
		$FlagsRebootComputer = $True
	}

	if (Test-Path -Path "$($PSScriptRoot)\..\..\Deploy\ClearSolutions" -PathType Leaf) {
		$FlagsClearSolutionsRure = $True
	}
	if (Test-Path -Path "$($PSScriptRoot)\..\..\Deploy\ClearEngine" -PathType Leaf) {
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
		if (Test-Path "$($PSScriptRoot)\..\..\Deploy\PopupEngine" -PathType Leaf) {
			Write-Host "   $($lang.Operable)`n" -ForegroundColor Green
			Start-Process powershell -ArgumentList "-file $($PSScriptRoot)\..\..\Engine.ps1"
		} else {
			Write-Host "   $($lang.Inoperable)`n" -ForegroundColor Red
		}
	}

	Write-Host "   $($lang.FirstDeployment)"
	Get-Command -CommandType function | ForEach-Object {
		if ($_ -like "DeployTask*") {
			Write-Host "   $($lang.DeployTask)$($_.Name)"
			Invoke-Expression -Command $_.Name
		}
	}

	<#
		.Search for Bat and PS1
		.搜索 Bat、PS1
	#>
	write-host "`n   $($lang.DiskSearch)"

	<#
		.Search for local deployment: Bat
		.搜索本地部署：Bat
	#>
	Get-ChildItem –Path "$($PSScriptRoot)\..\..\Deploy\bat" -Filter "*.bat" -ErrorAction SilentlyContinue | foreach-Object {
		write-host	"   - $($lang.DiskSearchFind -f $($_.Fullname))`n" -ForegroundColor Green
		Start-Process -FilePath "$($_.Fullname)"  -wait -WindowStyle Minimized
	}

	<#
		.Search for local deployment: ps1
		.搜索本地部署：ps1
	#>
	Get-ChildItem –Path "$($PSScriptRoot)\..\..\Deploy\ps1" -Filter "*.ps1" -ErrorAction SilentlyContinue | foreach-Object {
		write-host	"   - $($lang.DiskSearchFind -f $($_.Fullname))`n" -ForegroundColor Green
		Start-Process "powershell" -ArgumentList "-ExecutionPolicy ByPass -file ""$($_.Fullname)""" -Wait -WindowStyle Minimized
	}

	<#
		.Allow the first pre-experience, as planned
		.允许首次预体验，按计划
	#>
	Write-Host "`n   $($lang.FirstExpFinishOnDemand)"
	if (Test-Path "$($PSScriptRoot)\..\..\Deploy\FirstPreExperience" -PathType Leaf)
	{
		Write-Host "   $($lang.Operable)`n" -ForegroundColor Green

	} else {
		Write-Host "   $($lang.Inoperable)`n" -ForegroundColor Red
	}

	<#
		.Recovery PowerShell strategy
		.恢复 PowerShell 策略
	#>
	if (Test-Path -Path "$($PSScriptRoot)\..\..\Deploy\ResetExecutionPolicy" -PathType Leaf) {
		Set-ExecutionPolicy -ExecutionPolicy Restricted -Force -ErrorAction SilentlyContinue
	}

	<#
		.Clean up the solution
		.清理解决方案
	#>
	if (Test-Path -Path "$($PSScriptRoot)\..\..\Deploy\ClearSolutions" -PathType Leaf) {
		Stop-Transcript -ErrorAction SilentlyContinue | Out-Null
		RemoveTree -Path "$($Global:UniqueMainFolder)"

		<#
			.In order to prevent the solution from being unable to be cleaned up, the next time you log in, execute it again
			.为了防止无法清理解决方案，下次登录时，再次执行
		#>
		Write-Host "   $($lang.NextDelete)`n" -ForegroundColor Green
		$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
		$regKey = "Clear $($Global:UniqueID) Folder"
		$regValue = "cmd.exe /c rd /s /q ""$($Global:UniqueMainFolder)"""
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
	if (Test-Path -Path "$($PSScriptRoot)\..\..\Deploy\ClearEngine" -PathType Leaf) {
		Stop-Transcript -ErrorAction SilentlyContinue | Out-Null
		RemoveTree -Path "$($Global:UniqueMainFolder)\Engine"
	}

	<#
		.Clean up deployment configuration
		.清理部署配置
	#>
	RemoveTree -Path "$($PSScriptRoot)\..\..\Deploy"

	if ($FlagsRebootComputer) {
		<#
			.Reboot Computer
			.重启计算机
		#>
		Restart-Computer -Force
	}
}

Export-ModuleMember -Function * -Alias *