<#
	.Summary
	.摘要
	 Yi's Solutions

	.PowerShell must be run with elevated privileges, run
	.PowerShell 必须以提升的特权运行，运行
	 powershell -Command "Set-ExecutionPolicy -ExecutionPolicy Bypass -Force"

	.Or run in a PowerShell session, PS C:\>
	.或在 PowerShell 会话中运行, PS C:\>
	 Set-ExecutionPolicy -ExecutionPolicy Bypass -Force

	.EXAMPLE
	.示例
	 PS C:\> .\Engine.ps1
	 PS C:\> .\Engine.ps1 -Function "Function1 -Param", "Function2 -Param"

	.LINK
	 https://github.com/ilikeyi/Multilingual

	.NOTES
	 Author:  Yi
	 Website: http://fengyi.tel
#>

Remove-Module -Name Engine -Force -ErrorAction Ignore | Out-Null
Import-Module -Name $PSScriptRoot\Modules\Engine.psd1 -PassThru -Force | Out-Null

<#
	.设置语言，用法
	.Set language pack, usage:
	 Language                | Language selected by the user       | 选择语言，交互
	 Language -Auto          | Automatic matching                  | 自动选择，不提示
	 Language -Force "zh-CN" | Mandatory use of specified language | 强制选择语言
#>
Language -Auto

<#
	.Prerequisites
	.先决条件
#>
Requirements

<#
	.启用日志记录并将其保存在脚本文件夹中。
	.Enable logging and save it in the script folder.
#>
Logging

<#
  .Signed GPG KEY-ID
  .签名 GPG KEY-ID
#>
$GpgKI = @(
	"0FEBF674EAD23E05"
	"2499B7924675A12B"
)

<#
  .Compressed package name
  .压缩包名称
#>
$UpdateName = "latest"

<#
  .Save the compressed package to
  .压缩包保存到
#>
$UpdateSaveTo = "$([Environment]::GetFolderPath("Desktop"))\$($Global:UniqueID).Solutions.Upgrade.Package"

<#
	.Archive temporary directory
	.压缩包临时目录
#>
$TempFolderUpdate = "$([Environment]::GetFolderPath("MyDocuments"))\Temp.$($Global:UniqueID).Solutions.Upgrade.Package"

<#
	.Exclude files or directories from the compressed package
	.从压缩包中排除文件或目录
#>
$ArchiveExcludeUp = @(
	"-xr-!Deploy"
	"-xr-!Logs"
	"-xr-!_Create.Upgrade.Package.ps1"
)

<#
	.创建升级包格式
#>
$BuildTypeUp = @(
	[Archive]::zip
)

$UpASType = @(
	"*.zip"
	"*.tar"
	"*.xz"
	"*.gz"
)

Enum Archive
{
	z7
	zip
	tar
	xz
	gz
}

function GetZip
{
	$Global:IsZipPath = "No"

	if (Test-Path -Path "${env:ProgramFiles}\7-Zip\7z.exe" -PathType leaf) {
		$Global:IsZipPath = "${env:ProgramFiles}\7-Zip\7z.exe"
		return $True
	}

	if (Test-Path -Path "${env:ProgramFiles(x86)}\7-Zip\7z.exe" -PathType leaf) {
		$Global:IsZipPath = "${env:ProgramFiles(x86)}\7-Zip\7z.exe"
		return $True
	}

	if (Test-Path -Path "$($env:SystemDrive)\$($Global:UniqueID)\$($Global:UniqueID)\7zPacker\7z.exe" -PathType leaf) {
		$Global:IsZipPath = "$($env:SystemDrive)\$($Global:UniqueID)\$($Global:UniqueID)\7zPacker\7z.exe"
		return $True
	}

	if (Test-Path "$PSScriptRoot\AIO\7zPacker\x86\7z.exe" -PathType leaf) {
		$Global:IsZipPath = "$PSScriptRoot\AIO\7zPacker\x86\7z.exe"
		return $True
	}

	if (Test-Path "$PSScriptRoot\AIO\7zPacker\AMD64\7z.exe" -PathType leaf) {
		$Global:IsZipPath = "$PSScriptRoot\AIO\7zPacker\AMD64\7z.exe"
		return $True
	}

	if (Test-Path "$PSScriptRoot\AIO\7zPacker\arm64\7z.exe" -PathType leaf) {
		$Global:IsZipPath = "$PSScriptRoot\AIO\7zPacker\arm64\7z.exe"
		return $True
	}

	return $False
}

function GetASC
{
	$Global:IsGpgPath = "No"

	if (Test-Path -Path "${env:ProgramFiles}\GnuPG\bin\gpg.exe" -PathType leaf) {
		$Global:IsGpgPath = "${env:ProgramFiles}\GnuPG\bin\gpg.exe"
		return $True
	}

	if (Test-Path -Path "${env:ProgramFiles(x86)}\GnuPG\bin\gpg.exe" -PathType leaf) {
		$Global:IsGpgPath = "${env:ProgramFiles(x86)}\GnuPG\bin\gpg.exe"
		return $True
	}

	return $False
}

<#
	.Create upgrade package user interface
	.创建升级包用户界面
#>
Function UpdateCreateGUI
{
	param
	(
		[switch]$Queue
	)

	Clear-Host
	$Host.UI.RawUI.WindowTitle = "$($Global:UniqueID)'s Solutions | $($lang.UpdateCreate)"
	Write-Host "`n   Author: $($Global:UniqueID) ( $($Global:AuthorURL) )

   From: $($Global:UniqueID)'s Solutions
   buildstring: $($ProductVersion).bs_release.220201-1208`n"

	Write-Host "   $($lang.UpdateCreate)`n   ---------------------------------------------------"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()
 
	$GUIUpdateCreateASCClick = {
		if ($GUIUpdateCreateASC.Checked) {
			$GUIUpdateCreateASCPanel.Enabled = $True
			DynamicSave -regkey "Engine" -name "IsPGP" -value "True" -String
		} else {
			$GUIUpdateCreateASCPanel.Enabled = $False
			DynamicSave -regkey "Engine" -name "IsPGP" -value "False" -String
		}
	}

	<#
		.Event: canceled
		.事件：取消
	#>
	$GUIUpdateCanelClick = {
		Write-Host "   $($lang.UserCancel)" -ForegroundColor Red
		$GUIUpdate.Close()
	}

	<#
		.Event: Ok
		.事件：确认
	#>
	$GUIUpdateOKClick = {
		<#
			.搜索到后生成 PGP
		#>
		if ($GUIUpdateCreateASC.Enabled) {
			if ($GUIUpdateCreateASC.Checked) {
				if ([string]::IsNullOrEmpty($GUIUpdateCreateASCSign.Text)) {
					$GUIUpdateErrorMsg.Text = "$($lang.SelectFromError -f $($lang.CreateASCAuthorTips))"
					return
				} else {
					DynamicSave -regkey "Engine" -name "PGP" -value $GUIUpdateCreateASCSign.Text -String
					$Global:secure_password = $GUIUpdateCreateASCPWD.Text
					$Global:SignGpgKeyID = $GUIUpdateCreateASCSign.Text
				}
			}
		}

		$GUIUpdate.Hide()
		UpdateCleanOld
		UpdatePack

		if ($GUIUpdateCreateASC.Enabled) {
			if ($GUIUpdateCreateASC.Checked) {
				UpdateCreateASC -Path $TempFolderUpdate
			}
		}

		if ($GUIUpdateCreateSHA256.Enabled) {
			if ($GUIUpdateCreateSHA256.Checked) {
				UpdateCreateSHA256 -Path $TempFolderUpdate
			}
		}
		MoveUpAllfile
		$GUIUpdate.Close()
	}
	$GUIUpdate         = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $lang.UpdateCreate
		TopMost        = $False
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
	}
	$GUIUpdateVersion  = New-Object system.Windows.Forms.Label -Property @{
		Location       = "12,5"
		Height         = 22
		Width          = 390
		Text           = "$($lang.UpdateCurrent) $($ProductVersion)"
	}
	$GUIUpdateLowVersion = New-Object system.Windows.Forms.Label -Property @{
		Location       = "12,30"
		Height         = 22
		Width          = 390
		Text           = "$($lang.UpdateLow) $($ChkLocalver)"
	}

	<#
		.创建升级包后需要做些什么
	#>
	$GUIUpdateRearTips = New-Object system.Windows.Forms.Label -Property @{
		Location       = "12,352"
		Height         = 22
		Width          = 390
		Text           = $lang.UpCreateRear
	}
	$GUIUpdateGroupASC = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 140
		Width          = 520
		autoSizeMode   = 1
		Padding        = "8,0,8,0"
		Location       = '0,376'
	}
	$GUIUpdateCreateASC = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 470
		Text           = $lang.UpCreateASC
		Location       = '26,0'
		Checked        = $True
		add_Click      = $GUIUpdateCreateASCClick
	}
	$GUIUpdateCreateASCPanel = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 115
		Width          = 530
		autoSizeMode   = 1
		Padding        = "0,0,0,0"
		Location       = "0,25"
	}
	$GUIUpdateCreateASCPWDName = New-Object system.Windows.Forms.Label -Property @{
		Location       = "42,0"
		Height         = 22
		Width          = 390
		Text           = $lang.CreateASCPwd
	}
	$GUIUpdateCreateASCPWD = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 22
		Width          = 400
		Text           = $($Global:secure_password)
		Location       = '42,25'
	}
	$GUIUpdateCreateASCSignName = New-Object system.Windows.Forms.Label -Property @{
		Location       = "42,60"
		Height         = 22
		Width          = 390
		Text           = $lang.CreateASCAuthor
	}
	$GUIUpdateCreateASCSign = New-Object system.Windows.Forms.ComboBox -Property @{
		Location       = "42,83"
		Height         = 55
		Width          = 400
		Text           = ""
		DropDownStyle  = "DropDownList"
	}

	$GUIUpdateCreateSHA256 = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 470
		Text           = $lang.UpCreateSHA256
		Location       = '26,525'
		Checked        = $True
	}

	$GUIUpdateErrorMsg = New-Object system.Windows.Forms.Label -Property @{
		Location       = "10,570"
		Height         = 22
		Width          = 390
		Text           = ""
	}
	$GUIUpdateOK       = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "8,595"
		Height         = 36
		Width          = 515
		add_Click      = $GUIUpdateOKClick
		Text           = $lang.OK
	}
	$GUIUpdateCanel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "8,635"
		Height         = 36
		Width          = 515
		add_Click      = $GUIUpdateCanelClick
		Text           = $lang.Cancel
	}
	$GUIUpdate.controls.AddRange((
		$GUIUpdateVersion,
		$GUIUpdateLowVersion,
		$GUIUpdateRearTips,
		$GUIUpdateGroupASC,
		$GUIUpdateCreateSHA256,
		$GUIUpdateErrorMsg,
		$GUIUpdateOK,
		$GUIUpdateCanel
	))

	$GUIUpdateGroupASC.controls.AddRange((
		$GUIUpdateCreateASC,
		$GUIUpdateCreateASCPanel
	))

	$GUIUpdateCreateASCPanel.controls.AddRange((
		$GUIUpdateCreateASCPWDName,
		$GUIUpdateCreateASCPWD,
		$GUIUpdateCreateASCSignName,
		$GUIUpdateCreateASCSign
	))

	if (GetZip) {
		$GUIUpdateOK.Enabled = $True
	} else {
		$GUIUpdateGroupASC.Enabled = $False
		$GUIUpdateOK.Enabled = $False
		$GUIUpdateErrorMsg.Text += $lang.ZipStatus
	}

	<#
		.初始化：PGP KEY-ID
	#>
	foreach ($item in $GpgKI) {
		$GUIUpdateCreateASCSign.Items.Add($item) | Out-Null
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine" -Name "PGP" -ErrorAction SilentlyContinue) {
		$GUIUpdateCreateASCSign.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine" -Name "PGP" -ErrorAction SilentlyContinue
	}

	if (GetASC) {
		$GUIUpdateGroupASC.Enabled = $True
		
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine" -Name "IsPGP" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine" -Name "IsPGP" -ErrorAction SilentlyContinue) {
				"True" {
					$GUIUpdateCreateASC.Checked = $True
					$GUIUpdateCreateASCPanel.Enabled = $True
				}
				"False" {
					$GUIUpdateCreateASC.Checked = $False
					$GUIUpdateCreateASCPanel.Enabled = $False
				}
			}
		} else {
			$GUIUpdateCreateASC.Checked = $False
			$GUIUpdateCreateASCPanel.Enabled = $False
		}
	} else {
		$GUIUpdateGroupASC.Enabled = $False
		$GUIUpdateErrorMsg.Text += $lang.ASCStatus
	}

	switch ($Global:IsLang) {
		"zh-CN" {
			$GUIUpdate.Font = New-Object System.Drawing.Font("Microsoft YaHei", 9, [System.Drawing.FontStyle]::Regular)
		}
		Default {
			$GUIUpdate.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
		}
	}

	$GUIUpdate.FormBorderStyle = 'Fixed3D'
	$GUIUpdate.ShowDialog() | Out-Null
}

function UpdateCleanOld {
	remove-item -path "$UpdateSaveTo" -Recurse -force -ErrorAction SilentlyContinue
	remove-item -path "$TempFolderUpdate" -Recurse -force -ErrorAction SilentlyContinue
}

function UpdatePack {
	foreach ($item in $BuildTypeUp) {
		Push-Location $PSScriptRoot
		UpdatePackCreate -Type $item
		CreateVersion -SaveTo "$TempFolderUpdate" -Version $ProductVersion -CurrentVersion $ProductVersion -LowVer $ChkLocalver
	}
}

function UpdatePackCreate
{
	Param
	(
		[string]$Type
	)

	if (GetZip) {
		CheckCatalog -chkpath $TempFolderUpdate
		switch ($Type) {
			"zip" {
				Write-Host "   * $($lang.Uping) $UpdateName.zip"
				$arguments = "a", "-tzip", "$TempFolderUpdate\$UpdateName.zip", "$ArchiveExcludeUp", "*.*", "-mcu=on", "-r", "-mx9";
				Start-Process $Global:IsZipPath "$arguments" -Wait -WindowStyle Minimized
				remove-item -path "$TempFolderUpdate\*.tar" -Force -ErrorAction SilentlyContinue
				Write-Host "    - $($lang.Done)`n" -ForegroundColor Green
			}
			"tar" {
				Write-Host "   * $($lang.Uping) $UpdateName.tar"
				$arguments = "a", "$TempFolderUpdate\$UpdateName.tar", "$ArchiveExcludeUp", "*.*", "-r";
				Start-Process $Global:IsZipPath "$arguments" -Wait -WindowStyle Minimized
				remove-item -path "$TempFolderUpdate\*.tar" -Force -ErrorAction SilentlyContinue
				Write-Host "    - $($lang.Done)`n" -ForegroundColor Green
			}
			"xz" {
				Write-Host "  * $($lang.Uping) $UpdateName.tar.xz"
				if (Test-Path -Path "$TempFolderUpdate\$UpdateName.tar" -PathType Leaf) {
					$arguments = "a", "$TempFolderUpdate\$UpdateName.tar.xz", "$TempFolderUpdate\$UpdateName.tar", "-mf=bcj", "-mx9";
					Start-Process $Global:IsZipPath "$arguments" -Wait -WindowStyle Minimized
					remove-item -path "$TempFolderUpdate\*.tar" -Force -ErrorAction SilentlyContinue
					Write-Host "    - $($lang.Done)`n" -ForegroundColor Green
				} else {
					Write-Host "     - $($lang.SkipCreate) $UpdateName.tar`n"
				}
			}
			"gz" {
				Write-Host "  * $($lang.Uping) $UpdateName.tar.gz"
				if (Test-Path -Path "$TempFolderUpdate\$UpdateName.tar" -PathType Leaf) {
					$arguments = "a", "-tgzip", "$TempFolderUpdate\$UpdateName.tar.gz", "$TempFolderUpdate\$UpdateName.tar", "-mx9";
					Start-Process $Global:IsZipPath "$arguments" -Wait -WindowStyle Minimized
					remove-item -path "$TempFolderUpdate\*.tar" -Force -ErrorAction SilentlyContinue
					Write-Host "    - $($lang.Done)`n" -ForegroundColor Green
				} else {
					Write-Host "   x $($lang.SkipCreate) $UpdateName.tar`n"
				}
			}
		}
	} else {
		Write-Host "    - $($lang.ZipStatus)`n" -ForegroundColor Green
	}
}

function UpdateCreateASC
{
	param
	(
		$Path
	)

	$FlagsCheckGPG = $False
	if (Test-Path -Path "${env:ProgramFiles}\GnuPG\bin\gpg.exe" -PathType leaf) {
		$FlagsCheckGPG = $True
		$GpgLocalPath = "${env:ProgramFiles}\GnuPG\bin\gpg.exe"
	}
	if (Test-Path -Path "${env:ProgramFiles(x86)}\GnuPG\bin\gpg.exe" -PathType leaf) {
		$FlagsCheckGPG = $True
		$GpgLocalPath = "${env:ProgramFiles(x86)}\GnuPG\bin\gpg.exe"
	}

	if ($FlagsCheckGPG) {
		Get-ChildItem $Path -Include ($UpASType) -Recurse -ErrorAction SilentlyContinue | Foreach-Object {
			Remove-Item -path "$($_.FullName).sig" -Force -ErrorAction SilentlyContinue
			Remove-Item -path "$($_.FullName).asc" -Force -ErrorAction SilentlyContinue

			Write-Host "   * $($lang.Uping) $UpdateName.asc"
			if (([string]::IsNullOrEmpty($Global:secure_password))) {
				Start-Process $GpgLocalPath -argument "--local-user ""$Global:SignGpgKeyID"" --output ""$($_.FullName).asc"" --detach-sign ""$($_.FullName)""" -Wait -WindowStyle Minimized
			} else {
				Start-Process $GpgLocalPath -argument "--pinentry-mode loopback --passphrase ""$Global:secure_password"" --local-user ""$Global:SignGpgKeyID"" --output ""$($_.FullName).asc"" --detach-sign ""$($_.FullName)""" -Wait -WindowStyle Minimized
			}

			if (Test-Path "$($_.FullName).asc" -PathType Leaf) {
				Write-Host "    - $($lang.Done)`n" -ForegroundColor Green
			} else {
				Write-Host "    - $($lang.Inoperable)`n"
			}
		}
	} else {
		Write-Host "    $($lang.ASCStatus)" -ForegroundColor Red
	}
}

function UpdateCreateSHA256
{
	param
	(
		$Path
	)

	Get-ChildItem $Path -Include ($UpASType) -Recurse -ErrorAction SilentlyContinue | Foreach-Object {
		$fullnewpath = "$($_.FullName).sha256"

		Write-Host "   * $($lang.Uping) $UpdateName.sha256"
		$calchash = (Get-FileHash $($_.FullName) -Algorithm SHA256)
		Remove-Item -path $fullnewpath -Force -ErrorAction SilentlyContinue
		$calchash.hash + "  " + $_.Name | Out-File -FilePath $fullnewpath -Encoding ASCII
		Write-Host "     - $($lang.Done)`n" -ForegroundColor Green
	}
}

function MoveUpAllfile
{
	CheckCatalog -chkpath $UpdateSaveTo

	Copy-Item -Path "$TempFolderUpdate\*" -Destination $UpdateSaveTo -Recurse -Force -ErrorAction SilentlyContinue

	RemoveTree -path "$TempFolderUpdate"
}

function CreateVersion
{
	param
	(
		[string]$SaveTo,
		[string]$Version,
		[string]$CurrentVersion,
		[string]$LowVer
	)

@"
{
	"author": {
		"name": "$($Global:UniqueID)",
		"url":  "$($Global:AuthorURL)"
	},
	"version": {
		"buildstring": "$($CurrentVersion).bs_release.220201-1208",
		"version":     "$($CurrentVersion)",
		"minau":       "$($LowVer)"
	},
	"changelog": {
		"title": "$($Global:UniqueID)'s Solutions - new autoupdate system",
		"log":   "   - Latest *Update"
	},
	"url": "$($Global:AuthorURL)/download/solutions/update/Multilingual/latest.zip"
}
"@ | Out-File -FilePath "$SaveTo\latest.json" -Encoding Ascii
}

UpdateCreateGUI