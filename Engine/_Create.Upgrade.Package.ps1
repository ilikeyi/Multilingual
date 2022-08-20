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
	 PS C:\> .\_Create.Upgrade.Package.ps1
	 PS C:\> .\_Create.Upgrade.Package.ps1 -Silent -PGP -PGPPWD "P@ssw0rd" $PGPKEY "0FEBF674EAD23E05" -SaveTo "D:\UpdatePackge"

	.LINK
	 https://github.com/ilikeyi/Multilingual

	.NOTES
	 Author:  Yi
	 Website: http://fengyi.tel
#>

param
(
	[switch]$Silent,
	[switch]$SHA256,
	[switch]$PGP,
	[string]$PGPPWD,
	[string]$PGPKEY,
	[string]$SaveTo
)

<#
	.The log is saved to the directory name
	.日志保存到目录名称
#>
$Global:LogSaveTo = "Log-$(Get-Date -Format "yyyyMMddHHmmss")"

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
	.Enabled logging and save it in the script folder.
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
$UpdateSaveTo = "$([Environment]::GetFolderPath("Desktop"))\Multilingual.Upgrade.Package"

<#
	.Archive temporary directory
	.压缩包临时目录
#>
$TempFolderUpdate = "$([Environment]::GetFolderPath("MyDocuments"))\Temp.Multilingual.Upgrade.Package"

<#
	.Exclude files or directories from the compressed package
	.从压缩包中排除文件或目录
#>
$ArchiveExcludeUp = @(
	"-xr-!Deploy"
	"-xr-!Logs"
#	"-xr-!_Create.Upgrade.Package.ps1"
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

Function Get_Zip
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

	if (Test-Path -Path "$(Get_Arch_Path -Path "$($PSScriptRoot)\AIO\7zPacker")\7z.exe" -PathType leaf) {
		$Global:IsZipPath = "$(Get_Arch_Path -Path "$($PSScriptRoot)\AIO\7zPacker")\7z.exe"
		return $True
	}

	return $False
}

Function Get_ASC
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
Function Update_Create_UI
{
	param
	(
		[switch]$Queue
	)

	Clear-Host
	$Host.UI.RawUI.WindowTitle = "$($Global:UniqueID)'s Solutions | $($Upgrade_Package.UpdateCreate)"
	Write-Host "`n   Author: $($Global:UniqueID) ( $($Global:AuthorURL) )

   From: $($Global:UniqueID)'s Solutions
   buildstring: $((Get-Module -Name Engine).Version.ToString()).bs_release.220201-1208`n"

	Write-Host "   $($Upgrade_Package.UpdateCreate)`n   ---------------------------------------------------"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()
 
	$GUIUpdateCreateASCClick = {
		if ($GUIUpdateCreateASC.Checked) {
			$GUIUpdateCreateASCPanel.Enabled = $True
			Save_Dynamic -regkey "Engine" -name "IsPGP" -value "True" -String
		} else {
			$GUIUpdateCreateASCPanel.Enabled = $False
			Save_Dynamic -regkey "Engine" -name "IsPGP" -value "False" -String
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
					$GUIUpdateErrorMsg.Text = "$($Upgrade_Package.SelectFromError -f $($Upgrade_Package.CreateASCAuthorTips))"
					return
				} else {
					Save_Dynamic -regkey "Engine" -name "PGP" -value $GUIUpdateCreateASCSign.Text -String
					$Script:secure_password = $GUIUpdateCreateASCPWD.Text
					$Script:SignGpgKeyID = $GUIUpdateCreateASCSign.Text
				}
			}
		}

		$GUIUpdate.Hide()
		remove-item -path "$TempFolderUpdate" -Recurse -force -ErrorAction SilentlyContinue
		Update_Create_Process

		if ($GUIUpdateCreateASC.Enabled) {
			if ($GUIUpdateCreateASC.Checked) {
				Update_Create_ASC
			}
		}

		if ($GUIUpdateCreateSHA256.Enabled) {
			if ($GUIUpdateCreateSHA256.Checked) {
				Update_Create_SHA256
			}
		}
		Update_Create_MoveTo
		$GUIUpdate.Close()
	}
	$GUIUpdate         = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $Upgrade_Package.UpdateCreate
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
		Text           = "$($lang.UpdateCurrent) $((Get-Module -Name Engine).Version.ToString())"
	}
	$GUIUpdateLowVersion = New-Object system.Windows.Forms.Label -Property @{
		Location       = "12,30"
		Height         = 22
		Width          = 390
		Text           = "$($Upgrade_Package.UpdateLow) $($Global:ChkLocalver)"
	}

	<#
		.创建升级包后需要做些什么
	#>
	$GUIUpdateRearTips = New-Object system.Windows.Forms.Label -Property @{
		Location       = "12,352"
		Height         = 22
		Width          = 390
		Text           = $Upgrade_Package.UpCreateRear
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
		Text           = $Upgrade_Package.UpCreateASC
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
		Text           = $Upgrade_Package.CreateASCPwd
	}
	$GUIUpdateCreateASCPWD = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 22
		Width          = 400
		Text           = $($Script:secure_password)
		Location       = '42,25'
	}
	$GUIUpdateCreateASCSignName = New-Object system.Windows.Forms.Label -Property @{
		Location       = "42,60"
		Height         = 22
		Width          = 390
		Text           = $Upgrade_Package.CreateASCAuthor
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
		Text           = $Upgrade_Package.UpCreateSHA256
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

	if (Get_Zip) {
		$GUIUpdateOK.Enabled = $True
	} else {
		$GUIUpdateGroupASC.Enabled = $False
		$GUIUpdateOK.Enabled = $False
		$GUIUpdateErrorMsg.Text += $Upgrade_Package.ZipStatus
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

	if (Get_ASC) {
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
		$GUIUpdateErrorMsg.Text += $Upgrade_Package.ASCStatus
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

Function Update_Create_Process
{
	foreach ($item in $BuildTypeUp) {
		Push-Location $PSScriptRoot
		Update_Create_Process_Add -Type $item
		Update_Create_Version -SaveTo "$TempFolderUpdate" -CurrentVersion (Get-Module -Name Engine).Version.ToString() -LowVer $Global:ChkLocalver
	}
}

Function Update_Create_Process_Add
{
	Param
	(
		[string]$Type
	)

	if (Get_Zip) {
		Check_Folder -chkpath $TempFolderUpdate
		switch ($Type) {
			"zip" {
				Write-Host "   * $($Upgrade_Package.Uping) $UpdateName.zip"
				$arguments = "a", "-tzip", "$TempFolderUpdate\$UpdateName.zip", "$ArchiveExcludeUp", "*.*", "-mcu=on", "-r", "-mx9";
				Start-Process $Global:IsZipPath "$arguments" -Wait -WindowStyle Minimized
				remove-item -path "$TempFolderUpdate\*.tar" -Force -ErrorAction SilentlyContinue
				Write-Host "     $($lang.Done)`n" -ForegroundColor Green
			}
			"tar" {
				Write-Host "   * $($Upgrade_Package.Uping) $UpdateName.tar"
				$arguments = "a", "$TempFolderUpdate\$UpdateName.tar", "$ArchiveExcludeUp", "*.*", "-r";
				Start-Process $Global:IsZipPath "$arguments" -Wait -WindowStyle Minimized
				remove-item -path "$TempFolderUpdate\*.tar" -Force -ErrorAction SilentlyContinue
				Write-Host "     $($lang.Done)`n" -ForegroundColor Green
			}
			"xz" {
				Write-Host "  * $($Upgrade_Package.Uping) $UpdateName.tar.xz"
				if (Test-Path -Path "$TempFolderUpdate\$UpdateName.tar" -PathType Leaf) {
					$arguments = "a", "$TempFolderUpdate\$UpdateName.tar.xz", "$TempFolderUpdate\$UpdateName.tar", "-mf=bcj", "-mx9";
					Start-Process $Global:IsZipPath "$arguments" -Wait -WindowStyle Minimized
					remove-item -path "$TempFolderUpdate\*.tar" -Force -ErrorAction SilentlyContinue
					Write-Host "     $($lang.Done)`n" -ForegroundColor Green
				} else {
					Write-Host "     $($Upgrade_Package.SkipCreate) $UpdateName.tar`n"
				}
			}
			"gz" {
				Write-Host "  * $($Upgrade_Package.Uping) $UpdateName.tar.gz"
				if (Test-Path -Path "$TempFolderUpdate\$UpdateName.tar" -PathType Leaf) {
					$arguments = "a", "-tgzip", "$TempFolderUpdate\$UpdateName.tar.gz", "$TempFolderUpdate\$UpdateName.tar", "-mx9";
					Start-Process $Global:IsZipPath "$arguments" -Wait -WindowStyle Minimized
					remove-item -path "$TempFolderUpdate\*.tar" -Force -ErrorAction SilentlyContinue
					Write-Host "     $($lang.Done)`n" -ForegroundColor Green
				} else {
					Write-Host "     $($Upgrade_Package.SkipCreate) $UpdateName.tar`n"
				}
			}
		}
	} else {
		Write-Host "     $($Upgrade_Package.ZipStatus)`n" -ForegroundColor Green
	}
}

Function Update_Create_ASC
{
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
		Get-ChildItem $TempFolderUpdate -Include ($UpASType) -Recurse -ErrorAction SilentlyContinue | Foreach-Object {
			Remove-Item -path "$($_.FullName).sig" -Force -ErrorAction SilentlyContinue
			Remove-Item -path "$($_.FullName).asc" -Force -ErrorAction SilentlyContinue

			Write-Host "   * $($Upgrade_Package.Uping) $UpdateName.asc"
			if (([string]::IsNullOrEmpty($Script:secure_password))) {
				Start-Process $GpgLocalPath -argument "--local-user ""$Script:SignGpgKeyID"" --output ""$($_.FullName).asc"" --detach-sign ""$($_.FullName)""" -Wait -WindowStyle Minimized
			} else {
				Start-Process $GpgLocalPath -argument "--pinentry-mode loopback --passphrase ""$Script:secure_password"" --local-user ""$Script:SignGpgKeyID"" --output ""$($_.FullName).asc"" --detach-sign ""$($_.FullName)""" -Wait -WindowStyle Minimized
			}

			if (Test-Path "$($_.FullName).asc" -PathType Leaf) {
				Write-Host "    $($lang.Done)`n" -ForegroundColor Green
			} else {
				Write-Host "      $($lang.Inoperable)`n"
			}
		}
	} else {
		Write-Host "    $($Upgrade_Package.ASCStatus)" -ForegroundColor Red
	}
}

Function Update_Create_SHA256
{
	Get-ChildItem $TempFolderUpdate -Include ($UpASType) -Recurse -ErrorAction SilentlyContinue | Foreach-Object {
		$fullnewpathFU = "$($_.FullName)"
		$fullnewpath = "$($_.FullName).sha256"

		Write-Host "   * $($Upgrade_Package.Uping) $($_.FullName).sha256"
		$calchash = (Get-FileHash $($fullnewpathFU) -Algorithm SHA256)
		"$($calchash.hash)  $($_.Name)" | Out-File -FilePath $fullnewpath -Encoding ASCII

		Write-Host "     $($lang.Done)`n" -ForegroundColor Green
	}
}

Function Update_Create_MoveTo
{
	Check_Folder -chkpath $UpdateSaveTo

	Copy-Item -Path "$TempFolderUpdate\*" -Destination $UpdateSaveTo -Recurse -Force -ErrorAction SilentlyContinue

	Remove_Tree -path "$TempFolderUpdate"
}

Function Update_Create_Version
{
	param
	(
		[string]$SaveTo,
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
"@ | Out-File -FilePath "$($SaveTo)\latest.json" -Encoding Ascii
}

if ($Silent) {
	$UpdateSaveTo = $SaveTo

	remove-item -path "$TempFolderUpdate" -Recurse -force -ErrorAction SilentlyContinue
	Update_Create_Process

	if ($PGP) {
		$Script:secure_password = $PGPPWD
		$Script:SignGpgKeyID = $PGPKEY
		Update_Create_ASC
	}

	if ($SHA256) {
		Update_Create_SHA256
	}

	Update_Create_MoveTo
} else {
	Update_Create_UI
}