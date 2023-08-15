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
Function Deploy_Guide
{
	$SearchDiskPath = @(
		"$([Environment]::GetFolderPath("Desktop"))"
		"$($env:SystemDrive)"
		"$($env:SystemDrive)\Users\Public\Desktop"
	)

	ForEach ($item in $DeploySearchGuide) {
		ForEach ($itemn in $SearchDiskPath) {
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

<#
	.Deployment tag
	.部署标记
#>
Function Deploy_Sync
{
	param
	(
		$Mark
	)

	<#
		.Search for deployment tags, order: 1. Determine whether to allow global search tags; 2. Search in the script directory;
		.搜索部署标记，顺序：1、判断是否允许全盘搜索标记；2、脚本目录下搜索；
	#>
	if (Test-Path -Path "$($PSScriptRoot)\..\..\..\..\..\Deploy\Allow\Is_Mark_Sync" -PathType Leaf) {
		$drives = Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | Where-Object { -not ((Join_MainFolder -Path $env:SystemDrive) -eq $_.Root) } | Select-Object -ExpandProperty 'Root'
		ForEach ($item in $drives) {
			$TestDeployMarkNotAllowed = "$($item)$((Get-Module -Name Engine).Author)\Deploy\Not Allowed\$($Mark)"
			$TestDeployMarkAllow = "$($item)$((Get-Module -Name Engine).Author)\Deploy\Allow\$($Mark)"

			if (Test-Path -Path $TestDeployMarkNotAllowed -PathType Leaf) {
				Write-host "   $($lang.DiskSearchFind -f $TestDeployMarkNotAllowed)"
				return $False
			}

			if (Test-Path -Path $TestDeployMarkAllow -PathType Leaf) {
				Write-host "   $($lang.DiskSearchFind -f $TestDeployMarkAllow)"
				return $True
			}
		}
	}
	
	if (Test-Path -Path "$($PSScriptRoot)\..\..\..\..\..\Deploy\Not Allowed\$($Mark)" -PathType Leaf) {
		return $False
	}

	if (Test-Path -Path "$($PSScriptRoot)\..\..\..\..\..\Deploy\Allow\$($Mark)" -PathType Leaf) {
		return $True
	}

	return $False
}