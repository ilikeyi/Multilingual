<#
	.Package: Search for packages, run the main boot Deploy.ps1, and deploy custom content
	.包：搜索包，运行主引导 Deploy.ps1，可部署自定义内容
#>
Function DeployTaskPackage
{
	$DesktopOldpath = [Environment]::GetFolderPath("Desktop")
	if (Test-Path -Path "$($DesktopOldpath)\Package\Deploy.ps1" -PathType leaf) {
		Start-Process powershell -ArgumentList "-file $($DesktopOldpath)\Package\Deploy.ps1" -Wait -WindowStyle Minimized
		return
	}

	if (Test-Path -Path "$($env:SystemDrive)\Package\Deploy.ps1" -PathType leaf) {
		Start-Process powershell -ArgumentList "-file $($env:SystemDrive)\Package\Deploy.ps1" -Wait -WindowStyle Minimized
		return
	}

	if (Test-Path -Path "$($env:SystemDrive)\Users\Public\Desktop\Package\Deploy.ps1" -PathType leaf) {
		Start-Process powershell -ArgumentList "-file $($env:SystemDrive)\Users\Public\Desktop\Package\Deploy.ps1" -Wait -WindowStyle Minimized
		return
	}

	if (Test-Path -Path "$($PSScriptRoot)\..\..\..\Package\Deploy.ps1" -PathType leaf) {
		Start-Process powershell -ArgumentList "-file $($PSScriptRoot)\..\..\..\Package\Deploy.ps1" -Wait -WindowStyle Minimized
		return
	}

	if (Test-Path -Path "$($PSScriptRoot)\..\..\..\00\Package\Deploy.ps1" -PathType leaf) {
		Start-Process powershell -ArgumentList "-file $($PSScriptRoot)\..\..\..\00\Package\Deploy.ps1" -Wait -WindowStyle Minimized
		return
	}
}

<#
	.Get the Office installation guide Install.Office.ps1
	.获取 Office 安装引导 Install.Office.ps1
#>
Function DeployTaskOffice
{
	$DesktopOldpath = [Environment]::GetFolderPath("Desktop")
	if (Test-Path -Path "$($DesktopOldpath)\Office\Install.Office.ps1" -PathType leaf) {
		Start-Process powershell -ArgumentList "-file $($DesktopOldpath)\Office\Install.Office.ps1" -Wait -WindowStyle Minimized
		return
	}

	if (Test-Path -Path "$($env:SystemDrive)\Package\Office\Install.Office.ps1" -PathType leaf) {
		Start-Process powershell -ArgumentList "-file $($env:SystemDrive)\Package\Office\Install.Office.ps1" -Wait -WindowStyle Minimized
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

Export-ModuleMember -Function * -Alias *