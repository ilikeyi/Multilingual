<#
	.Server test
	.服务器测试
#>
$ServerTest     = $false
$IsCorrectAuVer = $false

$Script:ServerList = @()

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

	$Script:ServerList = @()
	if ($IsProcess) {
		$Script:IsProcess = $True
	} else {
		$Script:IsProcess = $False
	}

	Logo -Title $lang.ChkUpdate
	write-host "  $($lang.ChkUpdate)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	if ($Auto) {
		ForEach ($item in (Get-Module -Name Engine).PrivateData.PSData.UpdateServer | Sort-Object { Get-Random } ) {
			$Script:ServerList += $item
		}

		Update_Process -Force
	} else {
		Update_Setting_UI
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

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $lang.ChkUpdate
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
		Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$($PSScriptRoot)\..\..\..\..\Assets\icon\Yi.ico")
	}
	$UI_Main_Auto_Select = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 505
		Location       = '10,15'
		Text           = $lang.UpdateServerSelect
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			if ($UI_Main_Auto_Select.Checked) {
				$UI_Main_Menu.Enabled = $False
			} else {
				$UI_Main_Menu.Enabled = $True
			}
		}
	}
	$UI_Main_Menu      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 290
		Width          = 530
		Location       = "0,45"
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = "24,0,8,0"
		Dock           = 0
		Enabled        = $False
	}
	$IsAllowSHA256Check = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 505
		Location       = '12,365'
		Text           = $lang.IsAllowSHA256Check
		Checked        = $True
	}
	$UI_Main_Silent    = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 505
		Location       = '12,400'
		Text           = $lang.UpdateSilent
		Checked        = $True
	}
	$UI_Main_Clean     = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 505
		Location       = '12,435'
		Text           = $lang.UpdateClean
	}
	$UI_Main_Reset     = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 505
		Location       = '12,470'
		Text           = $lang.UpdateReset
	}
	$UI_Main_Reset_Tips = New-Object system.Windows.Forms.Label -Property @{
		Height         = 36
		Width          = 490
		Location       = "28,505"
		Text           = $lang.UpdateResetTips
	}

	$UI_Main_Error_Icon = New-Object system.Windows.Forms.PictureBox -Property @{
		Location       = "10,598"
		Height         = 20
		Width          = 20
		SizeMode       = "StretchImage"
	}
	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 465
		Location       = "35,600"
		Text           = ""
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 515
		Location       = "8,635"
		Text           = $lang.OK
		add_Click      = {
			$UI_Main_Error.Text = ""
			$UI_Main_Error_Icon.Image = $null

			$Script:ServerList = @()

			if ($UI_Main_Auto_Select.Checked) {
				$UI_Main.Hide()
				ForEach ($item in (Get-Module -Name Engine).PrivateData.PSData.UpdateServer | Sort-Object { Get-Random } ) {
					$Script:ServerList += $item
				}
				Update_Process
				$UI_Main.Close()
			} else {
				$UI_Main_Menu.Controls | ForEach-Object {
					if ($_ -is [System.Windows.Forms.CheckBox]) {
						if ($_.Checked) {
							$Script:ServerList += $_.Tag
						}
					}
				}

				if ($Script:ServerList.Count -gt 0) {
					$UI_Main.Hide()
					Update_Process
					$UI_Main.Close()
				} else {
					$UI_Main_Error_Icon.Image = [System.Drawing.Image]::Fromfile("$($PSScriptRoot)\..\..\..\..\Assets\icon\Error.ico")
					$UI_Main_Error.Text = $lang.UpdateServerNoSelect
				}
			}
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Auto_Select,
		$UI_Main_Menu,
		$IsAllowSHA256Check,
		$UI_Main_Silent,
		$UI_Main_Clean,
		$UI_Main_Reset,
		$UI_Main_Reset_Tips,
		$UI_Main_Error_Icon,
		$UI_Main_Error,
		$UI_Main_OK
	))

	ForEach ($item in (Get-Module -Name Engine).PrivateData.PSData.UpdateServer) {
		$CheckBox     = New-Object System.Windows.Forms.CheckBox -Property @{
			Height    = 35
			Width     = 485
			Text      = $item
			Tag       = $item
			Checked   = $true
			add_Click = {
				$UI_Main_Error.Text = ""
				$UI_Main_Error_Icon.Image = $null
			}
		}
		$UI_Main_Menu.controls.AddRange($CheckBox)
	}

	<#
		.Add right-click menu: select all, clear button
		.添加右键菜单：全选、清除按钮
	#>
	$UI_Main_Menu_Select = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_Menu_Select.Items.Add($lang.AllSel).add_Click({
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_Menu_Select.Items.Add($lang.AllClear).add_Click({
		$UI_Main_Error.Text = ""
		$UI_Main_Error_Icon.Image = $null

		$UI_Main_Menu.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_Menu.ContextMenuStrip = $UI_Main_Menu_Select

	$UI_Main.ShowDialog() | Out-Null
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

	write-host "  $($lang.UpdateCheckServerStatus -f $Script:ServerList.Count)"
	write-host "  $('-' * 80)"

	$NewFileSha256 = ""

	ForEach ($item in $Script:ServerList) {
		write-host "  * $($lang.UpdateServerAddress): " -NoNewline -ForegroundColor Yellow
		Write-Host $item -ForegroundColor Green

		if (Test_URI $item) {
			$PreServerVersion = $item
			$ServerTest = $true
			Write-Host "  $($lang.UpdateAvailable)" -ForegroundColor Green
			break
		} else {
			write-host "    $($lang.UpdateUnavailable)`n" -ForegroundColor Red
		}
	}

	if ($ServerTest) {
		write-host "  $('-' * 80)"
		write-host "    $($lang.UpdatePriority)" -ForegroundColor Green
	} else {
		write-host "    $($lang.UpdateServerTestFailed)" -ForegroundColor Red
		write-host "  $('-' * 80)"
		return
	}

	write-host "`n  $($lang.UpdateQueryingUpdate)"

	$error.Clear()
	$time = Measure-Command { Invoke-WebRequest -Uri $PreServerVersion -UseBasicParsing -TimeoutSec 15 -ErrorAction SilentlyContinue}

	if ($error.Count -eq 0) {
		write-host "`n  $($lang.UpdateQueryingTime -f $time.TotalMilliseconds)"
	} else {
		write-host "`n  $($lang.UpdateConnectFailed)"
		return
	}

	$getSerVer = (Invoke-RestMethod -Uri $PreServerVersion -UseBasicParsing -Body $body -Method:Get -Headers $head -ContentType "application/json" -TimeoutSec 15 -ErrorAction:stop)
	$chkRemovever = $($getSerVer.version.minau).Replace('.', '')
	$url = $getSerVer.url

	If ([String]::IsNullOrEmpty($chkRemovever)) {
		$IsCorrectAuVer = $false
	} else {
		if ($((Get-Module -Name Engine).PrivateData.PSData.MinimumVersion).Replace('.', '') -ge $chkRemovever) {
			$IsCorrectAuVer = $true
		} else {
			$IsCorrectAuVer = $false
		}
	}

	if ($IsCorrectAuVer) {
		Write-Host "`n  $($lang.IsAllowSHA256Check)" -ForegroundColor Yellow
		write-host "  $('-' * 80)"
		if ($IsAllowSHA256Check.Checked) {
			$SHAReCount = 0
			$SHAMaxRetries = 3
			$SHASuccess = $false
			$getSerVerSHA = $null

			Write-host "  SHA-256: " -NoNewline -ForegroundColor Yellow
			for ($i = 0; $i -le $SHAMaxRetries; $i++) {
				try {
					$getSerVerSHA = (Invoke-RestMethod -Uri "$($url).sha256" -UseBasicParsing -Body $body -Method:Get -Headers $head -ContentType "application/json" -TimeoutSec 15 -ErrorAction:stop)

					if ($null -ne $getSerVerSHA) {
						$SHASuccess = $true
						$NewFileSha256 = $getSerVerSHA.Substring(0, 64)
						write-host $NewFileSha256 -ForegroundColor Green
						break
					}
				} catch {
					$SHAReCount++
					if ($SHAReCount -gt 0) {
						write-host $lang.Failed -ForegroundColor Red

						Write-Host "`n  $($lang.UpdateREConnect -f $SHAReCount, $SHAMaxRetries)" -ForegroundColor Red
						Write-host "  SHA-256: " -NoNewline -ForegroundColor Yellow
						Start-Sleep -Seconds 10
					}
				}
			}

			if (-not $SHASuccess) {
				Write-Host $lang.Failed -ForegroundColor Red
			}
		} else {
			Write-host "  $($lang.Inoperable)" -ForegroundColor Red
		}

		write-host "`n  $($lang.UpdateMinimumVersion -f $((Get-Module -Name Engine).PrivateData.PSData.MinimumVersion))"
		$IsUpdateAvailable = $false

		if ($getSerVer.version.version.Replace('.', '') -gt (Get-Module -Name Engine).Version.ToString().Replace('.', '')) {
			$IsUpdateAvailable = $true
		} else {
			$IsUpdateAvailable = $false
		}

		if ($IsUpdateAvailable) {
			write-host "`n  $($lang.UpdateVerifyAvailable)" -ForegroundColor Yellow
			write-host "  $('-' * 80)"
			write-host "  * $($lang.UpdateDownloadAddress): " -NoNewline -ForegroundColor Yellow
			Write-Host $url -ForegroundColor Green

			if (Test_URI $url) {
				Write-Host "  $($lang.UpdateAvailable)" -ForegroundColor Green
				write-host "  $('-' * 80)"

				write-host "`n  $($lang.UpdateCurrent): $((Get-Module -Name Engine).Version.ToString())
  $($lang.UpdateLatest): $($getSerVer.version.version)
  
  $($getSerVer.changelog.title)
  $('-' * ($getSerVer.changelog.title).Length)
$($getSerVer.changelog.log)`n"
	
				write-host "  $($lang.UpdateNewLatest)`n" -ForegroundColor Green

				$FlagsCheckForceUpdate = $False
				if ($Force) {
					$FlagsCheckForceUpdate = $True
				}

				if ($UI_Main_Silent.Checked) {
					$FlagsCheckForceUpdate = $True
				}
	
				if ($UI_Main_Reset.Checked) {
					$FlagsCheckForceUpdate = $True
				}
	
				If ($FlagsCheckForceUpdate) {
					Update_And_Download -url $url -NewSHA $NewFileSha256
				} else {
					$title = $lang.UpdateInstall
					$message = $lang.UpdateInstallSel
					$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Yes"
					$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "No"
					$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
					$prompt=$host.ui.PromptForChoice($title, $message, $options, 0)
					Switch ($prompt)
					{
						0 {
							Update_And_Download -url $url -NewSHA $NewFileSha256
						}
						1 {
							write-host "`n  $($lang.UserCancel)"
						}
					}
				}
			} else {
				write-host "    $($lang.UpdateUnavailable)" -ForegroundColor Red
				write-host "  $('-' * 80)"
				return
			}
		} else {
			if ($UI_Main_Reset.Checked) {
				write-host "`n  $($lang.UpdateVerifyAvailable)" -ForegroundColor Yellow
				write-host "  $('-' * 80)"
				write-host "  * $($lang.UpdateDownloadAddress): " -NoNewline -ForegroundColor Yellow
				Write-Host $url -ForegroundColor Green

				if (Test_URI $url) {
					Write-Host "  $($lang.UpdateAvailable)" -ForegroundColor Green
					write-host "  $('-' * 80)"
					Update_And_Download -url $url -NewSHA $NewFileSha256
				} else {
					write-host "    $($lang.UpdateUnavailable)" -ForegroundColor Red
					write-host "  $('-' * 80)"
					return
				}
			} else {
				write-host "  $($lang.Auto_Update_IsLatest)"
			}
		}
	} else {
		write-host "  $($lang.UpdateNotSatisfied -f $((Get-Module -Name Engine).PrivateData.PSData.MinimumVersion))"
	}
}

Function Update_And_Download
{
	param
	(
		$url,
		$NewSHA
	)

	$output = "$($PSScriptRoot)\..\..\..\..\..\latest.zip"

	$start_time = Get-Date
	remove-item -path $output -force -ErrorAction SilentlyContinue

	$DownloadReCount = 0
	$maxRetries = 3
	$success = $false

	for ($i = 0; $i -le $maxRetries; $i++) {
		try {
			$time = Measure-Command { 
				Invoke-WebRequest -Uri $url -OutFile $output -TimeoutSec 15 -DisableKeepAlive -ErrorAction SilentlyContinue
			}
	
			Write-Host "`n  $($lang.UpdateTimeUsed): $((Get-Date).Subtract($start_time).Seconds) (s)`n"
			$success = $true
			break
		} catch {
			$DownloadReCount++
			if ($DownloadReCount -lt $maxRetries) {
				Write-Host "`n  $($lang.UpdateREConnect -f $DownloadReCount, $maxRetries)" -ForegroundColor Red
				Start-Sleep -Seconds 10
			}
		}
	}

	if (-not $success) {
		Write-Host "`n  $($lang.UpdateConnectFailed)" -ForegroundColor Red
		return
	}

	Write-Host "`n  $($lang.IsAllowSHA256Check)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"
	if ([string]::IsNullOrEmpty($NewSHA)) {
		write-host "  $($lang.GetSHAFailed)" -ForegroundColor Red
	} else {
		$localFileHash = (Get-FileHash $output -Algorithm SHA256).Hash
		Write-host "  $($localFileHash)" -ForegroundColor Green
		Write-host "  $($NewSHA) ^ = " -NoNewline -ForegroundColor Yellow

		if ($localFileHash -eq $NewSHA) {
			write-host "$($lang.Verify_Done)" -ForegroundColor Green
		} else {
			write-host "$($lang.Verify_Failed)" -ForegroundColor Red
			return
		}
	}
	write-host

	if (Test-Path -Path $output -PathType Leaf) {
		Archive -filename $output -to "$($PSScriptRoot)\..\..\..\..\.."

		$SaveOldVersionShort = (Get-Module -Name Engine).Version.ToString().Replace('.', '')
		$SaveOldVersion = (Get-Module -Name Engine).Version.ToString()

		Modules_Refresh -Function "Unzip_Done_Refresh_Process"
		remove-item -path $output -force -ErrorAction SilentlyContinue

		$SaveNewVersion = (Get-Module -Name Engine).Version.ToString().Replace('.', '')

		write-host "`n  $($lang.UpdateClean)" -ForegroundColor Yellow
		if ($UI_Main_Clean.Checked) {
			if ($SaveOldVersionShort -eq $SaveNewVersion) {
				write-host "  $($lang.UpdateNotExecuted)"
			} else {
				write-host "  $($lang.AddTo)".PadRight(22) -NoNewline -ForegroundColor Green
				Save_Dynamic -regkey "Multilingual\Update" -name "IsUpdate_Clean" -value $SaveOldVersion
				Write-host $lang.Done
			}
		} else {
			write-host "  $($lang.Inoperable)"
		}
	} else {
		write-host "`n  $($lang.UpdateUpdateStop)"
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
				$test.BaseResponse | Select-Object ResponseURI, ContentLength, ContentType, LastModified, @{
					Name = "Status";
					Expression = {
						$Test.StatusCode
					}
				}
			} else {
				if ($test.statuscode -ne 200) {
					$False
				} else {
					$True
				}
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
			} else {
				$False
			}
		}
	}
}

<#
	.Execute Function processing, after decompression is complete
	.执行 函数处理，解压完成后
#>
Function Unzip_Done_Refresh_Process
{
	$to = "$($PSScriptRoot)\..\..\.."
	if (Test-Path -Path $to -PathType Container) {
		$to = Convert-Path -Path $to -ErrorAction SilentlyContinue
	}

	$PPocess  = "$($to)\Post.Processing.bat"
	$PsPocess = "$($to)\Post.Processing.ps1"

	<#
		.Execute function processing, after the update is complete
		.执行 函数处理，更新完成后
	#>
	Update_Done_Refresh_Process

	write-host "`n  * $($lang.UpdatePostProc)"
	if ($Script:IsProcess) {
		write-host "  $($lang.UpdateNotExecuted)" -ForegroundColor red
	} else {
		write-host "`n  $($PPocess)"
		if (Test-Path -Path $PPocess -PathType Leaf) {
			Start-Process -FilePath $PPocess -wait -WindowStyle Minimized
			remove-item -path $PPocess -force
			write-host "  $($lang.Done)" -ForegroundColor Green
		} else {
			write-host "  $($lang.UpdateNoPost)" -ForegroundColor red
		}

		write-host "`n  $($PsPocess)"
		if (Test-Path -Path $PsPocess -PathType Leaf) {
			Start-Process powershell -ArgumentList "-file $($PsPocess)" -Wait -WindowStyle Minimized
			remove-item -path $PsPocess -force
			write-host "  $($lang.Done)" -ForegroundColor Green
		} else {
			write-host "  $($lang.UpdateNoPost)" -ForegroundColor red
		}

		write-host "`n  $($Global:Author)'s Solutions $($lang.UpdateDone)`n"
	}
}

<#
	.Execute function processing, after the update is complete
	.执行 函数处理，更新完成后
#>
Function Update_Done_Refresh_Process
{
	write-host "`n  $($lang.UpdateDoneRefresh)"
	<#
		.Add code from here
		.从此处添加代码
	#>

	write-host "  $($lang.Done)`n" -ForegroundColor Green
}