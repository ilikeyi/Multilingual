<#
	.Deployment guide
	.部署引导
#>
Function Deploy_Guide
{
	<#
		.Search boot file rules
		.搜索引导文件规则
	#>
	$DeploySearchGuide = @(
		"Package\Deploy.ps1"
		"Office\Install.Office.ps1"
	)

	$SearchDiskPath = @(
		[Environment]::GetFolderPath("Desktop")
		$env:SystemDrive
		Join-Path -Path $env:SystemDrive -ChildPath "Users\Public\Desktop"
	)

	ForEach ($item in $DeploySearchGuide) {
		ForEach ($itemn in $SearchDiskPath) {
			$NewFilePathFull = Join-Path -Path $itemn -ChildPath $item

			if (Test-Path -Path $NewFilePathFull -PathType leaf) {
				write-host "  $($lang.DeployTask): " -ForegroundColor Yellow
				Write-Host $NewFilePathFull -ForegroundColor Green

				if ($Global:MarkRebootComputer) {
					Start-Process powershell -ArgumentList "-file $($NewFilePathFull)" -Wait -WindowStyle Minimized
				} else {
					Start-Process powershell -ArgumentList "-file $($NewFilePathFull)" -WindowStyle Minimized
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
			$TestDeployMarkNotAllowed = Join-Path -Path $item -ChildPath "$($Global:Author)\Deploy\Not Allowed\$($Mark)"
			$TestDeployMarkAllow = Join-Path -Path $item -ChildPath "$($Global:Author)\Deploy\Allow\$($Mark)"

			if (Test-Path -Path $TestDeployMarkNotAllowed -PathType Leaf) {
				Write-Host	"   $($lang.DiskSearchFind): " -NoNewline
				Write-host $TestDeployMarkNotAllowed -ForegroundColor Green
				return $False
			}

			if (Test-Path -Path $TestDeployMarkAllow -PathType Leaf) {
				Write-Host	"   $($lang.DiskSearchFind): " -NoNewline
				Write-host $TestDeployMarkAllow -ForegroundColor Green
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