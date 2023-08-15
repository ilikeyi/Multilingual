<#
	.Dynamic save function
	.动态保存功能
#>
Function Save_Dynamic
{
	param
	(
		$regkey,
		$name,
		$value,
		[switch]$Multi,
		[switch]$String
	)

	$Path = "HKCU:\SOFTWARE\$((Get-Module -Name Engine).Author)\$($regkey)"

	if (-not (Test-Path $Path)) {
		New-Item -Path $Path -Force -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Multi) {
		New-ItemProperty -LiteralPath $Path -Name $name -Value $value -PropertyType MultiString -Force -ea SilentlyContinue | Out-Null
	}
	if ($String) {
		New-ItemProperty -LiteralPath $Path -Name $name -Value $value -PropertyType String -Force -ea SilentlyContinue | Out-Null
	}
}

<#
	.Test whether the disk is readable and writable
	.测试磁盘是否可读写
#>
Function Test_Available_Disk
{
	param
	(
		[string]$Path
	)

	try {
		New-Item -Path $Path -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

		$RandomGuid = [guid]::NewGuid()
		$test_tmp_filename = "writetest-$($RandomGuid)"
		$test_filename = Join-Path -Path "$($Path)" -ChildPath "$($test_tmp_filename)" -ErrorAction SilentlyContinue

		[io.file]::OpenWrite($test_filename).close()

		if (Test-Path $test_filename -PathType Leaf)
		{
			Remove-Item $test_filename -ErrorAction SilentlyContinue
			return $true
		}
		$false
	} catch {
		return $false
	}
}

<#
	.Verify the directory and create
	.验证目录并创建
#>
Function Check_Folder
{
	Param
	(
		[string]$chkpath
	)

	if (-not (Test-Path $chkpath -PathType Container)) {
		New-Item -Path $chkpath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
		if (-not (Test-Path $chkpath -PathType Container))
		{
			Write-Host "   $($lang.FailedCreateFolder)"
			Write-Host "   $($chkpath)" -ForegroundColor Red
			return
		}
	}
}

<#
	.Delete directory
	.删除目录
#>
Function Remove_Tree
{
	Param
	(
		[string]$Path
	)

	Remove-Item $Path -force -Recurse -ErrorAction silentlycontinue | Out-Null
	
	if (Test-Path -Path "$Path\" -ErrorAction silentlycontinue) {
		Get-ChildItem -Path $Path -File -Force -ErrorAction SilentlyContinue | ForEach-Object {
			Remove-Item $_.FullName -force -ErrorAction SilentlyContinue
		}

		Get-ChildItem -Path $Path -Directory -ErrorAction SilentlyContinue | ForEach-Object {
			Remove_Tree -Path $_.FullName
		}

		if (Test-Path -Path "$Path\" -ErrorAction silentlycontinue) {
			Remove-Item $Path -force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.验证路径是否后缀带有 \
	.Verify that the path is suffixed with \
#>
Function Join_MainFolder
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

<#
	.Unzip
	.解压缩
#>
Function Archive
{
	param
	(
		$Password,
		$filename,
		$to
	)

	$filename = Convert-Path $filename -ErrorAction SilentlyContinue
	$to = Convert-Path $to -ErrorAction SilentlyContinue

	Write-Host "   $($filename)"
	Write-host "   $($to)"
	Write-Host "   $($lang.UpdateUnpacking)".PadRight(28) -NoNewline
	if (Compressing) {
		if (([string]::IsNullOrEmpty($Password))) {
			$arguments = "x ""-r"" ""-tzip"" ""$filename"" ""-o$to"" ""-y"""
		} else {
			$arguments = "x ""-p$Password"" ""-r"" ""-tzip"" ""$filename"" ""-o$to"" ""-y"""
		}
		Start-Process $Global:Zip "$arguments" -Wait -WindowStyle Minimized
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	} else {
		Expand-Archive -LiteralPath $filename -DestinationPath $to -force
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}

<#
	.Get compression software
	.获取压缩软件
#>
Function Compressing
{
	if (Test-Path -Path "${env:ProgramFiles}\7-Zip\7z.exe" -PathType Leaf) {
		$Global:Zip = "${env:ProgramFiles}\7-Zip\7z.exe"
		return $true
	}

	if (Test-Path -Path "${env:ProgramFiles(x86)}\7-Zip\7z.exe" -PathType Leaf) {
		$Global:Zip = "${env:ProgramFiles(x86)}\7-Zip\7z.exe"
		return $true
	}

	if (Test-Path -Path "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\7zPacker")\7z.exe" -PathType Leaf) {
		$Global:Zip = "$(Get_Arch_Path -Path "$($PSScriptRoot)\..\..\..\..\AIO\7zPacker")\7z.exe"
		return $true
	}
	return $false
}

<#
	.Processing: clean up packages by architecture
	.处理：按架构清理软件包
#>
Function Clear_Arch_Path
{
	param
	(
		[string]$Path
	)

	switch ($env:PROCESSOR_ARCHITECTURE) {
		"arm64" {
			if (Test-Path -Path "$Path\arm64" -PathType Container) {
				Remove_Tree -Path "$Path\AMD64"
				Remove_Tree -Path "$Path\x86"
			} else {
				if (Test-Path -Path "$Path\AMD64" -PathType Container) {
					Remove_Tree -Path "$Path\arm64"
					Remove_Tree -Path "$Path\x86"
				} else {
					if (Test-Path -Path "$Path\x86" -PathType Container) {
						Remove_Tree -Path "$Path\arm64"
						Remove_Tree -Path "$Path\AMD64"
					}
				}
			}
		}
		"AMD64" {
			if (Test-Path -Path "$Path\AMD64" -PathType Container) {
				Remove_Tree -Path "$Path\arm64"
				Remove_Tree -Path "$Path\x86"
			} else {
				if (Test-Path -Path "$Path\x86" -PathType Container) {
					Remove_Tree -Path "$Path\arm64"
					Remove_Tree -Path "$Path\AMD64"
				}
			}
		}
		"x86" {
			Remove_Tree -Path "$Path\arm64"
			Remove_Tree -Path "$Path\AMD64"
		}
	}
}

<#
	.Determine if architecture is available by path
	.按路径来判断架构是否可用
#>
Function Get_Arch_Path
{
	param
	(
		[string]$Path
	)

	switch ($env:PROCESSOR_ARCHITECTURE) {
		"arm64" {
			if (Test-Path -Path "$($Path)\arm64\$($Global:IsLang)" -PathType Container) {
				return Convert-Path -Path "$($Path)\arm64\$($Global:IsLang)" -ErrorAction SilentlyContinue
			} else {
				if (Test-Path -Path "$($Path)\AMD64\$($Global:IsLang)" -PathType Container) {
					return Convert-Path -Path "$($Path)\AMD64\$($Global:IsLang)" -ErrorAction SilentlyContinue
				} else {
					if (Test-Path -Path "$($Path)\x86\$($Global:IsLang)" -PathType Container) {
						return Convert-Path -Path "$($Path)\x86\$($Global:IsLang)" -ErrorAction SilentlyContinue
					} else {
						return $Path
					}
				}
			}
		}
		"AMD64" {
			if (Test-Path -Path "$($Path)\AMD64\$($Global:IsLang)" -PathType Container) {
				return Convert-Path -Path "$($Path)\AMD64\$($Global:IsLang)" -ErrorAction SilentlyContinue
			} else {
				if (Test-Path -Path "$($Path)\x86\$($Global:IsLang)" -PathType Container) {
					return Convert-Path -Path "$($Path)\x86\$($Global:IsLang)" -ErrorAction SilentlyContinue
				} else {
					return $Path
				}
			}
		}
		"x86" {
			if (Test-Path -Path "$($Path)\x86\$($Global:IsLang)" -PathType Container) {
				return Convert-Path -Path "$($Path)\x86\$($Global:IsLang)" -ErrorAction SilentlyContinue
			} else {
				return $Path
			}
		}
	}
}