<#
	.Automatically check for updates
	.自动检查更新
#>
Function Auto_Update
{
	$ticks = (Get-Date).Ticks
	Save_Dynamic -regkey "Multilingual\Update" -name "Last_Auto_Update_Time" -value $ticks -Type "QWord"

	$Script:ServerList = @()

	ForEach ($item in (Get-Module -Name Engine).PrivateData.PSData.UpdateServer | Sort-Object { Get-Random } ) {
		$Script:ServerList += $item
	}

	if ($Script:ServerList.Count -gt 0) {
		Auto_Update_Process
	} else {
		write-host $lang.UpdateServerNoSelect -ForegroundColor Red
	}
}

<#
	.Update process
	.更新处理
#>
Function Auto_Update_Process
{
	<#
		.允许自动更新新版本
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsAutoUpdateNew" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsAutoUpdateNew" -ErrorAction SilentlyContinue) {
			"True"  { $Force = $True }
			"False" { $Force = $False }
		}
	} else {
		$Force = $False
	}

	<#
		.Disabled IE first-launch configuration
		.禁用 IE 首次启动配置
	#>
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -Value 2 -ErrorAction SilentlyContinue

	Write-Host "  $($lang.UpdateCheckServerStatus -f $Script:ServerList.Count)"
	Write-Host "  $('-' * 80)"

	$NewFileSha256 = ""

	ForEach ($item in $Script:ServerList) {
		Write-Host "  * $($lang.UpdateServerAddress): " -NoNewline -ForegroundColor Yellow
		Write-Host $item -ForegroundColor Green

		if (Test_URI $item) {
			$PreServerVersion = $item
			$ServerTest = $true
			Write-Host "    $($lang.UpdateAvailable)" -ForegroundColor Green
			break
		} else {
			Write-Host "    $($lang.UpdateUnavailable)`n" -ForegroundColor Red
		}
	}

	if ($ServerTest) {
		Write-Host "  $('-' * 80)"
		Write-Host "    $($lang.UpdatePriority)" -ForegroundColor Green
	} else {
		Save_Dynamic -regkey "Multilingual\Update" -name "Auto_Update_Last_status" -value $lang.UpdateServerTestFailed
		Write-Host "    $($lang.UpdateServerTestFailed)" -ForegroundColor Red
		Write-Host "  $('-' * 80)"
		return
	}

	Write-Host "`n  $($lang.UpdateQueryingUpdate)"

	$error.Clear()
	$time = Measure-Command { Invoke-WebRequest -Uri $PreServerVersion -UseBasicParsing -TimeoutSec 15 -ErrorAction SilentlyContinue}

	if ($error.Count -eq 0) {
		Write-Host "`n  $($lang.UpdateQueryingTime -f $time.TotalMilliseconds)"
	} else {
		Save_Dynamic -regkey "Multilingual\Update" -name "Auto_Update_Last_status" -value $lang.UpdateConnectFailed
		Write-Host "`n  $($lang.UpdateConnectFailed)"
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
		Write-Host "`n  $($lang.UpdateMinimumVersion -f $((Get-Module -Name Engine).PrivateData.PSData.MinimumVersion))"
		$IsUpdateAvailable = $false

		if ($getSerVer.version.version.Replace('.', '') -gt (Get-Module -Name Engine).Version.ToString().Replace('.', '')) {
			$IsUpdateAvailable = $true
		} else {
			$IsUpdateAvailable = $false
		}

		if ($IsUpdateAvailable) {
			Write-Host "`n  $($lang.IsAllowSHA256Check)" -ForegroundColor Yellow
			write-host "  $('-' * 80)"

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

			Write-Host "`n  $($lang.UpdateVerifyAvailable)" -ForegroundColor Yellow
			Write-Host "  $('-' * 80)"
			Write-Host "  * $($lang.UpdateDownloadAddress): " -NoNewline -ForegroundColor Yellow
			Write-Host $url -ForegroundColor Green

			if (Test_URI $url) {
				Write-Host "  $($lang.UpdateAvailable)" -ForegroundColor Green
				Write-Host "  $('-' * 80)"

				Write-Host "`n  $($lang.UpdateCurrent): $((Get-Module -Name Engine).Version.ToString())
  $($lang.UpdateLatest): $($getSerVer.version.version)

  $($getSerVer.changelog.title)
  $('-' * ($getSerVer.changelog.title).Length)
$($getSerVer.changelog.log)`n"

				Write-Host "  $($lang.UpdateNewLatest)`n" -ForegroundColor Green

				Save_Dynamic -regkey "Multilingual\Update" -name "Auto_Update_New_Version" -value $getSerVer.version.version
				If ($Force) {
					Auto_Update_And_Download -url $url -NewSHA $NewFileSha256
				} else {
					Save_Dynamic -regkey "Multilingual\Update" -name "Auto_Update_Last_status" -value $lang.UpdateNewLatest
					Write-Host "  $($lang.UpdateNewLatest)" -ForegroundColor Green
				}
			} else {
				Save_Dynamic -regkey "Multilingual\Update" -name "Auto_Update_Last_status" -value $lang.UpdateUnavailable
				Write-Host "    $($lang.UpdateUnavailable)" -ForegroundColor Red
				return
			}
		} else {
			Save_Dynamic -regkey "Multilingual\Update" -name "Auto_Update_Last_status" -value "$($lang.Auto_Update_IsLatest)"
			Write-Host "  $($lang.Auto_Update_IsLatest)"
		}
	} else {
		$NewErrorTips = $($lang.UpdateNotSatisfied -f $((Get-Module -Name Engine).PrivateData.PSData.MinimumVersion))
		Save_Dynamic -regkey "Multilingual\Update" -name "Auto_Update_Last_status" -value $NewErrorTips
		Write-Host "  $($NewErrorTips)"
	}
}

Function Auto_Update_And_Download
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
			Save_Dynamic -regkey "Multilingual\Update" -name "Auto_Update_Last_status" -value $lang.Verify_Failed
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

		<#
			.允许自动清理旧版本
		#>
		Write-Host "`n  $($lang.UpdateClean)" -ForegroundColor Yellow
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsUpdate_Clean_Allow" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsUpdate_Clean_Allow" -ErrorAction SilentlyContinue) {
				"True"  {
					if ($SaveOldVersionShort -eq $SaveNewVersion) {
						Write-Host "  $($lang.UpdateNotExecuted)"
					} else {
						Write-Host "  " -NoNewline
						Write-Host " $($lang.AddTo) " -NoNewline -BackgroundColor White -ForegroundColor Black
						Save_Dynamic -regkey "Multilingual\Update" -name "IsUpdate_Clean" -value $SaveOldVersion
						Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
					}
				}
				"False" {
					Write-Host "  $($lang.Disable)" -ForegroundColor Red
				}
			}
		} else {
			Write-Host "  $($lang.NoWork)" -ForegroundColor Red
		}

		Save_Dynamic -regkey "Multilingual\Update" -name "Auto_Update_Last_status" -value $lang.UpdateDone
	} else {
		Save_Dynamic -regkey "Multilingual\Update" -name "Auto_Update_Last_status" -value $lang.UpdateUpdateStop
		Write-Host "`n  $($lang.UpdateUpdateStop)"
	}
}