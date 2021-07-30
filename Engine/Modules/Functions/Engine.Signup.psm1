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
		[switch]$Force,
		[switch]$Quit
	)
	if ($Quit) { $Global:QUIT = $true }

	Logo -Title $($lang.Reset)
	Write-Host "   $($lang.PlanTask)`n   ---------------------------------------------------"

	if ($Force) {
		if (Test-Path "$PSScriptRoot\..\..\Deploy\DoNotUpdate" -PathType Leaf) {
			Write-Host "   - $($lang.UpdateSkipUpdateCheck)"
		} else {
			Write-Host "   - $($lang.ForceUpdate)"
			Update -Auto -Force -IsProcess
		}

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

		$GUISignup.Close()
	}
	$GUISignup         = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 568
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
		Height         = 468
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
	$GUISignupOK       = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "10,482"
		Height         = 36
		Width          = 202
		add_Click      = $GUISignupOKClick
		Text           = $lang.OK
	}
	$GUISignupCanel    = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "218,482"
		Height         = 36
		Width          = 202
		add_Click      = $GUISignupCanelClick
		Text           = $lang.Cancel
	}
	$GUISignup.controls.AddRange((
		$GUISignupPanel,
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
	<#
		.According to the official requirements of Microsoft, add the strategy: Prevent Windows 10 from automatically deleting unused language packs
		.按照微软官方要求，添加策略：防止 Windows 10 自动删除未使用的语言包
	#>
	If (-not (Test-Path "HKLM:\Software\Policies\Microsoft\Control Panel\International")) { New-Item -Path "HKLM:\Software\Policies\Microsoft\Control Panel\International" -Force | Out-Null }
	Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Control Panel\International" -Name "BlockCleanupOfUnusedPreinstalledLangPacks" -Type DWord -Value 1 -ErrorAction SilentlyContinue | Out-Null

	<#
		.After using the $OEM$ mode to add files, the default is read-only. Change all files to: Normal.
		.使用 $OEM$ 模式添加文件后默认为只读，更改所有文件为：正常。
	#>
	Get-ChildItem "$env:SystemDrive\$($Global:UniqueID)" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object { $_.Attributes="Normal" }

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
		.Recovery PowerShell strategy
		.恢复 PowerShell 策略
	#>
	if (Test-Path "$PSScriptRoot\..\..\Deploy\ResetExecutionPolicy" -PathType Leaf) {
		Set-ExecutionPolicy -ExecutionPolicy Restricted -Force -ErrorAction SilentlyContinue
	}

	<#
		.Clean up the solution
		.清理解决方案
	#>
	if (Test-Path "$PSScriptRoot\..\..\Deploy\ClearSolutions" -PathType Leaf) {
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
		if ((Test-Path $regPath)) {
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
	if (Test-Path "$PSScriptRoot\..\..\Deploy\ClearEngine" -PathType Leaf) {
		Stop-Transcript -ErrorAction SilentlyContinue | Out-Null
		RemoveTree -Path "$($Global:UniqueMainFolder)\Engine"
	}

	<#
		.Clean up deployment configuration
		.清理部署配置
	#>
	RemoveTree -Path "$PSScriptRoot\..\..\Deploy"

	<#
		.首次注册模式
		.First registration mode
	#>
	if ($Force) {
		<#
			.Reboot Computer
			.重启计算机
		#>
		Restart-Computer -Force
	}
}

Export-ModuleMember -Function Signup, SignupProcess