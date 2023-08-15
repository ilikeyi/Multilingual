<#
	.Requirements
	.先决条件
#>
Function Requirements
{
	Clear-Host
	$Host.UI.RawUI.WindowTitle = "$((Get-Module -Name Engine).Author)'s Solutions | Prerequisites"
	Write-Host "`n   Prerequisites" -ForegroundColor Yellow
	Write-host "   $('-' * 80)"

	Write-Host -NoNewline "   Checking PS version 5.1 and above".PadRight(75)
	if ($PSVersionTable.PSVersion.major -ge "5") {
		Write-Host -ForegroundColor Green "OK".PadLeft(8)
	} else {
		Write-Host -ForegroundColor Red " Failed".PadLeft(8)
	}

	Write-Host -NoNewline "   Checking Windows version > 10.0.16299.0".PadRight(75)
	$OSVer = [System.Environment]::OSVersion.Version;
	if (($OSVer.Major -eq 10 -and $OSVer.Minor -eq 0 -and $OSVer.Build -ge 16299)) {
		Write-Host -ForegroundColor Green "OK".PadLeft(8)
	} else {
		Write-Host -ForegroundColor Red "Failed".PadLeft(8)
	}

	Write-Host -NoNewline "   Checking Must be elevated to higher authority".PadRight(75)
	if (([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544") {
		Write-Host -ForegroundColor Green "OK".PadLeft(8)
	} else {
		Write-Host -ForegroundColor Red "Failed".PadLeft(8)
		Write-Host "`n   It will automatically exit after 6 seconds." -ForegroundColor Red
		start-process "timeout.exe" -argumentlist "/t 6 /nobreak" -wait -nonewwindow
		Modules_Import
		Stop-Process $PID
		exit
	}

	Write-Host "`n   Congratulations, passing the prerequisites.`n   About to go to the next step." -ForegroundColor Green
	Start-Sleep -s 2
}