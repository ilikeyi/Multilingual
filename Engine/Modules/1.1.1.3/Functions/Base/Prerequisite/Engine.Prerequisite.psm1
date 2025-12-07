<#
	.Prerequisite
	.先决条件
#>
Function Prerequisite
{
	Clear-Host
	$Host.UI.RawUI.WindowTitle = "$((Get-Module -Name Engine).Author)'s Solutions | $($lang.Prerequisites)"
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
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Engine).Author)\Multilingual\Update" -Name "IsUpdate_Clean" -ErrorAction SilentlyContinue) {
		$GetOldVersion = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Engine).Author)\Multilingual\Update" -Name "IsUpdate_Clean" -ErrorAction SilentlyContinue
		$SaveCurrentVersion = (Get-Module -Name Engine).Version.ToString()

		if ($GetOldVersion -eq $SaveCurrentVersion) {
			Write-Host " $($lang.UpdateNotExecuted) " -BackgroundColor DarkGreen -ForegroundColor White

			write-host "  " -NoNewline 
			write-host " $($lang.Del) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Remove-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Engine).Author)\Multilingual\Update" -Name "IsUpdate_Clean" -Force -ErrorAction SilentlyContinue | out-null
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
				Remove-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Engine).Author)\Multilingual\Update" -Name "IsUpdate_Clean" -Force -ErrorAction SilentlyContinue | out-null
				Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
			}
		}
	} else {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
	}

	write-host "`n  $($lang.Check_Pass_Done)" -ForegroundColor Green
	Start-Sleep -s 2
}