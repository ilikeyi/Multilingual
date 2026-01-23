<#
	.Prerequisite
	.先决条件
#>
Function Prerequisite
{
	Clear-Host
	$Host.UI.RawUI.WindowTitle = "$($Global:Author)'s Solutions | $($lang.Prerequisites)"
	write-host "`n  $($lang.Prerequisites)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	write-host "  $($lang.Check_PSVersion): " -NoNewline
	if ($PSVersionTable.PSVersion.major -ge "5") {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
	} else {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White

		write-host "`n  $($lang.How_solve): " -ForegroundColor Yellow
		write-host "  $('-' * 80)"
		write-host "    1. $($lang.UpdatePSVersion)`n"
		pause
		exit
	}

	write-host "  $($lang.Check_OSVersion): " -NoNewline
	$OSVer = [System.Environment]::OSVersion.Version;
	if (($OSVer.Major -eq 10 -and $OSVer.Minor -eq 0 -and $OSVer.Build -ge 16299)) {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
	} else {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White

		write-host "`n  $($lang.How_solve): " -ForegroundColor Yellow
		write-host "  $('-' * 80)"
		write-host "   $($lang.UpdateOSVersion)`n"
		pause
		exit
	}

	write-host "  $($lang.Check_Higher_elevated): " -NoNewline
	if (([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544") {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White

		write-host "  $($lang.Check_execution_strategy): " -NoNewline
		switch (Get-ExecutionPolicy) {
			"Bypass" {
				Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
			}
			"RemoteSigned" {
				Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
			}
			"Unrestricted" {
				Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
			}
			default {
				Write-Host " $($lang.Check_Did_not_pass) " -BackgroundColor DarkRed -ForegroundColor White
	
				write-host "`n  $($lang.How_solve): " -ForegroundColor Yellow
				write-host "  $('-' * 80)"
				write-host "   $($lang.HigherTermail)`n"
				pause
				exit
			}
		}
	} else {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White

		write-host "`n  $($lang.How_solve): " -ForegroundColor Yellow
		write-host "  $('-' * 80)"
		write-host "    $($lang.HigherTermailAdmin)`n"

		$arguments = @(
			"-ExecutionPolicy",
			"ByPass",
			"-File",
			"""$($MyInvocation.MyCommand.Path)"""
		)
		Start-Process "powershell" -ArgumentList $arguments -Verb RunAs

		pause
		exit
	}

	write-host "  $($lang.UpdateClean): " -NoNewline
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsUpdate_Clean" -ErrorAction SilentlyContinue) {
		$GetOldVersion = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsUpdate_Clean" -ErrorAction SilentlyContinue
		$SaveCurrentVersion = (Get-Module -Name Engine).Version.ToString()

		if ($GetOldVersion -eq $SaveCurrentVersion) {
			Write-Host " $($lang.UpdateNotExecuted) " -BackgroundColor DarkGreen -ForegroundColor White

			write-host "  " -NoNewline 
			write-host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Remove-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsUpdate_Clean" -Force -ErrorAction SilentlyContinue | out-null
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		} else {
			Write-Host " $($lang.Del) " -BackgroundColor DarkRed -ForegroundColor White

			$Wait_Clean_Folder_Full = Join-Path -Path "$($PSScriptRoot)\..\..\..\.." -ChildPath $GetOldVersion

			write-host "  " -NoNewline 
			write-host " $($lang.Del): $($GetOldVersion) " -NoNewline -BackgroundColor White -ForegroundColor Black
			remove-item -path $Wait_Clean_Folder_Full -Recurse -force -ErrorAction SilentlyContinue

			if (Test-Path -Path $Wait_Clean_Folder_Full -PathType Container) {
				Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White
			} else {
				Remove-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsUpdate_Clean" -Force -ErrorAction SilentlyContinue | out-null
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			}
		}
	} else {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
	}

	<#
		.允许自动更新
	#>
	Write-Host "`n  $($lang.Auto_Update_Allow)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsAutoUpdate" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsAutoUpdate" -ErrorAction SilentlyContinue) {
			"True"  {
				$SIPPS = Join-path -Path $PSScriptRoot -ChildPath "..\..\..\..\..\Engine.ps1"
				$arguments = @(
					"-ExecutionPolicy",
					"ByPass",
					"-File",
					"""$($SIPPS)""",
					"-Functions",
					"Auto_Update"
				)

				<#
					.允许自动更新新版本
				#>
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "IsAutoUpdateNew" -ErrorAction SilentlyContinue) {
				} else {
					Save_Dynamic -regkey "Multilingual\Update" -name "IsAutoUpdateNew" -value "True"
				}

				<#
					.自动检查更新间隔小时
				#>
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "AutoCheckUpdate_Hours" -ErrorAction SilentlyContinue) {
					$WaitHoursTime = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "AutoCheckUpdate_Hours" -ErrorAction SilentlyContinue
				} else {
					$WaitHoursTime = "2"
					Save_Dynamic -regkey "Multilingual\Update" -name "AutoCheckUpdate_Hours" -value "2"
				}
				$WaitSecoundsTime = [int]$WaitHoursTime * 3600

				<#
					.判断是否有上次执行时间
				#>
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "Last_Auto_Update_Time" -ErrorAction SilentlyContinue) {
					$GetLastAutoUpdateTime = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "Last_Auto_Update_Time" -ErrorAction SilentlyContinue
					$restoredDate = New-Object DateTime($GetLastAutoUpdateTime)

					Write-Host "  $($lang.Auto_Last_Check_Time): " -NoNewline
					Write-Host "$($restoredDate.ToString("yyyy/MM/dd hh:mm:ss tt"))" -ForegroundColor Yellow
					$currentTime = (Get-Date)
					$timeDiff = New-TimeSpan -Start $restoredDate -End $currentTime
#					Write-Host "  Time: $($timeDiff.TotalSeconds) Seconds"

					if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "Auto_Update_Last_status" -ErrorAction SilentlyContinue) {
						$GetAuto_Update_Last_status = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual\Update" -Name "Auto_Update_Last_status" -ErrorAction SilentlyContinue
					} else {
						$GetAuto_Update_Last_status = $lang.ImageCodenameNo
					}
					Write-Host "  $($lang.Auto_Update_Last_status): " -NoNewline
					Write-Host $GetAuto_Update_Last_status -ForegroundColor Green

					if ($timeDiff.TotalSeconds -ge $WaitSecoundsTime) {
						write-host "  $($lang.Auto_Update_Allow)" -ForegroundColor Green
						Start-Process "powershell" -ArgumentList $arguments -Verb RunAs -WindowStyle Hidden -ErrorAction SilentlyContinue
					} else {
						$nextRunTime = $restoredDate.AddSeconds($WaitSecoundsTime)
						Write-host "  $($lang.Auto_Next_Check_Time -f $($WaitHoursTime)): " -NoNewline
						Write-Host "$($nextRunTime.ToString("yyyy/MM/dd hh:mm:ss tt"))" -ForegroundColor Yellow
					}
				} else {
					write-host "  $($lang.Auto_First_Check)" -ForegroundColor Green
					Start-Process "powershell" -ArgumentList $arguments -Verb RunAs -WindowStyle Hidden -ErrorAction SilentlyContinue
				}
			}
			"False" {
				Write-host "  $($lang.Disable)" -ForegroundColor Red
			}
		}
	} else {
		Write-host "  $($lang.Check_Did_not_pass)" -ForegroundColor Red
		Save_Dynamic -regkey "Multilingual\Update" -name "IsAutoUpdate" -value "True"
	}

	write-host "`n  $($lang.Check_Pass_Done)" -ForegroundColor Green
	Start-Sleep -s 2
}