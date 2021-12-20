<#
 .Synopsis
  First Experience Deploy Rule

 .Description
  First Experience Deploy Rule Feature Modules

 .NOTES
  Author:  Yi
  Website: http://fengyi.tel
#>

<#
	.Search boot file rules
	.搜索引导文件规则
#>
$DeploySearchGuide = @(
	"Package\Deploy.ps1"
	"Office\Install.Office.ps1"
)

<#
	.Deployment guide
	.部署引导
#>
Function DeployGuide
{
	$SearchDiskPath = @(
		"$([Environment]::GetFolderPath("Desktop"))"
		"$($env:SystemDrive)"
		"$($env:SystemDrive)\Users\Public\Desktop"
		"$($PSScriptRoot)\..\..\.."
		"$($PSScriptRoot)\..\..\..\00"
	)

	foreach ($item in $DeploySearchGuide) {
		foreach ($itemn in $SearchDiskPath) {
			if (Test-Path -Path "$($itemn)\$($item)" -PathType leaf) {
				write-host "   $($lang.DeployTask)$($itemn)\$($item)"
				if ($Global:MarkRebootComputer) {
					Start-Process powershell -ArgumentList "-file $($itemn)\$($item)" -Wait -WindowStyle Minimized
				} else {
					Start-Process powershell -ArgumentList "-file $($itemn)\$($item)" -WindowStyle Minimized
				}
				break
			}
		}
	}
}

Export-ModuleMember -Function * -Alias *