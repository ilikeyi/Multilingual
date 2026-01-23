<#
	.Summary
	 Yi's Solutions

	.Open "Terminal" or "PowerShell ISE" as an administrator,
	 set PowerShell execution policy: Bypass, PS >

	 Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force

	.Example
	 PS C:\> .\_Create.Upgrade.Package.ps1
	 PS C:\> .\_Create.Upgrade.Package.ps1 -Silent -PGP -PGPPWD "P@ssw0rd" $PGPKEY "DBBC8D7BB64C4648A70AEA180FEBF674EAD23E05" -SaveTo "D:\UpdatePackge"

	.LINK
	 https://github.com/ilikeyi/Multilingual

	.About
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
	 Language                  | Language selected by the user       | 选择语言，交互
	 Language -Auto            | Automatic matching                  | 自动选择，不提示
	 Language -NewLang "zh-CN" | Mandatory use of specified language | 强制选择语言
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
	"DBBC8D7BB64C4648A70AEA180FEBF674EAD23E05"
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
$UpdateSaveTo = Join-Path -Path ([Environment]::GetFolderPath("Desktop")) -ChildPath "Multilingual.Upgrade.Package"

<#
	.Archive temporary directory
	.压缩包临时目录
#>
$TempFolderUpdate = Join-Path -Path ([Environment]::GetFolderPath("MyDocuments")) -ChildPath "Temp.Multilingual.Upgrade.Package"

<#
	.Exclude files or directories from the compressed package
	.从压缩包中排除文件或目录
#>
$ArchiveExcludeUp = @(
	"-xr-!Deploy"
	"-xr-!Logs"
	"-xr-!get.ps1"
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

	Logo -Title $lang.UpdateCreate

	write-host "  $($lang.UpdateCreate)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()
 
	$GUIUpdate         = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $lang.UpdateCreate
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $True
		ControlBox     = $True
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}

	$IconYi = "$($PSScriptRoot)\Modules\$((Get-Module -Name Engine).Version.ToString())\Assets\icon\Yi.ico"
	if (Test-Path $IconYi -PathType Leaf) {
		$GUIUpdate.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($IconYi)
	}

	$GUIUpdateVersion  = New-Object system.Windows.Forms.Label -Property @{
		Location       = "12,15"
		Height         = 30
		Width          = 390
		Text           = "$($lang.UpdateCurrent): $((Get-Module -Name Engine).Version.ToString())"
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
	$UI_Main_Create_ASC = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 470
		Text           = $lang.UpCreateASC
		add_Click      = {
			if ($UI_Main_Create_ASC.Checked) {
				$UI_Main_Create_ASC_Panel.Enabled = $True
				Save_Dynamic -regkey "Multilingual" -name "IsPGP" -value "True"
			} else {
				$UI_Main_Create_ASC_Panel.Enabled = $False
				Save_Dynamic -regkey "Multilingual" -name "IsPGP" -value "False"
			}
		}
	}
	$UI_Main_Create_ASC_Panel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		Padding        = "14,0,0,0"
		autoScroll     = $False
	}
	$UI_Main_Create_ASCPWDName = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 390
		Text           = $lang.CreateASCPwd
	}
	$UI_Main_Create_ASCPWD = New-Object System.Windows.Forms.MaskedTextBox -Property @{
		Height         = 30
		Width          = 400
		PasswordChar = "*"
		Text           = $Global:secure_password
	}
	$UI_Add_End_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 20
		Width          = 410
	}
	$UI_Main_Create_ASCSignName = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 390
		Text           = $lang.CreateASCAuthor
	}
	$UI_Main_Create_ASCSign = New-Object system.Windows.Forms.ComboBox -Property @{
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
		Height         = 30
		Width          = 510
		Location       = "10,602"
		Text           = ""
	}
	$GUIUpdateOK       = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 515
		Location       = "8,635"
		Text           = $lang.OK
		add_Click      = {
			<#
				.搜索到后生成 PGP
			#>
			if ($UI_Main_Create_ASC.Enabled) {
				if ($UI_Main_Create_ASC.Checked) {
					if ([string]::IsNullOrEmpty($UI_Main_Create_ASCSign.Text)) {
						$GUIUpdateErrorMsg.Text = "$($lang.SelectFromError): $($lang.CreateASCAuthorTips)"
						return
					} else {
						Save_Dynamic -regkey "Multilingual" -name "PGP" -value $UI_Main_Create_ASCSign.Text
						$Global:secure_password = $UI_Main_Create_ASCPWD.Text
						$Script:SignGpgKeyID = $UI_Main_Create_ASCSign.Text
					}
				}
			}

			$GUIUpdate.Hide()
			remove-item -path $TempFolderUpdate -Recurse -force -ErrorAction SilentlyContinue
			Update_Create_Process

			if ($UI_Main_Create_ASC.Enabled) {
				if ($UI_Main_Create_ASC.Checked) {
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
	$GUIUpdate.controls.AddRange((
		$GUIUpdateVersion,
		$GUIUpdateLowVersion,
		$GUIUpdateRearTips,
		$GUIUpdateGroupASC,
		$GUIUpdateErrorMsg,
		$GUIUpdateOK
	))

	$GUIUpdateGroupASC.controls.AddRange((
		$GUIUpdateCreateSHA256,
		$UI_Main_Create_ASC,
		$UI_Main_Create_ASC_Panel
	))

	$UI_Main_Create_ASC_Panel.controls.AddRange((
		$UI_Main_Create_ASCPWDName,
		$UI_Main_Create_ASCPWD,
		$UI_Add_End_Wrap,
		$UI_Main_Create_ASCSignName,
		$UI_Main_Create_ASCSign
	))

	$Verify_Install_Path = Get_Zip -Run "7z.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		$GUIUpdateOK.Enabled = $True
	} else {
		$UI_Main_Create_ASC.Enabled = $False
		$UI_Main_Create_ASC_Panel.Enabled = $False
		$GUIUpdateOK.Enabled = $False
		$GUIUpdateErrorMsg.Text += $lang.ZipStatus
	}

	<#
		.初始化：PGP KEY-ID
	#>
	ForEach ($item in $GpgKI) {
		$UI_Main_Create_ASCSign.Items.Add($item) | Out-Null
	}
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual" -Name "PGP" -ErrorAction SilentlyContinue) {
		$UI_Main_Create_ASCSign.Text = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual" -Name "PGP" -ErrorAction SilentlyContinue
	}

	<#
		.初始化复选框：生成 PGP
	#>
	$Verify_Install_Path = Get_ASC -Run "gpg.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		$UI_Main_Create_ASC.Enabled = $True
		
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual" -Name "IsPGP" -ErrorAction SilentlyContinue) {
			switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:Author)\Multilingual" -Name "IsPGP" -ErrorAction SilentlyContinue) {
				"True" {
					$UI_Main_Create_ASC.Checked = $True
				}
				"False" {
					$UI_Main_Create_ASC.Checked = $False
				}
			}
		} else {
			$UI_Main_Create_ASC.Checked = $False
		}
	} else {
		$UI_Main_Create_ASC.Enabled = $False
		$GUIUpdateErrorMsg.Text += $lang.ASCStatus
	}

	if ($UI_Main_Create_ASC.Enabled) {
		if ($UI_Main_Create_ASC.Checked) {
			$UI_Main_Create_ASC_Panel.Enabled = $True
		} else {
			$UI_Main_Create_ASC_Panel.Enabled = $False
		}
	} else {
		$UI_Main_Create_ASC_Panel.Enabled = $False
	}

	$GUIUpdate.ShowDialog() | Out-Null
}

Function Update_Create_Process
{
	$CurrentAio = Join-Path -Path $(Convert-Path -Path $PSScriptRoot) -ChildPath "AIO"
	$PublicAio  = Join-Path -Path "$($PSScriptRoot)\..\..\..\Modules" -ChildPath "AIO"

	$AIOPackage = @{
		Name = "7zPacker";
		Exclude = @(
			"7zG.exe"
		)
	}

	<#
		.复制新的包
	#>
	ForEach ($item in $AIOPackage) {
		$PublicAioItem = Join-Path -Path $PublicAio -ChildPath $item.Name
		write-host "  $($lang.FileName): " -NoNewline
		write-host $PublicAioItem -ForegroundColor Green

		$CurrentAioSaveTo = Join-Path -Path $CurrentAio -ChildPath $item.Name
		write-host "  $($lang.SaveTo): " -NoNewline
		write-host $CurrentAioSaveTo -ForegroundColor Green
		write-host "  $('-' * 80)"

		write-host "  $($lang.AddTo)".PadRight(28) -NoNewline
		if (Test-Path -Path $PublicAioItem -PathType Container) {
			remove-item -path $CurrentAioSaveTo -Recurse -force -ErrorAction SilentlyContinue

			New-Item -Path $CurrentAioSaveTo -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

			Copy-Item -Path $PublicAioItem -Destination $CurrentAio -Recurse -Force -Exclude $item.Exclude -ErrorAction SilentlyContinue
			Write-host $lang.Done -ForegroundColor Green
		} else {
			Write-host $lang.Failed -ForegroundColor Red
		}

		write-host
	}

	ForEach ($item in $BuildTypeUp) {
		Push-Location $PSScriptRoot
		Update_Create_Process_Add -Type $item
		Update_Create_Version -SaveTo $TempFolderUpdate -buildstring $((Get-Module -Name Engine).PrivateData.PSData.Buildstring) -CurrentVersion (Get-Module -Name Engine).Version.ToString() -LowVer $((Get-Module -Name Engine).PrivateData.PSData.MinimumVersion)
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
				write-host "  * $($lang.Uping) $UpdateName.zip"

				$arguments = @(
					"a",
					"-tzip",
					"""$($TempFolderUpdate)\$($UpdateName).zip""",
					"$($ArchiveExcludeUp)",
					"*.*",
					"-mcu=on",
					"-r",
					"-mx9";
				)
				Start-Process -FilePath $Verify_Install_Path -ArgumentList $Arguments -Wait -WindowStyle Minimized

				remove-item -path "$($TempFolderUpdate)\*.tar" -Force -ErrorAction SilentlyContinue
				write-host "    $($lang.Done)`n" -ForegroundColor Green
			}
			"tar" {
				write-host "  * $($lang.Uping) $($UpdateName).tar"

				$arguments = @(
					"a",
					"""$($TempFolderUpdate)\$($UpdateName).tar""",
					"$($ArchiveExcludeUp)",
					"*.*",
					"-r";
				)
				Start-Process -FilePath $Verify_Install_Path -ArgumentList $Arguments -Wait -WindowStyle Minimized

				remove-item -path "$($TempFolderUpdate)\*.tar" -Force -ErrorAction SilentlyContinue
				write-host "    $($lang.Done)`n" -ForegroundColor Green
			}
			"xz" {
				Write-Host "  * $($lang.Uping) $($UpdateName).tar.xz"
				if (Test-Path -Path "$($TempFolderUpdate)\$($UpdateName).tar" -PathType Leaf) {
					$arguments = @(
						"a",
						"""$($TempFolderUpdate)\$($UpdateName).tar.xz""",
						"""$($TempFolderUpdate)\$($UpdateName).tar""",
						"-mf=bcj",
						"-mx9";
					)
					Start-Process -FilePath $Verify_Install_Path -ArgumentList $Arguments -Wait -WindowStyle Minimized

					remove-item -path "$($TempFolderUpdate)\*.tar" -Force -ErrorAction SilentlyContinue
					write-host "    $($lang.Done)`n" -ForegroundColor Green
				} else {
					write-host "    $($lang.SkipCreate) $($UpdateName).tar`n"
				}
			}
			"gz" {
				Write-Host "  * $($lang.Uping) $($UpdateName).tar.gz"
				if (Test-Path -Path "$($TempFolderUpdate)\$($UpdateName).tar" -PathType Leaf) {
					$arguments = @(
						"a",
						"-tgzip",
						"""$($TempFolderUpdate)\$($UpdateName).tar.gz""",
						"""$($TempFolderUpdate)\$($UpdateName).tar""",
						"-mx9";
					)
					Start-Process -FilePath $Verify_Install_Path -ArgumentList $Arguments -Wait -WindowStyle Minimized

					remove-item -path "$($TempFolderUpdate)\*.tar" -Force -ErrorAction SilentlyContinue
					write-host "    $($lang.Done)`n" -ForegroundColor Green
				} else {
					write-host "    $($lang.SkipCreate) $($UpdateName).tar`n"
				}
			}
		}
	} else {
		write-host "    $($lang.ZipStatus)`n" -ForegroundColor Green
	}
}

Function Update_Create_ASC
{
	$Verify_Install_Path = Get_ASC -Run "gpg.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		Get-ChildItem $TempFolderUpdate -Include ($UpASType) -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
			Remove-Item -path "$($_.FullName).sig" -Force -ErrorAction SilentlyContinue
			Remove-Item -path "$($_.FullName).asc" -Force -ErrorAction SilentlyContinue

			write-host "  * $($lang.Uping) $UpdateName.asc"
			if (([string]::IsNullOrEmpty($Global:secure_password))) {
				$arguments = @(
					"--local-user",
					$Script:SignGpgKeyID,
					"--output",
					"""$($_.FullName).asc""",
					"--detach-sign",
					"""$($_.FullName)"""
				)

				Start-Process -FilePath $Verify_Install_Path -argument $arguments -Wait -WindowStyle Minimized
			} else {
				$arguments = @(
					"--pinentry-mode",
					"loopback",
					"--passphrase",
					$Global:secure_password,
					"--local-user",
					$Script:SignGpgKeyID,
					"--output",
					"""$($_.FullName).asc""",
					"--detach-sign",
					"""$($_.FullName)"""
				)

				Start-Process -FilePath $Verify_Install_Path -argument $arguments -Wait -WindowStyle Minimized
			}

			if (Test-Path "$($_.FullName).asc" -PathType Leaf) {
				write-host "    $($lang.Done)`n" -ForegroundColor Green
			} else {
				write-host "    $($lang.Inoperable)`n"
			}
		}
	} else {
		write-host "   $($lang.ASCStatus)" -ForegroundColor Red
	}
}

Function Update_Create_SHA256
{
	Get-ChildItem $TempFolderUpdate -Include ($UpASType) -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
		$fullnewpathFU = $_.FullName
		$fullnewpath = "$($_.FullName).sha256"

		write-host "  * $($lang.Uping) $($_.FullName).sha256"
		$calchash = (Get-FileHash -Path $fullnewpathFU -Algorithm SHA256)
		"$($calchash.hash)  $($_.Name)" | Out-File -FilePath $fullnewpath -Encoding ASCII

		write-host "    $($lang.Done)`n" -ForegroundColor Green
	}
}

Function Update_Create_MoveTo
{
	Check_Folder -chkpath $UpdateSaveTo

	Copy-Item -Path "$($TempFolderUpdate)\*" -Destination $UpdateSaveTo -Recurse -Force -ErrorAction SilentlyContinue

	Remove_Tree -path $TempFolderUpdate
}

Function Update_Create_Version
{
	param
	(
		[string]$SaveTo,
		[string]$Buildstring,
		[string]$CurrentVersion,
		[string]$LowVer
	)

@"
{
	"author": {
		"name": "$($Global:Author)",
		"url":  "$((Get-Module -Name Engine).HelpInfoURI)"
	},
	"version": {
		"buildstring": "$($Buildstring)",
		"version":     "$($CurrentVersion)",
		"minau":       "$($LowVer)"
	},
	"changelog": {
		"title": "$($Global:Author)'s Solutions - Change log",
		"log":   "   - Latest *Update\n  - Allows automatic background update checks, new feature. *New"
	},
	"url": "$((Get-Module -Name Engine).HelpInfoURI)/download/solutions/update/Multilingual/latest.zip"
}
"@ | Out-File -FilePath "$($SaveTo)\latest.json" -Encoding Ascii
}

if ($Silent) {
	$UpdateSaveTo = $SaveTo

	remove-item -path $TempFolderUpdate -Recurse -force -ErrorAction SilentlyContinue
	Update_Create_Process

	if ($PGP) {
		$Global:secure_password = $PGPPWD
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