<#
	.SYNOPSIS
	Install the boot module

	.DESCRIPTION
	Install the boot module, automatic framework recognition

	.Author
	Yi ( https://fengyi.tel )

	.Version
	v1.0
#>

<#
	.Get the Office installation guide Install.Office.ps1
	.获取 Office 安装引导 Install.Office.ps1
#>
Function GetSetup
{
	$DesktopOldpath = [Environment]::GetFolderPath("Desktop")
	if (Test-Path -Path "$($DesktopOldpath)\Office\Install.Office.ps1" -PathType leaf) {
		Start-Process powershell -ArgumentList "-file $($DesktopOldpath)\Office\Install.Office.ps1" -Wait -WindowStyle Minimized
		return
	}

	if (Test-Path -Path "$($env:SystemDrive)\Users\Public\Desktop\Office\Install.Office.ps1" -PathType leaf) {
		Start-Process powershell -ArgumentList "-file $($env:SystemDrive)\Users\Public\Desktop\Office\Install.Office.ps1" -Wait -WindowStyle Minimized
		return
	}

	if (Test-Path -Path "$($PSScriptRoot)\..\..\..\Office\Install.Office.ps1" -PathType leaf) {
		Start-Process powershell -ArgumentList "-file $($PSScriptRoot)\..\..\..\Office\Install.Office.ps1" -Wait -WindowStyle Minimized
		return
	}

	if (Test-Path -Path "$($PSScriptRoot)\..\..\..\00\Office\Install.Office.ps1" -PathType leaf) {
		Start-Process powershell -ArgumentList "-file $($PSScriptRoot)\..\..\..\00\Office\Install.Office.ps1" -Wait -WindowStyle Minimized
		return
	}
}

GetSetup