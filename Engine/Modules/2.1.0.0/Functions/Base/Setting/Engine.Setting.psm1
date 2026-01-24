<#
	.Setting
	.设置
#>
Function Setting_UI
{
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $lang.Setting
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\..\Assets\icon\Yi.ico")
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 490
		Width          = 530
		Location       = "0,10"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "16,0,0,0"
		Dock           = 0
	}

	<#
		.语言、更改、显示当前首选语言
	#>
	$GUIImageSourceSettingLP = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 478
		Margin         = "0,10,0,0"
		Text           = $lang.Language
	}

	$GUIImageSourceSettingLP_Change = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 475
		Padding        = "16,0,0,0"
		Text           = "English (United States)"
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			Language -Reset
			Setting_UI
			$UI_Main.Close()
		}
	}

	$Region = Language_Region
	ForEach ($itemRegion in $Region) {
		if ($itemRegion.Region -eq $Global:IsLang) {
			$GUIImageSourceSettingLP_Change.Text = $itemRegion.Name
			break
		}
	}

	$GUIImageSourceSettingUP = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 478
		margin         = "0,30,0,0"
		Text           = $lang.ChkUpdate
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			Update
			$UI_Main.Close()

			Modules_Refresh -Function "Setting_UI"
		}
	}
	$GUIImageSourceSettingUPCurrentVersion = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 475
		Padding        = "10,0,0,0"
		Text           = "$($lang.UpdateCurrent): $((Get-Module -Name Engine).Version.ToString())"
	}

	$GUIImageSourceSettingUP_Auto = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 438
		Padding        = "20,0,0,0"
		Text           = $lang.Auto_Update_Allow
		Checked        = $True
		add_Click      = {
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Error.Text = ""

			if ($This.Checked) {
				Save_Dynamic -regkey "Multilingual\Update" -name "IsAutoUpdate" -value "True"
				$GUIImageSourceSettingUP_Auto_Adv.Enabled = $True
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$UI_Main_Error.Text = "$($lang.Auto_Update_Allow), $($lang.Enable), $($lang.Done)"
			} else {
				Save_Dynamic -regkey "Multilingual\Update" -name "IsAutoUpdate" -value "False"
				$GUIImageSourceSettingUP_Auto_Adv.Enabled = $False
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$UI_Main_Error.Text = "$($lang.Auto_Update_Allow), $($lang.Disable), $($lang.Done)"
			}
		}
	}

	$GUIImageSourceSettingUP_Auto_Adv = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 100
		Width          = 475
		autoSizeMode   = 1
	}

	$GUIImageSourceSettingUP_Auto_Update_New_Allow = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 438
		Location       = '35,5'
		Text           = $lang.Auto_Update_New_Allow
		Checked        = $True
		add_Click      = {
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Error.Text = ""

			if ($This.Checked) {
				Save_Dynamic -regkey "Multilingual\Update" -name "IsAutoUpdateNew" -value "True"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$UI_Main_Error.Text = "$($lang.Auto_Update_New_Allow), $($lang.Enable), $($lang.Done)"
			} else {
				Save_Dynamic -regkey "Multilingual\Update" -name "IsAutoUpdateNew" -value "False"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$UI_Main_Error.Text = "$($lang.Auto_Update_New_Allow), $($lang.Disable), $($lang.Done)"
			}
		}
	}

	$GUIImageSourceSettingUP_Auto_Adv_Auto_Check_Setting = New-Object system.Windows.Forms.NumericUpDown -Property @{
		Height         = 30
		Width          = 45
		Location       = '52,55'
		Minimum        = 1
		Maximum        = 365
		Value          = 6
		add_ValueChanged = {
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Error.Text = ""

			Save_Dynamic -regkey "Multilingual\Update" -name "AutoCheckUpdate_Hours" -value $This.Value
			$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
			$UI_Main_Error.Text = "$($lang.Setting): $($This.Value) $($lang.Auto_Check_Time), $($lang.Done)"
		}
	}

	$GUIImageSourceSettingUP_Auto_Adv_Auto_Check_Time = New-Object system.Windows.Forms.Label -Property @{
		Height         = 60
		Width          = 420
		Location       = '105,58'
		Text           = $lang.Auto_Check_Time
	}
	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "10,618"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 465
		Location       = "35,620"
		Text           = ""
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_Error_Icon,
		$UI_Main_Error
	))
	$UI_Main_Menu.controls.AddRange((
		$GUIImageSourceSettingLP,
		$GUIImageSourceSettingLP_Change,

		$GUIImageSourceSettingUP,
		$GUIImageSourceSettingUPCurrentVersion,
		$GUIImageSourceSettingUP_Auto,
		$GUIImageSourceSettingUP_Auto_Adv
	))

	$GUIImageSourceSettingUP_Auto_Adv.Controls.AddRange((
		$GUIImageSourceSettingUP_Auto_Update_New_Allow,
		$GUIImageSourceSettingUP_Auto_Adv_Auto_Check_Setting,
		$GUIImageSourceSettingUP_Auto_Adv_Auto_Check_Time
	))

	<#
		.允许自动更新
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsAutoUpdate" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsAutoUpdate" -ErrorAction SilentlyContinue) {
			"True"  {
				$GUIImageSourceSettingUP_Auto.Checked = $True
				$GUIImageSourceSettingUP_Auto_Adv.Enabled = $True
			}
			"False" {
				$GUIImageSourceSettingUP_Auto.Checked = $False
				$GUIImageSourceSettingUP_Auto_Adv.Enabled = $False
			}
		}
	} else {
		Save_Dynamic -regkey "Multilingual\Update" -name "IsAutoUpdate" -value "True"
		$GUIImageSourceSettingUP_Auto.Checked = $True
		$GUIImageSourceSettingUP_Auto_Adv.Enabled = $True
	}

	<#
		.允许自动更新新版本
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsAutoUpdateNew" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsAutoUpdateNew" -ErrorAction SilentlyContinue) {
			"True"  { $GUIImageSourceSettingUP_Auto_Update_New_Allow.Checked = $True }
			"False" { $GUIImageSourceSettingUP_Auto_Update_New_Allow.Checked = $False }
		}
	} else {
		$GUIImageSourceSettingUP_Auto_Update_New_Allow.Checked = $True
		Save_Dynamic -regkey "Multilingual\Update" -name "IsAutoUpdateNew" -value "True"
	}

	<#
		.自动检查更新间隔小时
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "AutoCheckUpdate_Hours" -ErrorAction SilentlyContinue) {
		$GUIImageSourceSettingUP_Auto_Adv_Auto_Check_Setting.Value = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "AutoCheckUpdate_Hours" -ErrorAction SilentlyContinue
	} else {
		Save_Dynamic -regkey "Multilingual\Update" -name "AutoCheckUpdate_Hours" -value "2"
		$GUIImageSourceSettingUP_Auto_Adv_Auto_Check_Setting.Value = 2
	}
	#endregion

	$UI_Main.ShowDialog() | Out-Null
}