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
		BackColor      = "#FFFFFF"
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
	$UI_Setting_Lang = New-Object system.Windows.Forms.Label -Property @{
		Height         = 35
		Width          = 478
		Margin         = "0,10,0,0"
		Text           = $lang.Language
	}

	$UI_Setting_Lang_Change = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 475
		Padding        = "16,0,0,0"
		Text           = "English (United States)"
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
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
			$UI_Setting_Lang_Change.Text = $itemRegion.Name
			break
		}
	}

	$UI_Setting_Auto_Update_Check = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 478
		margin         = "0,30,0,0"
		Text           = $lang.ChkUpdate
		LinkColor      = "#008000"
		ActiveLinkColor = "#FF0000"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main.Hide()
			Update
			$UI_Main.Close()

			Modules_Refresh -Function "Setting_UI"
		}
	}
	$UI_Setting_Auto_Update_CV = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 475
		Padding        = "10,0,0,0"
		Text           = "$($lang.UpdateCurrent): $((Get-Module -Name Engine).Version.ToString())"
	}

	$UI_Setting_Auto_Update = New-Object System.Windows.Forms.CheckBox -Property @{
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
				$UI_Setting_Auto_Update_Adv.Enabled = $True
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$UI_Main_Error.Text = "$($lang.Auto_Update_Allow), $($lang.Enable), $($lang.Done)"
			} else {
				Save_Dynamic -regkey "Multilingual\Update" -name "IsAutoUpdate" -value "False"
				$UI_Setting_Auto_Update_Adv.Enabled = $False
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$UI_Main_Error.Text = "$($lang.Auto_Update_Allow), $($lang.Disable), $($lang.Done)"
			}
		}
	}

	$UI_Setting_Auto_Update_Adv = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 150
		Width          = 475
		autoSizeMode   = 1
	}
	$UI_Setting_Auto_Update_Adv_Auto_Check_Setting = New-Object system.Windows.Forms.NumericUpDown -Property @{
		Height         = 30
		Width          = 45
		Location       = '38,5'
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

	$UI_Setting_Auto_Update_Check_Time = New-Object system.Windows.Forms.Label -Property @{
		Height         = 40
		Width          = 420
		Location       = '95,8'
		Text           = $lang.Auto_Check_Time
	}

	$UI_Setting_Auto_Update_New_Allow = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 438
		Location       = '35,55'
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

	$UI_Setting_Auto_Update_Clean = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 438
		Location       = '35,95'
		Text           = $lang.UpdateClean
		add_Click      = {
			$UI_Main_Error_Icon.Image = $null
			$UI_Main_Error.Text = ""

			if ($This.Checked) {
				Save_Dynamic -regkey "Multilingual\Update" -name "IsUpdate_Clean_Allow" -value "True"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$UI_Main_Error.Text = "$($lang.UpdateClean), $($lang.Enable), $($lang.Done)"
			} else {
				Save_Dynamic -regkey "Multilingual\Update" -name "IsUpdate_Clean_Allow" -value "False"
				$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Success.ico")
				$UI_Main_Error.Text = "$($lang.UpdateClean), $($lang.Disable), $($lang.Done)"
			}
		}
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
		$UI_Setting_Lang,
		$UI_Setting_Lang_Change,
		$UI_Setting_Auto_Update_Check,
		$UI_Setting_Auto_Update_CV,
		$UI_Setting_Auto_Update,
		$UI_Setting_Auto_Update_Adv
	))

	$UI_Setting_Auto_Update_Adv.Controls.AddRange((
		$UI_Setting_Auto_Update_Adv_Auto_Check_Setting,
		$UI_Setting_Auto_Update_Check_Time,
		$UI_Setting_Auto_Update_New_Allow,
		$UI_Setting_Auto_Update_Clean
	))

	<#
		.允许自动清理旧版本
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsUpdate_Clean_Allow" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsUpdate_Clean_Allow" -ErrorAction SilentlyContinue) {
			"True"  { $UI_Setting_Auto_Update_Clean.Checked = $True }
			"False" { $UI_Setting_Auto_Update_Clean.Checked = $False }
		}
	} else {
		$UI_Setting_Auto_Update_Clean.Checked = $True
		Save_Dynamic -regkey "Multilingual\Update" -name "IsUpdate_Clean_Allow" -value "True"
	}

	<#
		.允许自动更新
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsAutoUpdate" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsAutoUpdate" -ErrorAction SilentlyContinue) {
			"True"  {
				$UI_Setting_Auto_Update.Checked = $True
				$UI_Setting_Auto_Update_Adv.Enabled = $True
			}
			"False" {
				$UI_Setting_Auto_Update.Checked = $False
				$UI_Setting_Auto_Update_Adv.Enabled = $False
			}
		}
	} else {
		Save_Dynamic -regkey "Multilingual\Update" -name "IsAutoUpdate" -value "True"
		$UI_Setting_Auto_Update.Checked = $True
		$UI_Setting_Auto_Update_Adv.Enabled = $True
	}

	<#
		.允许自动更新新版本
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsAutoUpdateNew" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsAutoUpdateNew" -ErrorAction SilentlyContinue) {
			"True"  { $UI_Setting_Auto_Update_New_Allow.Checked = $True }
			"False" { $UI_Setting_Auto_Update_New_Allow.Checked = $False }
		}
	} else {
		$UI_Setting_Auto_Update_New_Allow.Checked = $True
		Save_Dynamic -regkey "Multilingual\Update" -name "IsAutoUpdateNew" -value "True"
	}

	<#
		.自动检查更新间隔小时
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "AutoCheckUpdate_Hours" -ErrorAction SilentlyContinue) {
		$UI_Setting_Auto_Update_Adv_Auto_Check_Setting.Value = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "AutoCheckUpdate_Hours" -ErrorAction SilentlyContinue
	} else {
		Save_Dynamic -regkey "Multilingual\Update" -name "AutoCheckUpdate_Hours" -value "2"
		$UI_Setting_Auto_Update_Adv_Auto_Check_Setting.Value = 2
	}
	#endregion

	$UI_Main.ShowDialog() | Out-Null
}