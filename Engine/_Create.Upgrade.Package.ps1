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
Prerequisite

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

Function Get_ASC
{
	param
	(
		$Run
	)

	$Local_Zip_Path = @(
		"${env:ProgramFiles}\GnuPG\bin\$($Run)"
		"${env:ProgramFiles(x86)}\GnuPG\bin\$($Run)"
	)

	ForEach ($item in $Local_Zip_Path) {
		if (Test-Path -Path $item -PathType leaf) {
			return $item
		}
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
	$Host.UI.RawUI.WindowTitle = "$((Get-Module -Name Engine).Author)'s Solutions | $($lang.UpdateCreate)"
	Write-Host "`n   Author: $((Get-Module -Name Engine).Author) ( $((Get-Module -Name Engine).HelpInfoURI) )

   From: $((Get-Module -Name Engine).Author)'s Solutions
   buildstring: $((Get-Module -Name Engine).Version.ToString()).bs_release.2024.04.18`n"

	Write-Host "   $($lang.UpdateCreate)`n   $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()
 
	$GUIUpdate         = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $lang.UpdateCreate
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}
	$GUIUpdateVersion  = New-Object system.Windows.Forms.Label -Property @{
		Location       = "12,15"
		Height         = 30
		Width          = 390
		Text           = "$($lang.UpdateCurrent) $((Get-Module -Name Engine).Version.ToString())"
	}
	$GUIUpdateLowVersion = New-Object system.Windows.Forms.Label -Property @{
		Location       = "12,50"
		Height         = 30
		Width          = 390
		Text           = "$($lang.UpdateLow) $((Get-Module -Name Engine).PrivateData.PSData.MinimumVersion)"
	}

	<#
		.创建升级包后需要做些什么
	#>
	$GUIUpdateRearTips = New-Object system.Windows.Forms.Label -Property @{
		Location       = "12,245"
		Height         = 30
		Width          = 390
		Text           = $lang.UpCreateRear
	}
	$GUIUpdateGroupASC = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 270
		Width          = 520
		autoSizeMode   = 1
		Padding        = "26,0,8,0"
		Location       = '0,276'
	}
	$GUIUpdateCreateASC = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 470
		Text           = $lang.UpCreateASC
		Checked        = $True
		add_Click      = {
			if ($GUIUpdateCreateASC.Checked) {
				$GUIUpdateCreateASCPanel.Enabled = $True
				Save_Dynamic -regkey "Multilingual" -name "IsPGP" -value "True" -String
			} else {
				$GUIUpdateCreateASCPanel.Enabled = $False
				Save_Dynamic -regkey "Multilingual" -name "IsPGP" -value "False" -String
			}
		}
	}
	$GUIUpdateCreateASCPanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		Padding        = "14,0,0,0"
		autoScroll     = $False
	}
	$GUIUpdateCreateASCPWDName = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 390
		Text           = $lang.CreateASCPwd
	}
	$GUIUpdateCreateASCPWD = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 400
		Text           = $($Script:secure_password)
	}
	$UI_Add_End_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 20
		Width          = 410
	}
	$GUIUpdateCreateASCSignName = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 390
		Text           = $lang.CreateASCAuthor
	}
	$GUIUpdateCreateASCSign = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 55
		Width          = 400
		Text           = ""
		DropDownStyle  = "DropDownList"
	}

	$GUIUpdateCreateSHA256 = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 470
		Text           = $lang.UpCreateSHA256
		Checked        = $True
	}

	$GUIUpdateErrorMsg = New-Object system.Windows.Forms.Label -Property @{
		Location       = "10,565"
		Height         = 30
		Width          = 390
		Text           = ""
	}
	$GUIUpdateOK       = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 515
		Location       = "8,595"
		Text           = $lang.OK
		add_Click      = {
			<#
				.搜索到后生成 PGP
			#>
			if ($GUIUpdateCreateASC.Enabled) {
				if ($GUIUpdateCreateASC.Checked) {
					if ([string]::IsNullOrEmpty($GUIUpdateCreateASCSign.Text)) {
						$GUIUpdateErrorMsg.Text = "$($lang.SelectFromError -f $($lang.CreateASCAuthorTips))"
						return
					} else {
						Save_Dynamic -regkey "Multilingual" -name "PGP" -value $GUIUpdateCreateASCSign.Text -String
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
	}
	$GUIUpdateCanel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 515
		Location       = "8,635"
		Text           = $lang.Cancel
		add_Click      = {
			Write-Host "   $($lang.UserCancel)" -ForegroundColor Red
			$GUIUpdate.Close()
		}
	}
	$GUIUpdate.controls.AddRange((
		$GUIUpdateVersion,
		$GUIUpdateLowVersion,
		$GUIUpdateRearTips,
		$GUIUpdateGroupASC,
		$GUIUpdateErrorMsg,
		$GUIUpdateOK,
		$GUIUpdateCanel
	))

	$GUIUpdateGroupASC.controls.AddRange((
		$GUIUpdateCreateSHA256,
		$GUIUpdateCreateASC,
		$GUIUpdateCreateASCPanel
	))

	$GUIUpdateCreateASCPanel.controls.AddRange((
		$GUIUpdateCreateASCPWDName,
		$GUIUpdateCreateASCPWD,
		$UI_Add_End_Wrap,
		$GUIUpdateCreateASCSignName,
		$GUIUpdateCreateASCSign
	))

	$Verify_Install_Path = Get_Zip -Run "7z.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		$GUIUpdateOK.Enabled = $True
	} else {
		$GUIUpdateCreateASC.Enabled = $False
		$GUIUpdateCreateASCPanel.Enabled = $False
		$GUIUpdateOK.Enabled = $False
		$GUIUpdateErrorMsg.Text += $lang.ZipStatus
	}

	<#
		.初始化：PGP KEY-ID
	#>
	ForEach ($item in $GpgKI) {
		$GUIUpdateCreateASCSign.Items.Add($item) | Out-Null
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Engine).Author)\Multilingual" -Name "PGP" -ErrorAction SilentlyContinue) {
		$GUIUpdateCreateASCSign.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Engine).Author)\Multilingual" -Name "PGP" -ErrorAction SilentlyContinue
	}

	$Verify_Install_Path = Get_ASC -Run "gpg.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		$GUIUpdateCreateASC.Enabled = $True
		$GUIUpdateCreateASCPanel.Enabled = $True
		
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Engine).Author)\Multilingual" -Name "IsPGP" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$((Get-Module -Name Engine).Author)\Multilingual" -Name "IsPGP" -ErrorAction SilentlyContinue) {
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
		$GUIUpdateCreateASC.Enabled = $False
		$GUIUpdateCreateASCPanel.Enabled = $False
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

	$GUIUpdate.ShowDialog() | Out-Null
}

Function Update_Create_Process
{
	ForEach ($item in $BuildTypeUp) {
		Push-Location $PSScriptRoot
		Update_Create_Process_Add -Type $item
		Update_Create_Version -SaveTo "$TempFolderUpdate" -CurrentVersion (Get-Module -Name Engine).Version.ToString() -LowVer $((Get-Module -Name Engine).PrivateData.PSData.MinimumVersion)
	}
}

Function Update_Create_Process_Add
{
	Param
	(
		[string]$Type
	)

	$Verify_Install_Path = Get_Zip -Run "7z.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		Check_Folder -chkpath $TempFolderUpdate
		switch ($Type) {
			"zip" {
				Write-Host "   * $($lang.Uping) $UpdateName.zip"
				$arguments = @(
					"a",
					"-tzip",
					"$($TempFolderUpdate)\$($UpdateName).zip",
					"$($ArchiveExcludeUp)",
					"*.*",
					"-mcu=on",
					"-r",
					"-mx9";
				)
				Start-Process -FilePath $Verify_Install_Path -ArgumentList $Arguments -Wait -WindowStyle Minimized
				remove-item -path "$TempFolderUpdate\*.tar" -Force -ErrorAction SilentlyContinue
				Write-Host "     $($lang.Done)`n" -ForegroundColor Green
			}
			"tar" {
				Write-Host "   * $($lang.Uping) $UpdateName.tar"
				$arguments = @(
					"a",
					"$($TempFolderUpdate)\$($UpdateName).tar",
					"$($ArchiveExcludeUp)",
					"*.*",
					"-r";
				)
				Start-Process -FilePath $Verify_Install_Path -ArgumentList $Arguments -Wait -WindowStyle Minimized
				remove-item -path "$TempFolderUpdate\*.tar" -Force -ErrorAction SilentlyContinue
				Write-Host "     $($lang.Done)`n" -ForegroundColor Green
			}
			"xz" {
				Write-Host "  * $($lang.Uping) $UpdateName.tar.xz"
				if (Test-Path -Path "$TempFolderUpdate\$UpdateName.tar" -PathType Leaf) {
					$arguments = @(
						"a",
						"$($TempFolderUpdate)\$($UpdateName).tar.xz",
						"$($TempFolderUpdate)\$($UpdateName).tar",
						"-mf=bcj",
						"-mx9";
					)
					Start-Process -FilePath $Verify_Install_Path -ArgumentList $Arguments -Wait -WindowStyle Minimized
					remove-item -path "$TempFolderUpdate\*.tar" -Force -ErrorAction SilentlyContinue
					Write-Host "     $($lang.Done)`n" -ForegroundColor Green
				} else {
					Write-Host "     $($lang.SkipCreate) $UpdateName.tar`n"
				}
			}
			"gz" {
				Write-Host "  * $($lang.Uping) $UpdateName.tar.gz"
				if (Test-Path -Path "$TempFolderUpdate\$UpdateName.tar" -PathType Leaf) {
					$arguments = @(
						"a",
						"-tgzip",
						"$($TempFolderUpdate)\$($UpdateName).tar.gz",
						"$($TempFolderUpdate)\$($UpdateName).tar",
						"-mx9";
					)
					Start-Process -FilePath $Verify_Install_Path -ArgumentList $Arguments -Wait -WindowStyle Minimized
					remove-item -path "$TempFolderUpdate\*.tar" -Force -ErrorAction SilentlyContinue
					Write-Host "     $($lang.Done)`n" -ForegroundColor Green
				} else {
					Write-Host "     $($lang.SkipCreate) $UpdateName.tar`n"
				}
			}
		}
	} else {
		Write-Host "     $($lang.ZipStatus)`n" -ForegroundColor Green
	}
}

Function Update_Create_ASC
{
	$Verify_Install_Path = Get_ASC -Run "gpg.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		Get-ChildItem $TempFolderUpdate -Include ($UpASType) -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
			Remove-Item -path "$($_.FullName).sig" -Force -ErrorAction SilentlyContinue
			Remove-Item -path "$($_.FullName).asc" -Force -ErrorAction SilentlyContinue

			Write-Host "   * $($lang.Uping) $UpdateName.asc"
			if (([string]::IsNullOrEmpty($Script:secure_password))) {
				Start-Process $Verify_Install_Path -argument "--local-user ""$Script:SignGpgKeyID"" --output ""$($_.FullName).asc"" --detach-sign ""$($_.FullName)""" -Wait -WindowStyle Minimized
			} else {
				Start-Process $Verify_Install_Path -argument "--pinentry-mode loopback --passphrase ""$Script:secure_password"" --local-user ""$Script:SignGpgKeyID"" --output ""$($_.FullName).asc"" --detach-sign ""$($_.FullName)""" -Wait -WindowStyle Minimized
			}

			if (Test-Path "$($_.FullName).asc" -PathType Leaf) {
				Write-Host "    $($lang.Done)`n" -ForegroundColor Green
			} else {
				Write-Host "      $($lang.Inoperable)`n"
			}
		}
	} else {
		Write-Host "    $($lang.ASCStatus)" -ForegroundColor Red
	}
}

Function Update_Create_SHA256
{
	Get-ChildItem $TempFolderUpdate -Include ($UpASType) -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
		$fullnewpathFU = "$($_.FullName)"
		$fullnewpath = "$($_.FullName).sha256"

		Write-Host "   * $($lang.Uping) $($_.FullName).sha256"
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
		"name": "$((Get-Module -Name Engine).Author)",
		"url":  "$((Get-Module -Name Engine).HelpInfoURI)"
	},
	"version": {
		"buildstring": "$($CurrentVersion).bs_release.2024.04.18",
		"version":     "$($CurrentVersion)",
		"minau":       "$($LowVer)"
	},
	"changelog": {
		"title": "$((Get-Module -Name Engine).Author)'s Solutions - new autoupdate system",
		"log":   "   - Latest *Update"
	},
	"url": "$((Get-Module -Name Engine).HelpInfoURI)/download/solutions/update/Multilingual/latest.zip"
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