<#

  PowerShell ソフトウェアをインストールする

  . 主な機能
    1. インストールパッケージがローカルに存在しない場合は、ダウンロード機能をアクティブにします。
    2. ダウンロード機能を使用すると、システムの種類を自動的に判断したり、順番に自動的に選択したりします。
    3. ドライブ文字を自動的に選択します。
        3.1    ドライブ文字を指定でき、自動設定後、現在のシステムドライブは除外されます。
               使用可能なディスクが見つからない場合は、現在のシステムディスクに戻ります。
        3.2    必要な最小の残りの空き容量を設定できます。デフォルトは1GBです。
    4. 検索ファイル名はあいまい検索をサポートし、ワイルドカード *；
    5. キューに入れ、インストーラーの実行後にキューに追加し、終了を待ちます。
    6. 事前設定された構造に従って順番に検索します：
       * 元のダウンロードアドレス：https://fengyi.tel/Instl.Packer.Latest.exe
         + ファジーファイル名：Instl.Packer*
           - 条件 1：システム言語：en-US，検索条件：Instl.Packer*en-US*
           - 条件 2：ファジーファイル名を検索：Instl.Packer*
           - 条件 3：Webサイトを検索して、元のファイル名をダウンロードします：Instl.Packer.Latest
    7. 動的関数：実行前および実行後の処理を追加し、関数 OpenApp {} に移動してモジュールを変更します。
    8. 解凍パッケージ処理などをサポートします。

  . 前提条件
    - PowerShell 5.1 以上

  . 接続
  	- https://github.com/ilikeyi/powershell.install.software


  パッケージ構成チュートリアル

 ソフトウェアパッケージ                                    命令
("Windows Defender Control",                              パッケージ名
 [Status]::Enable,                                        ステータス：有効-有効;無効-無効
 [Action]::Install,                                       アクション：Install - インストール；NoInst -ダウンロード後にインストールしないでください；Unzip - ダウンロード後にのみ解凍します；To - ディレクトリにインストール
 [Mode]::Wait,                                            動作モード：Wait - 完了するのを待つ；Fast - 直接実行
 "auto",                                                  自動設定後、現在のシステムディスクは除外されます。使用可能なディスクが見つからない場合、デフォルト設定は現在のシステムディスクです。ドライブ文字を指定してください。 [A:]-[Z:]；パスを指定します：\\192.168.1.1
 "インストールパッケージ\道具",                            ディレクトリ構造
 "sordum",                                                圧縮パッケージを分解します
 "https://www.sordum.org/files/download/d-control/dControl.zip", デフォルトでは、x86 ダウンロードアドレスを使用して
 "",                                                      x64 アドレスをダウンロードします
 "",                                                      Arm64 アドレスをダウンロードします
 "dfControl*",                                            ファイル名ぼかしルックアップ (*)
 "/D",                                                    動作パラメータ
 "",                                                      运行前
 "")                                                      运行后，前往 Function OpenApp {} 处更改该模块

 .プロフィール

 - ディフォルト
   dfControl.ini に変更されました dfControl.Default.ini

 - 英語
   dfControl.ini に変更されました dfControl.en-US.ini
   開ける dfControl.en-US.ini，意思 Language=Auto 着替える Language=English

 - 中国語
   dfControl.ini に変更されました dfControl.zh-CN.ini
   開ける dfControl.zh-CN.ini，意思 Language=Auto 着替える Language=Chinese_简体中文

   生産が完了した後に取り外します dfControl.ini。

#>

#Requires -version 5.1

# スクリプトパラメータを取得する（いずれも）
[CmdletBinding()]
param
(
	[Switch]$Force,
	[Switch]$Silent
)

# 著者
$Global:UniqueID  = "Yi"
$Global:AuthorURL = "https://fengyi.tel"

# 初期化自動選択ディスク最小サイズ：1ガー
$Global:DiskMinSize = 1

# リセットキュー
$Global:AppQueue = @()

# タイトル
$Host.UI.RawUI.WindowTitle = "ソフトウェアのインストール"

# すべてのソフトウェア構成
$app = @(
	("$($Global:UniqueID)'s 暗い人格のテーマパック",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Fast,
	 "auto",
	 "インストールパッケージ\テーマパッケージ",
	 "",
	 "$($Global:AuthorURL)/$($Global:UniqueID).deskthemepack",
	 "",
	 "",
	 "$($Global:UniqueID)*",
	 "",
	 "",
	 ""),
	("$($Global:UniqueID)'s 軽い色の人格のテーマパッケージ",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Fast,
	 "auto",
	 "インストールパッケージ\テーマパッケージ",
	 "",
	 "$($Global:AuthorURL)/$($Global:UniqueID).Light.deskthemepack",
	 "",
	 "",
	 "$($Global:UniqueID)*Light*",
	 "",
	 "",
	 ""),
	("Nvidia GEFORCE GAME READY DRIVER",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "インストールパッケージ\運転者\グラフィックスカード",
	 "",
	 "",
	 "https://us.download.nvidia.cn/Windows/466.27/466.27-desktop-win10-64bit-international-dch-whql.exe",
	 "",
	 "*-desktop-win10-*-international-dch-whql",
	 "-s -clean -noreboot -noeula",
	 "",
	 ""),
	("Sysinternals Suite",
	 [Status]::Disable,
	 [Action]::To,
	 [Mode]::Fast,
	 $env:SystemDrive,
	 "",
	 "",
	 "https://download.sysinternals.com/files/SysinternalsSuite.zip",
	 "",
	 "https://download.sysinternals.com/files/SysinternalsSuite-ARM64.zip",
	 "SysinternalsSuite",
	 "",
	 "",
	 ""),
	("VisualCppRedist AIO",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "インストールパッケージ\AIO",
	 "",
	 "https://github.com/abbodi1406/vcredist/releases/download/v0.58.0/VisualCppRedist_AIO_x86_x64_58.zip",
	 "",
	 "",
	 "VisualCppRedist*",
	 "/y",
	 "",
	 ""),
	("Gpg4win",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "インストールパッケージ\AIO",
	 "",
	 "https://files.gpg4win.org/gpg4win-latest.exe",
	 "",
	 "",
	 "gpg4win*",
	 "/S",
	 "",
	 ""),
	("Python",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "インストールパッケージ\ソフトウェアを開発する",
	 "",
	 "https://www.python.org/ftp/python/3.10.2/python-3.10.2.exe",
	 "https://www.python.org/ftp/python/3.10.2/python-3.10.2-amd64.exe",
	 "https://www.python.org/ftp/python/3.10.2/python-3.10.2-embed-arm64.zip",
	 "python-*",
	 "/quiet InstallAllUsers=1 PrependPath=1 Include_test=0",
	 "",
	 ""),
	("WPS Office",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "インストールパッケージ\Office ソフトウェア",
	 "",
	 "https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/onlinesetup/distsrc/600.1002/wpsinst/wps_office_inst.exe",
	 "",
	 "",
	 "wps*",
	 "",
	 "",
	 ""),
	("久我音楽",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "インストールパッケージ\音楽ソフトウェア",
	 "",
	 "https://downmini.yun.kugou.com/web/kugou10021.exe",
	 "",
	 "",
	 "kugou*",
	 "/S",
	 "",
	 ""),
	("Netease Cloud Music",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "インストールパッケージ\音楽ソフトウェア",
	 "",
	 "https://d1.music.126.net/dmusic/cloudmusicsetup2.9.5.199424.exe",
	 "",
	 "",
	 "cloudmusicsetup*",
	 "/S",
	 "",
	 ""),
	("QQ 音楽",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "インストールパッケージ\音楽ソフトウェア",
	 "",
	 "https://dldir1.qq.com/music/clntupate/QQMusicSetup.exe",
	 "",
	 "",
	 "QQMusicSetup",
	 "",
	 "",
	 ""),
	("迅雷 11",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "インストールパッケージ\ダウンロードツール",
	 "",
	 "https://down.sandai.net/thunder11/XunLeiWebSetup11.2.6.1790gw.exe",
	 "",
	 "",
	 "XunLeiWebSetup11*",
	 "/S",
	 "",
	 ""),
	("テンセント QQ",
	 [Status]::Enable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "インストールパッケージ\社会的適用",
	 "",
	 "https://down.qq.com/qqweb/PCQQ/PCQQ_EXE/QQ9.5.2.27905.exe",
	 "",
	 "",
	 "PCQQ2021",
	 "/S",
	 "",
	 ""),
	("ウィチャット",
	 [Status]::Enable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "インストールパッケージ\社会的適用",
	 "",
	 "https://dldir1.qq.com/weixin/Windows/WeChatSetup.exe",
	 "",
	 "",
	 "WeChatSetup",
	 "/S",
	 "",
	 ""),
	("Tencent Video",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "インストールパッケージ\オンラインテレビ",
	 "",
	 "https://dldir1.qq.com/qqtv/TencentVideo11.32.2015.0.exe",
	 "",
	 "",
	 "TencentVideo*",
	 "/S",
	 "",
	 ""),
	("iqiyi のビデオ",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "インストールパッケージ\オンラインテレビ",
	 "",
	 "https://dl-static.iqiyi.com/hz/IQIYIsetup_z40.exe",
	 "",
	 "",
	 "IQIYIsetup*",
	 "/S",
	 "",
	 "")
)
# 最後に、ゾーンをしないでください。

# 州
Enum Status
{
	Enable
	Disable
}

# 注とな＃运运式
Enum Mode
{
	Wait    # 完了するのを待ちます
	Fast    # は直接実行中です
	Queue   # キュー
}

<#
	.手術
#>
Enum Action
{
	Install # インストール
	NoInst  # 不注意の装着
	To      # 圧縮パッケージをディレクトリにダウンロードします
	Unzip   # ダウンロードするだけです
}

<#
	.システム構造
#>
Function GetArchitecture
{
	<#
		.レジストリから取得：ユーザーシステムアーキテクチャを指定します
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "Architecture" -ErrorAction SilentlyContinue) {
		$Global:InstlArchitecture = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "Architecture"
		return
	}

	<#
		.初期化：システムアーキテクチャ
	#>
	SetArchitecture -Type $env:PROCESSOR_ARCHITECTURE
}

<#
	.システムアーキテクチャを設定します
#>
Function SetArchitecture
{
	param
	(
		[string]$Type
	)

	$FullPath = "HKCU:\SOFTWARE\$($Global:UniqueID)\Install"

	if (-not (Test-Path $FullPath)) {
		New-Item -Path $FullPath -Force -ErrorAction SilentlyContinue | Out-Null
	}
	New-ItemProperty -LiteralPath $FullPath -Name "Architecture" -Value $Type -PropertyType String -Force -ea SilentlyContinue | Out-Null

	$Global:InstlArchitecture = $Type
}

<#
	.自動的にディスクを選択します
#>
Function SetFreeDiskTo
{
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskTo" -ErrorAction SilentlyContinue) {
		$GetDiskTo = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskTo"
		if (TestAvailableDisk -Path $GetDiskTo) {
			$Global:FreeDiskTo = $GetDiskTo
			return
		}
	}

	<#
		.ディスクの状態を検索し、システムディスクを除外します
	#>
	$drives = Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | Where-Object { -not ((JoinMainFolder -Path $env:SystemDrive) -eq $_.Root) } | Select-Object -ExpandProperty 'Root'

	<#
		.レジストリから空き容量を取得して、利用可能なディスクを確認します
	#>
	$GetDiskStatus = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskStatus"

	<#
		.レジストリから選択したディスクを取得します
	#>
	$GetDiskMinSize = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskMinSize"

	<#
		.ディスクの状態を検索し、システムディスクを除外します
	#>
	$FlagsSearchNewDisk = $False
	foreach ($drive in $drives) {
		if (TestAvailableDisk -Path $drive) {
			$FlagsSearchNewDisk = $True

			if (VerifyAvailableSize -Disk $drive -Size $GetDiskMinSize) {
				SetNewFreeDiskTo -Disk $drive
				return
			}
		}
	}

	<#
		.利用可能なディスク、初期化：現在のシステムディスクが見つかりませんでした
	#>
	if (-not ($FlagsSearchNewDisk)) {
		SetNewFreeDiskTo -Disk (JoinMainFolder -Path $env:SystemDrive)
	}
}

Function SetNewFreeDiskTo
{
	param
	(
		[string]$Disk
	)

	$FullPath = "HKCU:\SOFTWARE\$($Global:UniqueID)\Install"

	if (-not (Test-Path $FullPath)) {
		New-Item -Path $FullPath -Force -ErrorAction SilentlyContinue | Out-Null
	}
	New-ItemProperty -LiteralPath $FullPath -Name "DiskTo" -Value $Disk -PropertyType String -Force -ea SilentlyContinue | Out-Null

	$Global:FreeDiskTo = $Disk
}

<#
	.選択したディスクをレジストリから取得し、それが強制的にディスクを設定しているかどうかを判断し、残りのディスク容量をスキップしてください。
#>
Function SetFreeDiskSize
{
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskMinSize" -ErrorAction SilentlyContinue) {
		$GetDiskMinSize = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskMinSize"

		if ([string]::IsNullOrEmpty($GetDiskMinSize)) {
			SetNewFreeDiskSize -Size $Global:DiskMinSize
		}

		if (-not ($GetDiskMinSize -ge $Global:DiskMinSize)) {
			SetNewFreeDiskSize -Size $Global:DiskMinSize
		}
	} else {
		SetNewFreeDiskSize -Size $Global:DiskMinSize
	}
}

Function SetNewFreeDiskSize
{
	param
	(
		[string]$Size
	)

	$FullPath = "HKCU:\SOFTWARE\$($Global:UniqueID)\Install"

	if (-not (Test-Path $FullPath)) {
		New-Item -Path $FullPath -Force -ErrorAction SilentlyContinue | Out-Null
	}
	New-ItemProperty -LiteralPath $FullPath -Name "DiskMinSize" -Value $Size -PropertyType String -Force -ea SilentlyContinue | Out-Null
}

<#
	.レジストリから空き容量を取得して、利用可能なディスクを確認します
#>
Function SetFreeDiskAvailable
{
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskStatus" -ErrorAction SilentlyContinue) {
		$GetDiskStatus = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskStatus"

		if ([string]::IsNullOrEmpty($GetDiskStatus)) {
			SetNewFreeDiskAvailable -Status "True"
		} else {
			$Global:FreeDiskStatus = $GetDiskStatus
		}
	} else {
		SetNewFreeDiskAvailable -Status "True"
	}
}

<#
	.利用可能なディスクを設定します
#>
Function SetNewFreeDiskAvailable
{
	param
	(
		[string]$Status
	)

	$FullPath = "HKCU:\SOFTWARE\$($Global:UniqueID)\Install"

	if (-not (Test-Path $FullPath)) {
		New-Item -Path $FullPath -Force -ErrorAction SilentlyContinue | Out-Null
	}
	New-ItemProperty -LiteralPath $FullPath -Name "DiskStatus" -Value $Status -PropertyType String -Force -ea SilentlyContinue | Out-Null

	$Global:FreeDiskStatus = $Status
}

<#
	.利用可能なディスクサイズを確認してください
#>
Function VerifyAvailableSize
{
	param
	(
		[string]$Disk,
		[int]$Size
	)

	$TempCheckVerify = $false

	Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | Where-Object { ((JoinMainFolder -Path $Disk) -eq $_.Root) } | ForEach-Object {
		if ($_.Free -gt (ConvertSize -From GB -To Bytes $Size)) {
			$TempCheckVerify = $True
		} else {
			$TempCheckVerify = $false
		}
	}

	return $TempCheckVerify
}

<#
	.ディスクスペースのサイズを変換します
#>
Function ConvertSize
{
	param
	(
		[validateset("Bytes","KB","MB","GB","TB")]
		[string]$From,
		[validateset("Bytes","KB","MB","GB","TB")]
		[string]$To,
		[Parameter(Mandatory=$true)]
		[double]$Value,
		[int]$Precision = 4
	)
	switch($From) {
		"Bytes" { $value = $Value }
		"KB" { $value = $Value * 1024 }
		"MB" { $value = $Value * 1024 * 1024 }
		"GB" { $value = $Value * 1024 * 1024 * 1024 }
		"TB" { $value = $Value * 1024 * 1024 * 1024 * 1024 }
	}
	switch ($To) {
		"Bytes" { return $value }
		"KB" { $Value = $Value/1KB }
		"MB" { $Value = $Value/1MB }
		"GB" { $Value = $Value/1GB }
		"TB" { $Value = $Value/1TB }
	}

	return [Math]::Round($value,$Precision,[MidPointRounding]::AwayFromZero)
}

Function SetupGUI
{
	GetArchitecture
	SetFreeDiskSize
	SetFreeDiskAvailable
	SetFreeDiskTo

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	Function RefreshInitialDisk {
		$GetDiskTo = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskTo"

		$FormSelectDiSKPane1.controls.Clear()
		Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
			if (TestAvailableDisk -Path $_.Root) {
				$RadioButton  = New-Object System.Windows.Forms.RadioButton -Property @{
					Height    = 22
					Width     = 430
					Text      = $_.Root
					Tag       = $_.Description
				}

				if ($_.Root -eq $GetDiskTo) {
					$RadioButton.Checked = $True
				}

				if ($FormSelectDiSKLowSize.Checked) {
					if (-not (VerifyAvailableSize -Disk $_.Root -Size $SelectLowSize.Text)) {
						$RadioButton.Enabled = $False
					}
				}
				$FormSelectDiSKPane1.controls.AddRange($RadioButton)
			}
		}
	}
	$GetDiskAvailable_Click = {
		if ($FormSelectDiSKLowSize.Checked) {
			$SelectLowSize.Enabled = $True
			SetNewFreeDiskAvailable -Status "True"
		} else {
			$SelectLowSize.Enabled = $False
			SetNewFreeDiskAvailable -Status "False"
		}
		RefreshInitialDisk
	}
	$SelectLowSizeClick = {
		SetNewFreeDiskSize -Size $SelectLowSize.Text
		RefreshInitialDisk
	}
	$Canel_Click = {
		$FormSelectDiSK.Close()
	}
	$OK_ArchitectureARM64_Click = {
		$SoftwareTipsErrorMsg.Text = "arm64 ダウンロードアドレスをお勧めします。x64、x86 の順に選択してください。"
	}
	$OK_ArchitectureAMD64_Click = {
		$SoftwareTipsErrorMsg.Text = "X64 ダウンロードアドレスをお勧めします。x86 の順に選択してください。"
	}
	$OK_ArchitectureX86_Click = {
		$SoftwareTipsErrorMsg.Text = "x86 ダウンロードアドレスのみを選択します。"
	}
	$OK_Click = {
		if ($ArchitectureARM64.Checked) { SetArchitecture -Type "ARM64" }
		if ($ArchitectureAMD64.Checked) { SetArchitecture -Type "AMD64" }
		if ($ArchitectureX86.Checked) { SetArchitecture -Type "x86" }

		$FormSelectDiSKPane1.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Enabled) {
					if ($_.Checked) {
						$FormSelectDiSK.Hide()
						SetNewFreeDiskTo -Disk $_.Text
						$FormSelectDiSK.Close()
					}
				}
			}
		}
		$ErrorMsg.Text = "エラー：デフォルトのディスクが選択されていません"
	}
	$FormSelectDiSK    = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = "設定"
		TopMost        = $False
		MaximizeBox    = $False
		StartPosition  = "CenterScreen"
		MinimizeBox    = $false
		BackColor      = "#ffffff"
	}
	$ArchitectureTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 490
		Text           = "優先ダウンロードアドレス"
		Location       = '10,10'
	}
	$GroupArchitecture = New-Object system.Windows.Forms.Panel -Property @{
		BorderStyle    = 0
		Height         = 28
		Width          = 505
		autoSizeMode   = 1
		Padding        = 8
		Location       = '10,35'
	}
	$ArchitectureARM64 = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 22
		Width          = 60
		Text           = "arm64"
		Location       = '10,0'
		add_Click      = $OK_ArchitectureARM64_Click
	}
	$ArchitectureAMD64 = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 22
		Width          = 60
		Text           = "x64"
		Location       = '80,0'
		add_Click      = $OK_ArchitectureAMD64_Click
	}
	$ArchitectureX86    = New-Object System.Windows.Forms.RadioButton -Property @{
		Height         = 22
		Width          = 60
		Text           = "x86"
		Location       = '140,0'
		add_Click      = $OK_ArchitectureX86_Click
	}
	$SoftwareTips      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 40
		Width          = 491
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $False
		Padding        = "8,0,8,0"
		Dock           = 0
		Location       = '23,65'
	}
	$SoftwareTipsErrorMsg = New-Object system.Windows.Forms.Label -Property @{
		AutoSize       = 1
		Text           = ""
	}
	$FormSelectDiSKSize = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 395
		Text           = "利用可能なディスクを自動的に選択する場合"
		Location       = '10,115'
	}
	$FormSelectDiSKLowSize = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 400
		Text           = "最小空き容量を確認してください"
		Location       = '26,140'
		add_Click      = $GetDiskAvailable_Click
	}
	$SelectLowSize     = New-Object System.Windows.Forms.NumericUpDown -Property @{
		Height         = 22
		Width          = 60
		Location       = "45,165"
		Value          = 1
		Minimum        = 1
		Maximum        = 999999
		TextAlign      = 1
		add_Click      = $SelectLowSizeClick
	}
	$SelectLowUnit     = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 80
		Text           = "GB"
		Location       = "115,168"
	}
	$FormSelectDiSKTitle = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 22
		Width          = 490
		Text           = "デフォルトでディスクを使用 ( 更新 )"
		Location       = '24,205'
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = { RefreshInitialDisk }
	}
	$FormSelectDiSKPane1 = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 330
		Width          = 490
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
		Padding        = "8,0,8,0"
		Dock           = 0
		Location       = '24,228'
	}
	$ErrorMsg          = New-Object system.Windows.Forms.Label -Property @{
		Location       = "8,570"
		Height         = 22
		Width          = 512
		Text           = ""
	}
	$Start             = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "8,595"
		Height         = 36
		Width          = 515
		add_Click      = $OK_Click
		Text           = "確認"
	}
	$Canel             = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "8,635"
		Height         = 36
		Width          = 515
		add_Click      = $Canel_Click
		Text           = "キャンセル"
	}
	$FormSelectDiSK.controls.AddRange((
		$ArchitectureTitle,
		$GroupArchitecture,
		$SoftwareTips,
		$FormSelectDiSKSize,
		$FormSelectDiSKLowSize,
		$SelectLowSize,
		$SelectLowUnit,
		$FormSelectDiSKTitle,
		$FormSelectDiSKPane1,
		$ErrorMsg,
		$Start,
		$Canel
	))
	$SoftwareTips.controls.AddRange((
		$SoftwareTipsErrorMsg
	))
	$GroupArchitecture.controls.AddRange((
		$ArchitectureARM64,
		$ArchitectureAMD64,
		$ArchitectureX86
	))

	switch ($Global:InstlArchitecture) {
		"ARM64" {
			$ArchitectureARM64.Checked = $True
		}
		"AMD64" {
			if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") {
				$ArchitectureARM64.Enabled = $True
			} else {
				$ArchitectureARM64.Enabled = $False
			}

			$ArchitectureAMD64.Checked = $True
		}
		Default {
			if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") {
				$ArchitectureARM64.Enabled = $True
			} else {
				$ArchitectureARM64.Enabled = $False
			}

			if ($env:PROCESSOR_ARCHITECTURE -eq "AMD64") {
				$ArchitectureAMD64.Enabled = $True
			} else {
				$ArchitectureAMD64.Enabled = $False
			}

			$ArchitectureX86.Checked = $True
		}
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskMinSize" -ErrorAction SilentlyContinue) {
		$GetDiskMinSize = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskMinSize"
		$SelectLowSize.Text = $GetDiskMinSize
	} else {
		SetNewFreeDiskSize -Size $Global:DiskMinSize
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskStatus" -ErrorAction SilentlyContinue) {
		switch (Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskStatus" -ErrorAction SilentlyContinue) {
			"True" {
				$FormSelectDiSKLowSize.Checked = $True
				$SelectLowSize.Enabled = $True
			}
			"False" {
				$FormSelectDiSKLowSize.Checked = $False
				$SelectLowSize.Enabled = $False
			}
		}
	} else {
		$FormSelectDiSKLowSize.Checked = $True
		$SelectLowSize.Enabled = $True
	}

	RefreshInitialDisk

	$FormSelectDiSK.FormBorderStyle = 'Fixed3D'
	$FormSelectDiSK.ShowDialog() | Out-Null
}

Function TestAvailableDisk
{
	param
	(
		[string]$Path
	)

	$RandomGuid = [guid]::NewGuid()
	$test_tmp_filename = "writetest-$($RandomGuid)"
	$test_filename = Join-Path -Path "$($Path)" -ChildPath "$($test_tmp_filename)" -ErrorAction SilentlyContinue

	try
	{
		[io.file]::OpenWrite($test_filename).close()

		if (Test-Path $test_filename) {
			Remove-Item $test_filename -ErrorAction SilentlyContinue
			return $true
		}
		$false
	}
	catch
	{
		return $false
	}
}

Function TestURI
{
	Param
	(
		[Parameter(Position=0,Mandatory,HelpMessage="HTTP or HTTPS")]
		[ValidatePattern( "^(http|https)://" )]
		[Alias("url")]
		[string]$URI,
		[Parameter(ParameterSetName="Detail")]
		[Switch]$Detail,
		[ValidateScript({$_ -ge 0})]
		[int]$Timeout = 30
	)
	Process
	{
		Try
		{
			$paramHash = @{
				UseBasicParsing = $True
				DisableKeepAlive = $True
				Uri = $uri
				Method = 'Head'
				ErrorAction = 'stop'
				TimeoutSec = $Timeout
			}
			$test = Invoke-WebRequest @paramHash
			if ($Detail) {
				$test.BaseResponse | Select-Object ResponseURI,ContentLength,ContentType,LastModified, @{Name="Status";Expression={$Test.StatusCode}}
			} else {
				if ($test.statuscode -ne 200) { $False } else { $True }
			}
		} Catch {
			write-verbose -message $_.exception
			if ($Detail) {
				$objProp = [ordered]@{
					ResponseURI = $uri
					ContentLength = $null
					ContentType = $null
					LastModified = $null
					Status = 404
				}
				New-Object -TypeName psobject -Property $objProp
			} else { $False }
		}
	}
}

Function CheckCatalog
{
	Param
	(
		[string]$chkpath
	)

	if (-not (Test-Path $chkpath -PathType Container))
	{
		New-Item -Path $chkpath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
		if (-not (Test-Path $chkpath -PathType Container)) {
			Write-Host "    - ディレクトリ障害を作成します：$($chkpath)`n" -ForegroundColor Red
			return
		}
	}
}

Function JoinUrl
{
	param
	(
		[parameter(Mandatory=$True, HelpMessage="Base Path")]
		[ValidateNotNullOrEmpty()]
		[string]$Path,
		[parameter(Mandatory=$True, HelpMessage="Child Path or Item Name")]
		[ValidateNotNullOrEmpty()]
		[string]$ChildPath
	)
	if ($Path.EndsWith('/'))
	{
		return "$Path"+"$ChildPath"
	} else {
		return "$Path/$ChildPath"
	}
}

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

Function InstallProcess
{
	param
	(
		$appname,
		$status,
		$act,
		$mode,
		$todisk,
		$structure,
		$pwd,
		$url,
		$urlAMD64,
		$urlarm64,
		$filename,
		$param,
		$Before,
		$After
	)

	GetArchitecture
	SetFreeDiskSize
	SetFreeDiskAvailable
	SetFreeDiskTo

	Switch ($status)
	{
		Enable
		{
			Write-Host "   インストール                - $($appname)" -ForegroundColor Green
		}
		Disable
		{
			Write-Host "   インストールをスキップします - $($appname)" -ForegroundColor Red
			return
		}
	}

	switch ($Global:InstlArchitecture) {
		"arm64" {
			if ([string]::IsNullOrEmpty($urlarm64)) {
				if ([string]::IsNullOrEmpty($urlAMD64)) {
					if ([string]::IsNullOrEmpty($url)) {
						$FilenameTo = $urlAMD64
					} else {
						$url = $url
						$FilenameTo = $url
					}
				} else {
					$url = $urlAMD64
					$FilenameTo = $urlAMD64
				}
			} else {
				$url = $urlarm64
				$FilenameTo = $urlarm64
			}
		}
		"AMD64" {
			if ($Global:InstlArchitecture -eq "AMD64") {
				if ([string]::IsNullOrEmpty($urlAMD64)) {
					if ([string]::IsNullOrEmpty($url)) {
						$FilenameTo = $urlAMD64
					} else {
						$url = $url
						$FilenameTo = $url
					}
				} else {
					$url = $urlAMD64
					$FilenameTo = $urlAMD64
				}
			}
		}
		Default {
			if ($Global:InstlArchitecture -eq "x86") {
				if ([string]::IsNullOrEmpty($url)) {
					$FilenameTo = $urlAMD64
				} else {
					$url = $url
					$FilenameTo = $url
				}
			}
		}
	}

	$SaveToName = [IO.Path]::GetFileName($FilenameTo)
	$packer = [IO.Path]::GetFileNameWithoutExtension($FilenameTo)
	$types =  [IO.Path]::GetExtension($FilenameTo).Replace(".", "")

	Switch ($todisk)
	{
		auto
		{
			Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
				$TempRootPath = $_.Root
				$tempoutputfoldoer = Join-Path -Path $($TempRootPath) -ChildPath "$($structure)"
				Get-ChildItem -Path $tempoutputfoldoer -Filter "*$($filename)*$((Get-Culture).Name)*" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
					$OutTo = Join-Path -Path "$($TempRootPath)" -ChildPath "$($structure)"
					$OutAny = $($_.fullname)
					break
				}
				Get-ChildItem -Path $tempoutputfoldoer -Filter "*$($filename)*" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
					$OutTo = Join-Path -Path "$($TempRootPath)" -ChildPath "$($structure)"
					$OutAny = $($_.fullname)
					break
				}
				Get-ChildItem -Path $tempoutputfoldoer -Filter "*$($packer)*" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
					$OutTo = Join-Path -Path "$($TempRootPath)" -ChildPath "$($structure)"
					$OutAny = $($_.fullname)
					break
				}
				$OutTo = Join-Path -Path $Global:FreeDiskTo -ChildPath "$($structure)"
				$OutAny = Join-Path -Path $Global:FreeDiskTo -ChildPath "$($structure)\$SaveToName"
			}
		}
		default
		{
			$OutTo = Join-Path -Path $($todisk) -ChildPath "$($structure)"
			$OutAny = Join-Path -Path $($todisk) -ChildPath "$($structure)\$SaveToName"
			Get-ChildItem -Path $OutTo -Filter "*$($filename)*$((Get-Culture).Name)*" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
				$OutAny = $($_.fullname)
				break
			}
			Get-ChildItem -Path $OutTo -Filter "*$($filename)*" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
				$OutAny = $($_.fullname)
				break
			}
			Get-ChildItem -Path $OutTo -Filter "*$($packer)*" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
				$OutAny = $($_.fullname)
				break
			}
		}
	}

	Switch ($types)
	{
		zip
		{
			Switch ($act)
			{
				Install
				{
					Get-ChildItem -Path $OutTo -Filter "*$($filename)*$((Get-Culture).Name)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						Write-Host "    - 地域の存在：$($_.fullname)"
						OpenApp -filename $($_.fullname) -param $param -mode $mode -Before $Before -After $After
						break
					}
					Get-ChildItem -Path $OutTo -Filter "*$($filename)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						Write-Host "    - 地域の存在：$($_.fullname)"
						OpenApp -filename $($_.fullname) -param $param -mode $mode -Before $Before -After $After
						break
					}
					Get-ChildItem -Path $OutTo -Filter "*$($packer)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						Write-Host "   - $($lang.LocallyExist)`n     $($_.fullname)"
						OpenApp -filename $($_.fullname) -param $param -mode $mode -Before $Before -After $After
						break
					}
					if (Test-Path $OutAny) {
						Write-Host "    - 已有インストールパッケージ"
					} else {
						Write-Host "    * ダウンロード開始"
						if ([string]::IsNullOrEmpty($url)) {
							Write-Host "    - ダウンロードアドレスが無効です。" -ForegroundColor Red
						} else {
							if (TestURI $url) {
								Write-Host "      > に接続されています：`n        $url`n      + 保存する：`n        $OutAny"
								CheckCatalog -chkpath $OutTo
								Invoke-WebRequest -Uri $url -OutFile "$($OutAny)" -ErrorAction SilentlyContinue | Out-Null
							} else {
								Write-Host "      - ステータス：利用不可" -ForegroundColor Red
							}
						}
					}
					if (Test-Path $OutAny) {
						Write-Host "    - 開梱"
						Archive -Password $pwd -filename $OutAny -to $OutTo
						Write-Host "    - 解凍が完了しました"
						Remove-Item -path $OutAny -force -ErrorAction SilentlyContinue
					} else {
						Write-Host "      - ダウンロード中にエラーが発生しました`n" -ForegroundColor Red
					}
					Get-ChildItem -Path $OutTo -Filter "*$($filename)*$((Get-Culture).Name)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						Write-Host "    - 地域の存在：$($_.fullname)"
						OpenApp -filename $($_.fullname) -param $param -mode $mode -Before $Before -After $After
						break
					}
					Get-ChildItem -Path $OutTo -Filter "*$($filename)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						Write-Host "    - 地域の存在：$($_.fullname)"
						OpenApp -filename $($_.fullname) -param $param -mode $mode -Before $Before -After $After
						break
					}
					Get-ChildItem -Path $OutTo -Filter "*$($packer)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						Write-Host "   - $($lang.LocallyExist)`n     $($_.fullname)"
						OpenApp -filename $($_.fullname) -param $param -mode $mode -Before $Before -After $After
						break
					}
				}
				NoInst
				{
					if (Test-Path $OutAny) {
						Write-Host "    - インストール済み`n"
					} else {
						Write-Host "    * ダウンロード開始"
						if ([string]::IsNullOrEmpty($url)) {
							Write-Host "      - ダウンロードアドレスが無効です。" -ForegroundColor Red
						} else {
							if (TestURI $url) {
								Write-Host "      > に接続されています：`n        $url`n      + 保存する：`n        $OutAny"
								CheckCatalog -chkpath $OutTo
								Invoke-WebRequest -Uri $url -OutFile "$($OutAny)" -ErrorAction SilentlyContinue | Out-Null
							} else {
								Write-Host "      - ステータス：利用不可`n" -ForegroundColor Red
							}
						}
					}
				}
				To
				{
					$newoutputfoldoer = "$($OutTo)\$($packer)"
					if (Test-Path $newoutputfoldoer -PathType Container) {
						Write-Host "    - インストール済み`n"
						break
					}
					if (Test-Path $OutAny) {
						Write-Host "    - 利用可能な圧縮パッケージ"
					} else {
						Write-Host "    * ダウンロード開始"
						if ([string]::IsNullOrEmpty($url)) {
							Write-Host "      - ダウンロードアドレスが無効です。" -ForegroundColor Red
						} else {
							Write-Host "      > に接続されています：`n        $url`n      + 保存する：`n        $OutAny"
							Invoke-WebRequest -Uri $url -OutFile $OutAny -ErrorAction SilentlyContinue | Out-Null
						}
					}
					if (Test-Path $OutAny) {
						Write-Host "    - 解凍のみ"
						Archive -Password $pwd -filename $OutAny -to $newoutputfoldoer
						Write-Host "    - 解凍が完了しました`n"
						Remove-Item -path $OutAny -force -ErrorAction SilentlyContinue
					} else {
						Write-Host "      - ダウンロード中にエラーが発生しました`n" -ForegroundColor Red
					}
				}
				Unzip
				{
					if (Test-Path $OutAny) {
						Write-Host "    - 已有インストールパッケージ"
					} else {
						Write-Host "    * ダウンロード開始"
						if ([string]::IsNullOrEmpty($url)) {
							Write-Host "      - ダウンロードアドレスが無効です。" -ForegroundColor Red
						} else {
							if (TestURI $url) {
								Write-Host "      > に接続されています：`n        $url`n      + 保存する：`n        $OutAny"
								CheckCatalog -chkpath $OutTo
								Invoke-WebRequest -Uri $url -OutFile $OutAny -ErrorAction SilentlyContinue | Out-Null
							} else {
								Write-Host "      - ステータス：利用不可`n" -ForegroundColor Red
							}
						}
					}
					if (Test-Path $OutAny) {
						Write-Host "    - 解凍のみ`n"
						Archive -Password $pwd -filename $OutAny -to $OutTo
						Write-Host "    - 解凍が完了しました`n"
						Remove-Item -path $OutAny -force -ErrorAction SilentlyContinue
					} else {
						Write-Host "      - ダウンロード中にエラーが発生しました`n" -ForegroundColor Red
					}
				}
			}
		}
		default
		{
			if (Test-Path $OutAny -PathType Leaf) {
				OpenApp -filename $OutAny -param $param -mode $mode -Before $Before -After $After
			} else {
				Write-Host "    * ダウンロード開始"
				if ([string]::IsNullOrEmpty($url)) {
					Write-Host "      - ダウンロードアドレスが無効です。`n" -ForegroundColor Red
				} else {
					Write-Host "      > に接続されています：`n        $url"
					if (TestURI $url) {
						Write-Host "      + 保存する：`n        $OutAny"
						CheckCatalog -chkpath $OutTo
						Invoke-WebRequest -Uri $url -OutFile $OutAny -ErrorAction SilentlyContinue | Out-Null
						OpenApp -filename $OutAny -param $param -mode $mode -Before $Before -After $After
					} else {
						Write-Host "      - ステータス：利用不可`n" -ForegroundColor Red
					}
				}
			}
		}
	}
}

Function Archive
{
	param
	(
		$Password,
		$filename,
		$to
	)

	Convert-Path $filename -ErrorAction SilentlyContinue | Out-Null

	if (Compressing) {
		Write-host "    - 使用する $Global:Zip ソフトウェアを解凍します"
		if ([string]::IsNullOrEmpty($Password)) {
			$arguments = "x ""-r"" ""-tzip"" ""$filename"" ""-o$to"" ""-y"""
		} else {
			$arguments = "x ""-p$Password"" ""-r"" ""-tzip"" ""$filename"" ""-o$to"" ""-y"""
		}
		Start-Process $Global:Zip "$arguments" -Wait -WindowStyle Minimized
	} else {
		Write-host "    - システムに付属の減圧ソフトウェアを使用する"
		Expand-Archive -LiteralPath $filename -DestinationPath $to -force
	}
}

Function Compressing
{
	if (Test-Path "${env:ProgramFiles}\7-Zip\7z.exe" -PathType Leaf) {
		$Global:Zip = "${env:ProgramFiles}\7-Zip\7z.exe"
		return $true
	}

	if (Test-Path "${env:ProgramFiles(x86)}\7-Zip\7z.exe" -PathType Leaf) {
		$Global:Zip = "${env:ProgramFiles(x86)}\7-Zip\7z.exe"
		return $true
	}

	if (Test-Path "$($env:SystemDrive)\$($Global:UniqueID)\$($Global:UniqueID)\7zPacker\7z.exe" -PathType Leaf) {
		$Global:Zip = "$($env:SystemDrive)\$($Global:UniqueID)\$($Global:UniqueID)\7zPacker\7z.exe"
		return $true
	}
	return $false
}

Function WaitEnd
{
	Write-Host "`n   キューで待機中" -ForegroundColor Green
	for ($i=0; $i -lt $Global:AppQueue.Count; $i++) {
		Write-Host "    * PID: $($Global:AppQueue[$i]['ID'])".PadRight(22) -NoNewline
		if ((Get-Process -ID $($Global:AppQueue[$i]['ID']) -ErrorAction SilentlyContinue).Path -eq $Global:AppQueue[$i]['PATH']) {
			Wait-Process -id $($Global:AppQueue[$i]['ID']) -ErrorAction SilentlyContinue
		}
		Write-Host "    - 完了" -ForegroundColor Yellow
	}
	$Global:AppQueue = @()
}

Function OpenApp
{
	param
	(
		$filename,
		$param,
		$mode,
		$Before,
		$After
	)

	$Select = $After -split ":"
	switch ($Select[0])
	{
		1
		{
			$TestCfg = "$(Split-Path $filename)\$($Select[1]).$($Select[2])"
			$TestDefault = "$(Split-Path $filename)\$($Select[1]).default.$($Select[2])"
			$TestLanguage = "$(Split-Path $filename)\$($Select[1]).$((Get-Culture).Name).$($Select[2])"
			if (Test-Path $TestCfg -PathType Leaf){
				break
			} else {
				if (Test-Path $TestLanguage -PathType Leaf){
					Copy-Item -Path $TestLanguage -Destination $TestCfg -ErrorAction SilentlyContinue
				} else {
					if (Test-Path $TestDefault -PathType Leaf){
						Copy-Item -Path $TestDefault -Destination $TestCfg -ErrorAction SilentlyContinue
					}
				}
			}
		}
		default
		{
		}
	}

	if (Test-Path $filename -PathType Leaf) {
		Switch ($mode)
		{
			Fast
			{
				if ([string]::IsNullOrEmpty($param))
				{
					Write-Host "    - 高速実行：`n      $filename`n"
					Start-Process -FilePath $filename
				} else {
					Write-Host "    - 高速実行：`n      $filename`n    - パラメータ：`n      $param`n"
					Start-Process -FilePath $filename -ArgumentList $param
				}
			}
			Wait
			{
				if ([string]::IsNullOrEmpty($param))
				{
					Write-Host "    - 完了するのを待つ：`n      $filename`n"
					Start-Process -FilePath $filename -Wait
				} else {
					Write-Host "    - 完了するのを待つ：`n      $filename`n    - パラメータ：`n      $param`n"
					Start-Process -FilePath $filename -ArgumentList $param -Wait
				}
			}
			Queue
			{
				Write-Host "    - 高速実行：`n      $filename"
				if ([string]::IsNullOrEmpty($param))
				{
					$AppRunQueue = Start-Process -FilePath $filename -passthru
					$Global:AppQueue += @{
						ID="$($AppRunQueue.Id)";
						PATH="$($filename)"
					}
					Write-Host "    - キューの追加：$($AppRunQueue.Id)`n"
				} else {
					$AppRunQueue = Start-Process -FilePath $filename -ArgumentList $param -passthru
					$Global:AppQueue += @{
						ID="$($AppRunQueue.Id)";
						PATH="$($filename)"
					}
					Write-Host "    - パラメータ：`n      $param"
					Write-Host "    - キューの追加：$($AppRunQueue.Id)`n"
				}
			}
		}
	} else {
		Write-Host "    - インストールファイルが見つかりませんでした。整合性を確認してください。$filename`n" -ForegroundColor Red
	}
}

Function ToMainpage
{
	param
	(
		[int]$wait
	)
	Write-Host "`n   インストールスクリプトは $wait 数秒後に自動的に終了します。" -ForegroundColor Red
	Start-Sleep -s $wait
	exit
}

Function ObtainAndInstall
{
	Write-Host "`n   ソフトウェアのインストール`n   ---------------------------------------------------"
	for ($i=0; $i -lt $app.Count; $i++) {
		InstallProcess -appname $app[$i][0] -status $app[$i][1] -act $app[$i][2] -mode $app[$i][3] -todisk $app[$i][4] -structure $app[$i][5] -pwd $app[$i][6] -url $app[$i][7] -urlAMD64 $app[$i][8] -urlarm64 $app[$i][9] -filename $app[$i][10] -param $app[$i][11] -Before $app[$i][12] -After $app[$i][13]
	}
}

Function InstallGUI
{
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	$AllSel_Click = {
		$Pane1.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]){ $_.Checked = $true }
		}
	}
	$AllClear_Click = {
		$Pane1.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]){ $_.Checked = $false }
		}
	}
	$Canel_Click = {
		$Install.Hide()
		Write-Host "   ユーザーがインストールをキャンセルしました。" -ForegroundColor Red
		$Install.Close()
	}
	$OK_Click = {
		$Install.Hide()
		Initialization
		$Pane1.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Checked) {
					InstallProcess -appname $app[$_.Tag][0] -status "Enable" -act $app[$_.Tag][2] -mode $app[$_.Tag][3] -todisk $app[$_.Tag][4] -structure $app[$_.Tag][5] -pwd $app[$_.Tag][6] -url $app[$_.Tag][7] -urlAMD64 $app[$_.Tag][8] -urlarm64 $app[$_.Tag][9] -filename $app[$_.Tag][10] -param $app[$_.Tag][11] -Before $app[$_.Tag][12] -After $app[$_.Tag][13]
				}
			}
		}
		WaitEnd
		ProcessOther
		$Install.Close()
	}
	$Install           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = "ソフトウェアリストをインストールする ( 合計 $($app.Count) )"
		TopMost        = $False
		MaximizeBox    = $False
		StartPosition  = "CenterScreen"
		MinimizeBox    = $false
		BackColor      = "#ffffff"
		Font           = New-Object System.Drawing.Font("Microsoft YaHei", 9, [System.Drawing.FontStyle]::Regular)
	}
	$Pane1             = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 625
		Width          = 490
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $true
		Padding        = 8
		Dock           = 1
	}
	$Setting           = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "10,635"
		Height         = 36
		Width          = 133
		add_Click      = { SetupGUI }
		Text           = "設定"
	}
	$Start             = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "148,635"
		Height         = 36
		Width          = 184
		add_Click      = $OK_Click
		Text           = "決定"
	}
	$Canel             = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "337,635"
		Height         = 36
		Width          = 184
		add_Click      = $Canel_Click
		Text           = "キャンセル"
	}

	for ($i=0; $i -lt $app.Count; $i++)
	{
		$CheckBox  = New-Object System.Windows.Forms.CheckBox -Property @{
			Height = 28
			Width  = 405
			Text   = $app[$i][0]
			Tag    = $i
		}

		if ($app[$i][1] -like "Enable") {
			$CheckBox.Checked = $true
		} else {
			$CheckBox.Checked = $false
		}
		$Pane1.controls.AddRange($CheckBox)		
	}

	$Install.controls.AddRange((
		$Pane1,
		$AllSel,
		$AllClear,
		$Setting,
		$Start,
		$Canel
	))

	$SelectMenu = New-Object System.Windows.Forms.ContextMenuStrip
	$SelectMenu.Items.Add("すべて選択").add_Click($AllSel_Click)
	$SelectMenu.Items.Add("すべてクリア").add_Click($AllClear_Click)
	$Install.ContextMenuStrip = $SelectMenu

	$Install.FormBorderStyle = 'Fixed3D'
	$Install.ShowDialog() | Out-Null
}

Function ShowList
{
	for ($i=0; $i -lt $app.Count; $i++)
	{
		Switch ($app[$i][1])
		{
			Enable
			{
				Write-Host "   インストールを待っています - $($app[$i][0])" -ForegroundColor Green
			}
			Disable
			{
				Write-Host "   インストールをスキップ     - $($app[$i][0])" -ForegroundColor Red
			}
		}
	}
}

Function Mainpage
{
	Clear-Host
	Write-Host "`n   Author: $($Global:UniqueID) ( $($Global:AuthorURL) )

   From: $($Global:UniqueID)'s Solutions
   buildstring: 8.0.0.2.bs_release.220201-1208

   ソフトウェアリストをインストールする ( 合計 $($app.Count) )`n   ---------------------------------------------------"
}

$GroupCleanRun = @(
	"Wechat"
	"HCDNClient"
	"qqlive"
	"cloudmusic"
	"QQMusic"
	"Thunder"
)

Function CleanRun {
	Write-Host "   - スタートアップアイテムを削除する"
	foreach ($nsf in $GroupCleanRun) {
		Remove-ItemProperty -Name $nsf -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue | Out-Null
	}
}

Function ProcessOther
{
	Write-Host "`n   その他の処理：" -ForegroundColor Green

	CleanRun

	Write-Host "   - スケジュールされたタスクを無効にする"
	Disable-ScheduledTask -TaskName GoogleUpdateTaskMachineCore -ErrorAction SilentlyContinue | Out-Null
	Disable-ScheduledTask -TaskName GoogleUpdateTaskMachineUA -ErrorAction SilentlyContinue | Out-Null

	Write-Host "   - 冗長なショートカットを削除する"
	Set-Location "$env:public\Desktop"
	Remove-Item ".\Kleopatra.lnk" -Force -ErrorAction SilentlyContinue | Out-Null

	Write-Host "   - 名前を変更"
	#Rename-Item-NewName "グーグルクローム.lnk"  -Path ".\Google Chrome.lnk" -ErrorAction SilentlyContinue | Out-Null
}

Function initialization
{
}

Mainpage

If ($Force) {
	ShowList
	Initialization
	ObtainAndInstall
	WaitEnd
	ProcessOther
} else {
	InstallGUI
	if ($Silent) {
		exit
	} else {
		ToMainpage -wait 2
	}
}