<#
	.Dynamic save function
	.动态保存功能
#>
Function Save_Dynamic
{
	param (
		[Parameter(Mandatory=$true)][string]$regkey,
		[Parameter(Mandatory=$true)][string]$name,
		[Parameter(Mandatory=$true)]$value,
		[ValidateSet("String", "MultiString", "Binary", "DWord", "QWord", "ExpandString")]
		[string]$Type = "String"
	)

	$Path = "HKCU:\SOFTWARE\$($Global:Author)\$($regkey)"

	if (-not (Test-Path $Path)) {
		New-Item -Path $Path -Force -ErrorAction SilentlyContinue | Out-Null
	}

	$PropertyType = switch ($Type) {
		"String"       { "String" }
		"MultiString"  { "MultiString" }
		"Binary"       { "Binary" }
		"DWord"        { "DWord" }
		"QWord"        { "QWord" }
		"ExpandString" { "ExpandString" }
		Default        { "String" }
	}

	New-ItemProperty -LiteralPath $Path -Name $name -Value $value -PropertyType $PropertyType -Force -ErrorAction SilentlyContinue | Out-Null
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

		$RandomGuid = New-Guid
		$test_tmp_filename = "writetest-$($RandomGuid)"
		$test_filename = Join-Path -Path $Path -ChildPath $test_tmp_filename -ErrorAction SilentlyContinue

		[io.file]::OpenWrite($test_filename).close()

		if (Test-Path $test_filename -PathType Leaf) {
			Remove-Item -Path $test_filename -ErrorAction SilentlyContinue
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

	if (Test-Path -Path $chkpath -PathType Container) {

	} else {
		New-Item -Path $chkpath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

		if (Test-Path -Path $chkpath -PathType Container) {

		} else {
			write-host "`n  $($lang.FailedCreateFolder)"
			write-host "  $($chkpath)" -ForegroundColor Red
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

	Remove-Item -Path $Path -force -Recurse -ErrorAction silentlycontinue -Confirm:$false | Out-Null

	if (Test-Path -Path "$($path)\" -ErrorAction silentlycontinue) {
		Get-ChildItem -Path $Path -File -Force -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
			Remove-Item -Path $_.FullName -force -ErrorAction SilentlyContinue -Confirm:$false | Out-Null
		}

		Get-ChildItem -Path $Path -Directory -ErrorAction SilentlyContinue | ForEach-Object {
			Remove_Tree -Path $_.FullName
		}

		if (Test-Path -Path "$($path)\" -ErrorAction silentlycontinue) {
			Remove-Item -Path $Path -force -Recurse -ErrorAction SilentlyContinue -Confirm:$false | Out-Null
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

	if ($Path.EndsWith('\')) {
		return $Path
	} else {
		return "$($Path)\"
	}
}

<#
	.Pause prompt
	.暂停提示
#>
Function Get_Next
{
	write-host "`n  $($lang.WorkDone)`n"
	pause
}

Function Get_Zip
{
	param
	(
		$Run
	)

	$Local_Zip_Path = @(
		"${env:ProgramFiles}\7-Zip\$($Run)"
		"${env:ProgramFiles(x86)}\7-Zip\$($Run)"
		"$(Get_Arch_Path -Path "$($PSScriptRoot)\AIO\7zPacker")\$($Run)"
	)

	ForEach ($item in $Local_Zip_Path) {
		if (Test-Path -Path $item -PathType leaf) {
			return $item
		}
	}

	return $False
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

	$filename = Convert-Path -Path $filename -ErrorAction SilentlyContinue

	if (Test-Path -Path $to -PathType Container) {
		$to = Convert-Path -Path $to -ErrorAction SilentlyContinue
	}

	write-host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
	Write-Host $filename -ForegroundColor Green

	write-host "  $($lang.SaveTo): " -NoNewline -ForegroundColor Yellow
	Write-Host $to -ForegroundColor Green

	write-host "  $($lang.UpdateUnpacking)".PadRight(28) -NoNewline

	$Verify_Install_Path = Get_Zip -Run "7z.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		if (([string]::IsNullOrEmpty($Password))) {
			$arguments = @(
				"x",
				"-r",
				"-tzip",
				"""$($filename)""",
				"-o""$($to)""",
				"-y";
			)

			Start-Process -FilePath $Verify_Install_Path -ArgumentList $Arguments -Wait -WindowStyle Minimized
		} else {
			$arguments = @(
				"x",
				"-p$($Password)"
				"-r",
				"-tzip",
				"""$($filename)""",
				"-o""$($to)""",
				"-y";
			)

			Start-Process -FilePath $Verify_Install_Path -ArgumentList $Arguments -Wait -WindowStyle Minimized
		}

		Write-Host $lang.Done -ForegroundColor Green
	} else {
		Add-Type -AssemblyName System.IO.Compression.FileSystem
		Expand-Archive -LiteralPath $filename -DestinationPath $to -force
		Write-Host $lang.Done -ForegroundColor Green
	}

	Write-Host
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
			if (Test-Path -Path "$($Path)\arm64" -PathType Container) {
				Remove_Tree -Path "$($Path)\AMD64"
				Remove_Tree -Path "$($Path)\x86"
			} else {
				if (Test-Path -Path "$($Path)\AMD64" -PathType Container) {
					Remove_Tree -Path "$($Path)\arm64"
					Remove_Tree -Path "$($Path)\x86"
				} else {
					if (Test-Path -Path "$($Path)\x86" -PathType Container) {
						Remove_Tree -Path "$($Path)\arm64"
						Remove_Tree -Path "$($Path)\AMD64"
					}
				}
			}
		}
		"AMD64" {
			if (Test-Path -Path "$($Path)\AMD64" -PathType Container) {
				Remove_Tree -Path "$($Path)\arm64"
				Remove_Tree -Path "$($Path)\x86"
			} else {
				if (Test-Path -Path "$($Path)\x86" -PathType Container) {
					Remove_Tree -Path "$($Path)\arm64"
					Remove_Tree -Path "$($Path)\AMD64"
				}
			}
		}
		"x86" {
			Remove_Tree -Path "$($Path)\arm64"
			Remove_Tree -Path "$($Path)\AMD64"
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
			$SearchArch = @(
				"arm64\$($Global:IsLang)"
				"arm64\en-US"
				"arm64"
				"AMD64\$($Global:IsLang)"
				"AMD64\en-US"
				"AMD64"
				"x86\$($Global:IsLang)"
				"x86\en-US"
				"x86"
			)

			ForEach ($item in $SearchArch) {
				if (Test-Path -Path "$($Path)\$($item)" -PathType Container) {
					return Convert-Path -Path "$($Path)\$($item)" -ErrorAction SilentlyContinue
				}
			}
		}
		"AMD64" {
			$SearchArch = @(
				"AMD64\$($Global:IsLang)"
				"AMD64\en-US"
				"AMD64"
				"x86\$($Global:IsLang)"
				"x86\en-US"
				"x86"
			)

			ForEach ($item in $SearchArch) {
				if (Test-Path -Path "$($Path)\$($item)" -PathType Container) {
					return Convert-Path -Path "$($Path)\$($item)" -ErrorAction SilentlyContinue
				}
			}
		}
		"x86" {
			$SearchArch = @(
				"x86\$($Global:IsLang)"
				"x86\en-US"
				"x86"
			)

			ForEach ($item in $SearchArch) {
				if (Test-Path -Path "$($Path)\$($item)" -PathType Container) {
					return Convert-Path -Path "$($Path)\$($item)" -ErrorAction SilentlyContinue
				}
			}
		}
	}

	return $Path
}