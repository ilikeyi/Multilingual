<#
	.Update minimum version requirements
	.更新最低版本要求
#>
$Global:ChkLocalver = "1.1.0.0"

<#
	.Server test
	.服务器测试
#>
$ServerTest     = $false
$IsCorrectAuVer = $false

<#
	.Available servers
	.可用的服务器

	Usage:
	用法：

       Only one URL address must be added in front of the, number, multiple addresses do not need to be added, example:
       只有一个 URL 地址必须在前面添加 , 号，多地址不用添加，示例：

	$PreServerList = @(
		,("$($Global:AuthorURL)",
		  "/download/solutions/update/Multilingual/latest.json")
	)
#>
$Global:ServerList = @()
$PreServerList = @(
	("$($Global:AuthorURL)",
	 "/download/solutions/update/Multilingual/latest.json"),
	("https://github.com",
	 "/ilikeyi/solutions/raw/main/update/Multilingual/latest.json")
)

<#
	.Update the user interface
	.更新用户界面
#>
Function Update
{
	param
	(
		[switch]$Auto,
		[switch]$Force,
		[switch]$IsProcess
	)
	
	$Global:ServerList = @()
	if ($IsProcess) {
		$Script:IsProcess = $True
	} else {
		$Script:IsProcess = $False
	}

	Logo -Title $($lang.Update)
	Write-Host "   $($lang.Update)`n   ---------------------------------------------------"

	if ($Auto) {
		foreach ($item in $PreServerList | Sort-Object { Get-Random } ) {
			$Global:ServerList += $item[0] + $item[1]
		}

		Update_Process -Force
	} else {
		Update_Setting_UI
		Modules_Refresh -Function "ToMainpage -wait 2"
	}
}

<#
	.Update interface
	.更新界面
#>
Function Update_Setting_UI
{
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$GUIUpdateAutoClick = {
		if ($GUIUpdateAuto.Checked) {
			$GUIUpdatePanel.Enabled = $False
		} else {
			$GUIUpdatePanel.Enabled = $True
		}
	}
	$GUIUpdateCanelClick = {
		$GUIUpdate.Hide()
		$Global:ServerList = @()
		$Global:UpdateAvailableSilent = $False
		$Global:UpdateAvailableReset = $False

		Write-Host "   $($lang.UserCancel)" -ForegroundColor Red
		$GUIUpdate.Close()
	}
	$GUIUpdateOKClick = {
		$Global:ServerList = @()

		if ($GUIUpdateSilent.Checked) {
			$Global:UpdateAvailableSilent = $True
		} else {
			$Global:UpdateAvailableSilent = $False
		}

		if ($GUIUpdateReset.Checked) {
			$Global:UpdateAvailableReset = $True
		} else {
			$Global:UpdateAvailableReset = $False
		}

		if ($GUIUpdateAuto.Checked) {
			$GUIUpdate.Hide()
			foreach ($item in $PreServerList | Sort-Object { Get-Random } ) {
				$Global:ServerList += $item[0] + $item[1]
			}
			Update_Process
			$GUIUpdate.Close()
		} else {
			$FlagsVerifyServerlist = $False
			$GUIUpdatePanel.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($_.Checked) {
						$FlagsVerifyServerlist = $true
						$Global:ServerList += $_.Tag
					}
				}
			}

			if ($FlagsVerifyServerlist) {
				$GUIUpdate.Hide()
				Update_Process
				$GUIUpdate.Close()
			} else {
				$GUIUpdateErrorMsg.Text = "$($lang.UpdateServerNoSelect)"
			}
		}
	}
	$GUIUpdate         = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $lang.Update
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
	}
	$GUIUpdateAuto     = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 505
		Text           = $lang.UpdateServerSelect
		Location       = '10,6'
		add_Click      = $GUIUpdateAutoClick
		Checked        = $True
	}
	$GUIUpdatePanel    = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 415
		Width          = 530
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "24,0,8,0"
		Dock           = 0
		Location       = "0,28"
		Enabled        = $False
	}
	$GUIUpdateSilent   = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 505
		Text           = $lang.UpdateSilent
		Location       = '12,465'
		Checked        = $True
	}
	$GUIUpdateReset    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 505
		Text           = $lang.UpdateReset
		Location       = '12,493'
	}
	$GUIUpdateResetTips = New-Object system.Windows.Forms.Label -Property @{
		Location       = "28,518"
		Height         = 36
		Width          = 490
		Text           = $lang.UpdateResetTips
	}
	$GUIUpdateErrorMsg = New-Object system.Windows.Forms.Label -Property @{
		Location       = "10,570"
		Height         = 22
		Width          = 490
		Text           = ""
	}
	$GUIUpdateOK       = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "8,595"
		Height         = 36
		Width          = 515
		add_Click      = $GUIUpdateOKClick
		Text           = $lang.OK
	}
	$GUIUpdateCanel    = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "8,635"
		Height         = 36
		Width          = 515
		add_Click      = $GUIUpdateCanelClick
		Text           = $lang.Cancel
	}
	$GUIUpdate.controls.AddRange((
		$GUIUpdateAuto,
		$GUIUpdatePanel,
		$GUIUpdateSilent,
		$GUIUpdateReset,
		$GUIUpdateResetTips,
		$GUIUpdateErrorMsg,
		$GUIUpdateOK,
		$GUIUpdateCanel
	))

	foreach ($list in $PreServerList) {
		$fullurl = $list[0] + $list[1]
		$CheckBox   = New-Object System.Windows.Forms.CheckBox -Property @{
			Height  = 28
			Width   = 395
			Text    = $list[0]
			Tag     = $fullurl
			Checked = $true
		}
		$GUIUpdatePanel.controls.AddRange($CheckBox)
	}

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$GUIUpdateAllSelClick = {
		$GUIUpdatePanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	}
	$GUIUpdateAllClearClick = {
		$GUIUpdatePanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	}
	$GUIUpdateMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$GUIUpdateMenu.Items.Add($lang.AllSel).add_Click($GUIUpdateAllSelClick)
	$GUIUpdateMenu.Items.Add($lang.AllClear).add_Click($GUIUpdateAllClearClick)
	$GUIUpdatePanel.ContextMenuStrip = $GUIUpdateMenu

	switch ($Global:IsLang) {
		"zh-CN" {
			$GUIUpdate.Font = New-Object System.Drawing.Font("Microsoft YaHei", 9, [System.Drawing.FontStyle]::Regular)
		}
		Default {
			$GUIUpdate.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
		}
	}

	$GUIUpdate.FormBorderStyle = 'Fixed3D'
	$GUIUpdate.ShowDialog() | Out-Null
}

<#
	.Update process
	.更新处理
#>
Function Update_Process
{
	param
	(
		[switch]$Force
	)

	<#
		.Disabled IE first-launch configuration
		.禁用 IE 首次启动配置
	#>
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 2 -ErrorAction SilentlyContinue

	Write-Host "   $($lang.UpdateCheckServerStatus -f $($Global:ServerList.Count))
   ---------------------------------------------------"

	foreach ($item in $Global:ServerList) {
		Write-Host "   * $($lang.UpdateServerAddress -f $($item))"
		if (Test_URI $item) {
			$PreServerVersion = $item
			$ServerTest = $true
			Write-Host "     $($lang.UpdateServeravailable)" -ForegroundColor Green
			break
		} else {
			Write-Host "     $($lang.UpdateServerUnavailable)`n" -ForegroundColor Red
		}
	}

	if ($ServerTest) {
		Write-Host "   ---------------------------------------------------"
		Write-Host "     $($lang.UpdatePriority)" -ForegroundColor Green
	} else {
		Write-Host "     $($lang.UpdateServerTestFailed)" -ForegroundColor Red
		Write-Host "   ---------------------------------------------------"
		return
	}

	Write-host "`n   $($lang.UpdateQueryingUpdate)"

	$error.Clear()
	$time = Measure-Command { Invoke-WebRequest -Uri $PreServerVersion -TimeoutSec 15 -ErrorAction stop }

	if ($error.Count -eq 0) {
		Write-Host "`n   $($lang.UpdateQueryingTime -f $($time.TotalMilliseconds))"
	} else {
		Write-host "`n   $($lang.UpdateConnectFailed)"
		return
	}

	$getSerVer = (Invoke-RestMethod -Uri $PreServerVersion -UseBasicParsing -Body $body -Method:Get -Headers $head -ContentType "application/json" -TimeoutSec 15 -ErrorAction:stop)
	$chkRemovever = $($getSerVer.version.minau).Replace('.', '')
	$url = $getSerVer.url

	If (([String]::IsNullOrEmpty($chkRemovever))) {
		$IsCorrectAuVer = $false
	} else {
		if ($Global:ChkLocalver.Replace('.', '') -ge $chkRemovever) {
			$IsCorrectAuVer = $true
		} else {
			$IsCorrectAuVer = $false
		}
	}

	if ($IsCorrectAuVer) {
		Write-Host "`n   $($lang.UpdateMinimumVersion -f $($Global:ChkLocalver))"
		$IsUpdateAvailable = $false

		if ($getSerVer.version.version.Replace('.', '') -gt (Get-Module -Name Engine).Version.ToString().Replace('.', '')) {
			$IsUpdateAvailable = $true
		} else {
			$IsUpdateAvailable = $false
		}

		if ($IsUpdateAvailable) {
			Write-host "`n   $($lang.UpdateVerifyAvailable)`n   ---------------------------------------------------"
			Write-Host "   * $($lang.UpdateDownloadAddress)$($url)"
			if (Test_URI $url) {
				Write-Host "     $($lang.UpdateAvailable)" -ForegroundColor Green
				Write-Host "   ---------------------------------------------------"

				Write-host "`n   $($lang.UpdateCurrent)$((Get-Module -Name Engine).Version.ToString())
   $($lang.UpdateLatest)$($getSerVer.version.version)

   $($getSerVer.changelog.title)
   $('-' * ($getSerVer.changelog.title).Length)
$($getSerVer.changelog.log)`n"
	
				Write-host "   $($lang.UpdateNewLatest)`n" -ForegroundColor Green

				$FlagsCheckForceUpdate = $False
				if ($Force) {
					$FlagsCheckForceUpdate = $True
				}

				if ($Global:UpdateAvailableSilent) {
					$FlagsCheckForceUpdate = $True
				}
	
				if ($Global:UpdateAvailableReset) {
					$FlagsCheckForceUpdate = $True
				}
	
				If ($FlagsCheckForceUpdate) {
					Update_And_Download -url $url
				} else {
					$title = "$($lang.UpdateInstall)"
					$message = "$($lang.UpdateInstallSel)"
					$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Yes"
					$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "No"
					$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
					$prompt=$host.ui.PromptForChoice($title, $message, $options, 0)
					Switch ($prompt)
					{
						0 {
							Update_And_Download -url $url
						}
						1 {
							Write-Host "`n   $($lang.UserCancel)"
						}
					}
				}
			} else {
				Write-Host "     $($lang.UpdateUnavailable)" -ForegroundColor Red
				Write-Host "   ---------------------------------------------------"
				return
			}
		} else {
			if ($Global:UpdateAvailableReset) {
				Write-host "`n   $($lang.UpdateVerifyAvailable)`n   ---------------------------------------------------"
				Write-Host "   * $($lang.UpdateDownloadAddress)$($url)"
				if (Test_URI $url) {
					Write-Host "     $($lang.UpdateAvailable)" -ForegroundColor Green
					Write-Host "   ---------------------------------------------------"
					Update_And_Download -url $url
				} else {
					Write-Host "     $($lang.UpdateUnavailable)" -ForegroundColor Red
					Write-Host "   ---------------------------------------------------"
					return
				}
			} else {
				Write-host "   $($lang.UpdateNoUpdateAvailable -f $($Global:UniqueID))"
			}
		}
	} else {
		Write-host "   $($lang.UpdateNotSatisfied -f $($Global:ChkLocalver), $($Global:UniqueID))"
	}
}

Function Update_And_Download
{
	param
	(
		$url
	)

	$output = "$($PSScriptRoot)\..\..\..\..\latest.zip"

	$start_time = Get-Date
	remove-item -path $output -force -ErrorAction SilentlyContinue
	Invoke-WebRequest -Uri $url -OutFile $output -TimeoutSec 30 -DisableKeepAlive -ErrorAction SilentlyContinue | Out-Null
	Write-Host "`n   $($lang.UpdateTimeUsed)$((Get-Date).Subtract($start_time).Seconds) (s)`n"

	if (Test-Path -Path $output -PathType Leaf) {
		Archive -filename $output -to "$($PSScriptRoot)\..\..\..\.."
		Modules_Refresh -Function "Unzip_Done_Refresh_Process"
		remove-item -path $output -force -ErrorAction SilentlyContinue
	} else {
		Write-host "`n   $($lang.UpdateUpdateStop)"
	}
}

<#
	.Test if the URL address is available
	.测试 URL 地址是否可用
#>
Function Test_URI
{
	Param
	(
		[Parameter(Position=0,Mandatory,HelpMessage="HTTP or HTTPS")]
		[ValidatePattern( "^(http|https)://" )]
		[Alias("url")]
		[string]$URI,
		[Parameter(ParameterSetName="Detail")]
		[Switch]$Detail,
		[ValidateScript({$_ -ge 0})]
		[int]$Timeout = 30
	)
	Process
	{
		Try
		{
			$paramHash = @{
				UseBasicParsing = $True
				DisableKeepAlive = $True
				Uri = $uri
				Method = 'Head'
				ErrorAction = 'stop'
				TimeoutSec = $Timeout
			}
			$test = Invoke-WebRequest @paramHash
			if ($Detail) {
				$test.BaseResponse | Select-Object ResponseURI,ContentLength,ContentType,LastModified, @{Name="Status";Expression={$Test.StatusCode}}
			} else {
				if ($test.statuscode -ne 200) { $False } else { $True }
			}
		} Catch {
			write-verbose -message $_.exception
			if ($Detail) {
				$objProp = [ordered]@{
					ResponseURI = $uri
					ContentLength = $null
					ContentType = $null
					LastModified = $null
					Status = 404
				}
				New-Object -TypeName psobject -Property $objProp
			} else { $False }
		}
	}
}

<#
	.Execute Function processing, after decompression is complete
	.执行 函数处理，解压完成后
#>
Function Unzip_Done_Refresh_Process
{
	$PPocess  = "$($PSScriptRoot)\..\..\..\..\Post.Processing.bat"
	$PsPocess = "$($PSScriptRoot)\..\..\..\..\Post.Processing.ps1"

	<#
		.Execute function processing, after the update is complete
		.执行 函数处理，更新完成后
	#>
	Update_Done_Refresh_Process

	Write-Host "`n   * $($lang.UpdatePostProc)"
	if ($Script:IsProcess) {
		Write-Host "   $($lang.UpdateNotExecuted)" -ForegroundColor red
	} else {
		Write-Host "`n   $($PPocess)"
		if (Test-Path -Path $PPocess -PathType Leaf) {
			Start-Process -FilePath $PPocess -wait -WindowStyle Minimized
			remove-item -path $PPocess -force
			Write-Host "   $($lang.Done)" -ForegroundColor Green
		} else {
			Write-Host "   $($lang.UpdateNoPost)" -ForegroundColor red
		}

		Write-Host "`n   $($PsPocess)"
		if (Test-Path -Path $PsPocess -PathType Leaf) {
			Start-Process powershell -ArgumentList "-file $($PsPocess)" -Wait -WindowStyle Minimized
			remove-item -path $PsPocess -force
			Write-Host "   $($lang.Done)" -ForegroundColor Green
		} else {
			Write-Host "   $($lang.UpdateNoPost)" -ForegroundColor red
		}

		Write-host "`n   $($Global:UniqueID)'s Solutions $($lang.UpdateDone)`n"
	}
}

<#
	.Execute function processing, after the update is complete
	.执行 函数处理，更新完成后
#>
Function Update_Done_Refresh_Process
{
	Write-Host "`n   $($lang.UpdateDoneRefresh)"
	<#
		.Add code from here
		.从此处添加代码
	#>

	Write-Host "   $($lang.Done)`n" -ForegroundColor Green
}