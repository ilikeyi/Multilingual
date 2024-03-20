<#
	.Prerequisite
	.先决条件
#>
Function Prerequisite
{
	Clear-Host
	$Host.UI.RawUI.WindowTitle = "$((Get-Module -Name Engine).Author)'s Solutions | Prerequisites"
	Write-Host "`n   Prerequisites" -ForegroundColor Yellow
	Write-host "   $('-' * 80)"

	Write-Host -NoNewline "   Checking PS version 5.1 and above".PadRight(75)
	if ($PSVersionTable.PSVersion.major -ge "5") {
		Write-Host "OK".PadLeft(8) -ForegroundColor Green
	} else {
		Write-Host " Failed".PadLeft(8) -ForegroundColor Red
	}

	Write-Host -NoNewline "   Checking Windows version > 10.0.16299.0".PadRight(75)
	$OSVer = [System.Environment]::OSVersion.Version;
	if (($OSVer.Major -eq 10 -and $OSVer.Minor -eq 0 -and $OSVer.Build -ge 16299)) {
		Write-Host "OK".PadLeft(8) -ForegroundColor Green
	} else {
		Write-Host "Failed".PadLeft(8) -ForegroundColor Red
	}

	Write-Host -NoNewline "   Checking Must be elevated to higher authority".PadRight(75)
	if (([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544") {
		Write-Host "OK".PadLeft(8) -ForegroundColor Green

		Write-Host -NoNewline "   Check execution strategy".PadRight(75)
		switch (Get-ExecutionPolicy) {
			"Bypass" {
				Write-Host "Pass".PadLeft(8) -ForegroundColor Green
			}
			"RemoteSigned" {
				Write-Host "Pass".PadLeft(8) -ForegroundColor Green
			}
			"Unrestricted" {
				Write-Host "Pass".PadLeft(8) -ForegroundColor Green
			}
			default {
				Write-Host "Did not pass".PadLeft(8) -ForegroundColor Red
	
				Write-host "`n   How to solve: " -ForegroundColor Yellow
				Write-host "   $('-' * 80)"	
				Write-host "     1. Open ""Terminal"" or ""PowerShell ISE"" as an administrator, "
				Write-host "        set PowerShell execution policy: Bypass, PS command line: `n"
				Write-host "        Set-ExecutionPolicy -ExecutionPolicy Bypass -Force" -ForegroundColor Green
				Write-host "`n     2. Once resolved, rerun the command`n"
				return
			}
		}
	} else {
		Write-Host "Failed".PadLeft(8) -ForegroundColor Red

		Write-host "`n   How to solve: " -ForegroundColor Yellow
		Write-host "   $('-' * 80)"	
		Write-host "     1. Open ""Terminal"" or ""PowerShell ISE"" as an administrator."
		Write-host "`n     2. Once resolved, rerun the command`n"
		return
	}

	Write-Host "`n   Congratulations, it has passed." -ForegroundColor Green
	Start-Sleep -s 2
}