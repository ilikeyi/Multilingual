<#
	.Verify the directory and create
	.验证目录并创建
#>
Function CheckCatalog
{
	Param
	(
		[string]$chkpath
	)

	if (-not (Test-Path $chkpath -PathType Container)) {
		New-Item -Path $chkpath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
		if (-not (Test-Path $chkpath -PathType Container))
		{
			Write-Host "   - $($lang.FailedCreateFolder)$($chkpath)`n" -ForegroundColor Red
			return
		}
	}
}

<#
	.Delete directory
	.删除目录
#>
Function RemoveTree
{
	Param
	(
		[string]$Path
	)

	Remove-Item $Path -force -Recurse -ErrorAction silentlycontinue | Out-Null
	
	if (Test-Path "$Path\" -ErrorAction silentlycontinue) {
		Get-ChildItem -Path $Path -File -Force -ErrorAction SilentlyContinue | ForEach-Object {
			Remove-Item $_.FullName -force -ErrorAction SilentlyContinue
		}

		Get-ChildItem -Path $Path -Directory -ErrorAction SilentlyContinue | ForEach-Object {
			RemoveTree -Path $_.FullName
		}

		if (Test-Path "$Path\" -ErrorAction silentlycontinue) {
			Remove-Item $Path -force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.验证路径是否后缀带有 \
	.Verify that the path is suffixed with \
#>
Function JoinMainFolder
{
	param
	(
		[string]$Path
	)
	if ($Path.EndsWith('\'))
	{
		return "$Path"
	} else {
		return "$Path\"
	}
}

Export-ModuleMember -Function CheckCatalog, RemoveTree, JoinMainFolder