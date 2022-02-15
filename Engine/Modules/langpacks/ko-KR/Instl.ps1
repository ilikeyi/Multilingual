<#

  PowerShell 설치 소프트웨어

  . 주요 기능
    1. 설치 패키지가 로컬에 존재하지 않습니다. 다운로드 기능을 활성화하십시오.
    2. 다운로드 기능을 사용할 때 자동으로 시스템 유형을 판단하고 자동으로 순서대로 선택하는 등의 작업을 수행합니다.
    3. 자동으로 드라이브 문자 선택:
        3.1    드라이브 문자를 지정할 수 있으며, 자동 설정 후 현재 시스템 드라이브는 제외됩니다.
               사용 가능한 디스크가 없으면 현재 시스템 디스크로 돌아갑니다.
        3.2    필요한 최소 여유 공간을 설정할 수 있으며 기본값은 1GB 입니다.
    4. 검색 파일 이름은 퍼지 검색, 와일드카드 *를 지원합니다.
    5. 대기열, 설치 프로그램 실행 후 대기열에 추가하고 끝날 때까지 기다립니다.
    6. 사전 설정된 구조에 따라 순차적으로 검색:
       * 원본 다운로드 주소: https://fengyi.tel/Instl.Packer.Latest.exe
         + 퍼지 파일 이름: Instl.Packer*
           - 조건 1: 시스템 언어: en-US, 검색 조건: Instl.Packer*en-US*
           - 조건 2: 퍼지 파일명 검색: Instl.Packer*
           - 조건 3: 웹사이트에서 검색하여 원본 파일명 다운로드: Instl.Packer.Latest
    7. 동적 기능: 실행 전 및 실행 후 처리를 추가하고 함수 OpenApp {}으로 이동하여 모듈을 변경합니다.
    8. 압축해제 패키지 처리 등 지원

  . 전제 조건
    - PowerShell 5.1 이상

  . 연결하다
    - https://github.com/ilikeyi/powershell.install.software


  패키지 구성 튜토리얼

 소프트웨어 패키지                                         설명하다
("Windows Defender Control",                              패키지 이름
 [Status]::Enable,                                        상태: Enable - 할 수있게하다; Disable - 장애를 입히다
 [Action]::Install,                                       행동: Install - 설치; NoInst - 다운로드 후 설치하지 마십시오; Unzip - 다운로드 후에만 압축을 풉니다; To - 디렉토리에 설치
 [Mode]::Wait,                                            작동 모드: Wait - 완료를 기다립니다; Fast - 직접 실행
 "auto",                                                  자동으로 설정하면 현재 시스템 디스크가 제외됩니다. 사용 가능한 디스크가 없으면 기본 설정은 현재 시스템 디스크입니다. 드라이브 문자 [A:]-[Z:]를 지정하고 경로를 지정하십시오: \\192.168. 1.1
 "설치 패키지\工具",                                           디렉토리 구조
 "sordum",                                                압축 패키지 압축 해제 암호
 "https://www.sordum.org/files/download/d-control/dControl.zip", 다운로드 주소를 포함한 기본값
 "",                                                      x64 다운로드 주소
 "",                                                      Arm64 다운로드 주소
 "dfControl*",                                            파일명 퍼지 검색 (*)
 "/D",                                                    작동 매개변수
 "",                                                      실행하기 전에
 "")                                                      실행 후 Function OpenApp{} 로 이동하고 모듈을 변경합니다.

 .구성 파일 만들기

 - 기본
   dfControl.ini 를 복사하고 dfControl.Default.ini 로 변경합니다.

 - 영어
   dfControl.ini 를 복사하고 dfControl.en-US.ini 로 변경합니다.
   dfControl.en-US.ini 를 열고 Language=Auto 를 Language=English 로 변경합니다.

 - 중국인
   dfControl.ini 를 복사하고 dfControl.zh-CN.ini 로 변경하십시오.
   dfControl.zh-CN.ini 를 열고 Language=Auto 를 Language=Chinese_Simplified Chinese 로 변경합니다.

   dfControl.ini 를 만든 후 삭제합니다.

#>

#Requires -version 5.1

# 스크립트 매개변수 가져오기(있는 경우)
[CmdletBinding()]
param
(
	[Switch]$Force,
	[Switch]$Silent
)

# 작가
$Global:UniqueID  = "Yi"
$Global:AuthorURL = "https://fengyi.tel"

# 최소 디스크 크기를 초기화하고 자동으로 선택: 1GB
$Global:DiskMinSize = 1

# 대기열 재설정
$Global:AppQueue = @()

# 제목
$Host.UI.RawUI.WindowTitle = "설치 소프트웨어"

# 모든 소프트웨어 구성
$app = @(
	("$($Global:UniqueID)'s 어두운 성격 테마 패키지",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Fast,
	 "auto",
	 "설치 패키지\테마 패키지",
	 "",
	 "$($Global:AuthorURL)/$($Global:UniqueID).deskthemepack",
	 "",
	 "",
	 "$($Global:UniqueID)*",
	 "",
	 "",
	 ""),
	("$($Global:UniqueID)'s 밝은 색상 개성 테마 팩",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Fast,
	 "auto",
	 "설치 패키지\테마 패키지",
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
	 "설치 패키지\드라이버\그래픽 카드",
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
	 "설치 패키지\AIO",
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
	 "설치 패키지\AIO",
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
	 "설치 패키지\소프트웨어를 개발하다",
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
	 "설치 패키지\사무용 소프트웨어",
	 "",
	 "https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/onlinesetup/distsrc/600.1002/wpsinst/wps_office_inst.exe",
	 "",
	 "",
	 "wps*",
	 "",
	 "",
	 ""),
	("쿠거우 음악",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "설치 패키지\음악 소프트웨어",
	 "",
	 "https://downmini.yun.kugou.com/web/kugou10021.exe",
	 "",
	 "",
	 "kugou*",
	 "/S",
	 "",
	 ""),
	("NetEase 클라우드 음악",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "설치 패키지\음악 소프트웨어",
	 "",
	 "https://d1.music.126.net/dmusic/cloudmusicsetup2.9.5.199424.exe",
	 "",
	 "",
	 "cloudmusicsetup*",
	 "/S",
	 "",
	 ""),
	("QQ 음악",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "설치 패키지\음악 소프트웨어",
	 "",
	 "https://dldir1.qq.com/music/clntupate/QQMusicSetup.exe",
	 "",
	 "",
	 "QQMusicSetup",
	 "",
	 "",
	 ""),
	("우뢰 11",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "설치 패키지\다운로드 도구",
	 "",
	 "https://down.sandai.net/thunder11/XunLeiWebSetup11.2.6.1790gw.exe",
	 "",
	 "",
	 "XunLeiWebSetup11*",
	 "/S",
	 "",
	 ""),
	("텐센트 QQ",
	 [Status]::Enable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "설치 패키지\소셜 애플리케이션",
	 "",
	 "https://down.qq.com/qqweb/PCQQ/PCQQ_EXE/QQ9.5.2.27905.exe",
	 "",
	 "",
	 "PCQQ2021",
	 "/S",
	 "",
	 ""),
	("위챗",
	 [Status]::Enable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "설치 패키지\소셜 애플리케이션",
	 "",
	 "https://dldir1.qq.com/weixin/Windows/WeChatSetup.exe",
	 "",
	 "",
	 "WeChatSetup",
	 "/S",
	 "",
	 ""),
	("텐센트 비디오",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "설치 패키지\온라인 TV",
	 "",
	 "https://dldir1.qq.com/qqtv/TencentVideo11.32.2015.0.exe",
	 "",
	 "",
	 "TencentVideo*",
	 "/S",
	 "",
	 ""),
	("이치이 비디오",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "설치 패키지\온라인 TV",
	 "",
	 "https://dl-static.iqiyi.com/hz/IQIYIsetup_z40.exe",
	 "",
	 "",
	 "IQIYIsetup*",
	 "/S",
	 "",
	 "")
)
# 마지막 ), 기호로 끝나지 마십시오. 그렇지 않으면 이해할 것입니다.

# 상태
Enum Status
{
	Enable
	Disable
}

# 실행 모드
Enum Mode
{
	Wait    # 완료를 기다립니다.
	Fast    # 직접 실행
	Queue   # 대기열
}

<#
	.실행 작업
#>
Enum Action
{
	Install # 설치
	NoInst  # 다운로드 후 설치하지 마세요
	To      # 압축된 패키지를 디렉토리에 다운로드
	Unzip   # 다운로드 후 압축 해제
}

<#
	.시스템 구조
#>
Function GetArchitecture
{
	<#
		.레지스트리에서 가져오기: 사용자 지정 시스템 아키텍처
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "Architecture" -ErrorAction SilentlyContinue) {
		$Global:InstlArchitecture = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "Architecture"
		return
	}

	<#
		.초기화: 시스템 아키텍처
	#>
	SetArchitecture -Type $env:PROCESSOR_ARCHITECTURE
}

<#
	.시스템 아키텍처 설정
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
	.자동으로 디스크 선택
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
		.디스크 조건 검색, 시스템 디스크 제외
	#>
	$drives = Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | Where-Object { -not ((JoinMainFolder -Path $env:SystemDrive) -eq $_.Root) } | Select-Object -ExpandProperty 'Root'

	<#
		.디스크 여유 공간을 확인할지 여부를 레지스트리에서 가져옵니다.
	#>
	$GetDiskStatus = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskStatus"

	<#
		.레지스트리에서 선택한 디스크 가져오기
	#>
	$GetDiskMinSize = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskMinSize"

	<#
		.디스크 조건 검색, 시스템 디스크 제외
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
		.사용 가능한 디스크를 찾을 수 없습니다. 초기화: 현재 시스템 디스크
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
	.레지스트리에서 선택한 디스크를 구하여 판단하여 강제로 디스크를 설정한 경우 남은 디스크 공간 확인을 건너뛰고 계속 진행
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
	.디스크 여유 공간을 확인할지 여부를 레지스트리에서 가져옵니다.
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
	.여유 디스크 설정
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
	.사용 가능한 디스크 크기 확인
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
	.디스크 공간 크기 변환
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
		$SoftwareTipsErrorMsg.Text = "arm64 다운로드 주소가 선호되며 x64, x86 순으로 선택합니다."
	}
	$OK_ArchitectureAMD64_Click = {
		$SoftwareTipsErrorMsg.Text = "X64 다운로드 주소가 선호되며 x86 순서로 선택하십시오."
	}
	$OK_ArchitectureX86_Click = {
		$SoftwareTipsErrorMsg.Text = "x86 다운로드 주소만 선택하십시오."
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
		$ErrorMsg.Text = "오류: 기본적으로 선택된 디스크가 없습니다."
	}
	$FormSelectDiSK    = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = "설정"
		TopMost        = $False
		MaximizeBox    = $False
		StartPosition  = "CenterScreen"
		MinimizeBox    = $false
		BackColor      = "#ffffff"
	}
	$ArchitectureTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 490
		Text           = "기본 다운로드 주소"
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
		Text           = "사용 가능한 디스크를 자동으로 선택하는 경우"
		Location       = '10,115'
	}
	$FormSelectDiSKLowSize = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 400
		Text           = "최소 여유 공간 확인"
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
		Text           = "기본적으로 디스크 사용 ( 새로 고치려면 클릭 )"
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
		Text           = "확인하다"
	}
	$Canel             = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "8,635"
		Height         = 36
		Width          = 515
		add_Click      = $Canel_Click
		Text           = "취소"
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
			Write-Host "    - 디렉토리 생성 실패: $($chkpath)`n" -ForegroundColor Red
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
			Write-Host "   설치 중      - $($appname)" -ForegroundColor Green
		}
		Disable
		{
			Write-Host "   설치 건너뛰기 - $($appname)" -ForegroundColor Red
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
						Write-Host "    - 로컬에 존재: $($_.fullname)"
						OpenApp -filename $($_.fullname) -param $param -mode $mode -Before $Before -After $After
						break
					}
					Get-ChildItem -Path $OutTo -Filter "*$($filename)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						Write-Host "    - 로컬에 존재: $($_.fullname)"
						OpenApp -filename $($_.fullname) -param $param -mode $mode -Before $Before -After $After
						break
					}
					Get-ChildItem -Path $OutTo -Filter "*$($packer)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						Write-Host "   - $($lang.LocallyExist)`n     $($_.fullname)"
						OpenApp -filename $($_.fullname) -param $param -mode $mode -Before $Before -After $After
						break
					}
					if (Test-Path $OutAny) {
						Write-Host "    - 기존 설치 패키지"
					} else {
						Write-Host "    * 다운로드를 시작하다"
						if ([string]::IsNullOrEmpty($url)) {
							Write-Host "    - 다운로드 주소가 잘못되었습니다." -ForegroundColor Red
						} else {
							if (TestURI $url) {
								Write-Host "      > 연결 대상:`n        $url`n      + 저장 위치:`n        $OutAny"
								CheckCatalog -chkpath $OutTo
								Invoke-WebRequest -Uri $url -OutFile "$($OutAny)" -ErrorAction SilentlyContinue | Out-Null
							} else {
								Write-Host "      - 상태: 사용할 수 없음" -ForegroundColor Red
							}
						}
					}
					if (Test-Path $OutAny) {
						Write-Host "    - 포장 풀기"
						Archive -Password $pwd -filename $OutAny -to $OutTo
						Write-Host "    - 감압 완료"
						Remove-Item -path $OutAny -force -ErrorAction SilentlyContinue
					} else {
						Write-Host "      - 다운로드 중 오류가 발생했습니다`n" -ForegroundColor Red
					}
					Get-ChildItem -Path $OutTo -Filter "*$($filename)*$((Get-Culture).Name)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						Write-Host "    - 로컬에 존재: $($_.fullname)"
						OpenApp -filename $($_.fullname) -param $param -mode $mode -Before $Before -After $After
						break
					}
					Get-ChildItem -Path $OutTo -Filter "*$($filename)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						Write-Host "    - 로컬에 존재: $($_.fullname)"
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
						Write-Host "    - 설치됨`n"
					} else {
						Write-Host "    * 다운로드를 시작하다"
						if ([string]::IsNullOrEmpty($url)) {
							Write-Host "      - 다운로드 주소가 잘못되었습니다." -ForegroundColor Red
						} else {
							if (TestURI $url) {
								Write-Host "      > 연결 대상:`n        $url`n      + 저장 위치:`n        $OutAny"
								CheckCatalog -chkpath $OutTo
								Invoke-WebRequest -Uri $url -OutFile "$($OutAny)" -ErrorAction SilentlyContinue | Out-Null
							} else {
								Write-Host "      - 상태: 사용할 수 없음`n" -ForegroundColor Red
							}
						}
					}
				}
				To
				{
					$newoutputfoldoer = "$($OutTo)\$($packer)"
					if (Test-Path $newoutputfoldoer -PathType Container) {
						Write-Host "    - 설치됨`n"
						break
					}
					if (Test-Path $OutAny) {
						Write-Host "    - 압축 패키지 사용 가능"
					} else {
						Write-Host "    * 다운로드를 시작하다"
						if ([string]::IsNullOrEmpty($url)) {
							Write-Host "      - 다운로드 주소가 잘못되었습니다." -ForegroundColor Red
						} else {
							Write-Host "      > 연결 대상:`n        $url`n      + 저장 위치:`n        $OutAny"
							Invoke-WebRequest -Uri $url -OutFile $OutAny -ErrorAction SilentlyContinue | Out-Null
						}
					}
					if (Test-Path $OutAny) {
						Write-Host "    - 압축만 풀기"
						Archive -Password $pwd -filename $OutAny -to $newoutputfoldoer
						Write-Host "    - 감압 완료`n"
						Remove-Item -path $OutAny -force -ErrorAction SilentlyContinue
					} else {
						Write-Host "      - 다운로드 중 오류가 발생했습니다`n" -ForegroundColor Red
					}
				}
				Unzip
				{
					if (Test-Path $OutAny) {
						Write-Host "    - 已有설치 패키지"
					} else {
						Write-Host "    * 다운로드를 시작하다"
						if ([string]::IsNullOrEmpty($url)) {
							Write-Host "      - 다운로드 주소가 잘못되었습니다." -ForegroundColor Red
						} else {
							if (TestURI $url) {
								Write-Host "      > 연결 대상:`n        $url`n      + 저장 위치:`n        $OutAny"
								CheckCatalog -chkpath $OutTo
								Invoke-WebRequest -Uri $url -OutFile $OutAny -ErrorAction SilentlyContinue | Out-Null
							} else {
								Write-Host "      - 상태: 사용할 수 없음`n" -ForegroundColor Red
							}
						}
					}
					if (Test-Path $OutAny) {
						Write-Host "    - 압축만 풀기`n"
						Archive -Password $pwd -filename $OutAny -to $OutTo
						Write-Host "    - 감압 완료`n"
						Remove-Item -path $OutAny -force -ErrorAction SilentlyContinue
					} else {
						Write-Host "      - 다운로드 중 오류가 발생했습니다`n" -ForegroundColor Red
					}
				}
			}
		}
		default
		{
			if (Test-Path $OutAny -PathType Leaf) {
				OpenApp -filename $OutAny -param $param -mode $mode -Before $Before -After $After
			} else {
				Write-Host "    * 다운로드를 시작하다"
				if ([string]::IsNullOrEmpty($url)) {
					Write-Host "      - 다운로드 주소가 잘못되었습니다.`n" -ForegroundColor Red
				} else {
					Write-Host "      > 연결 대상:`n        $url"
					if (TestURI $url) {
						Write-Host "      + 저장 위치:`n        $OutAny"
						CheckCatalog -chkpath $OutTo
						Invoke-WebRequest -Uri $url -OutFile $OutAny -ErrorAction SilentlyContinue | Out-Null
						OpenApp -filename $OutAny -param $param -mode $mode -Before $Before -After $After
					} else {
						Write-Host "      - 상태: 사용할 수 없음`n" -ForegroundColor Red
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
		Write-host "    - 사용 $Global:Zip 소프트웨어 압축 풀기"
		if ([string]::IsNullOrEmpty($Password)) {
			$arguments = "x ""-r"" ""-tzip"" ""$filename"" ""-o$to"" ""-y"""
		} else {
			$arguments = "x ""-p$Password"" ""-r"" ""-tzip"" ""$filename"" ""-o$to"" ""-y"""
		}
		Start-Process $Global:Zip "$arguments" -Wait -WindowStyle Minimized
	} else {
		Write-host "    - 시스템과 함께 제공되는 압축 해제 소프트웨어 사용"
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
	Write-Host "`n   대기열에서 대기 중" -ForegroundColor Green
	for ($i=0; $i -lt $Global:AppQueue.Count; $i++) {
		Write-Host "    * PID: $($Global:AppQueue[$i]['ID'])".PadRight(22) -NoNewline
		if ((Get-Process -ID $($Global:AppQueue[$i]['ID']) -ErrorAction SilentlyContinue).Path -eq $Global:AppQueue[$i]['PATH']) {
			Wait-Process -id $($Global:AppQueue[$i]['ID']) -ErrorAction SilentlyContinue
		}
		Write-Host "    - 완전한" -ForegroundColor Yellow
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
					Write-Host "    - 빠른 실행:`n      $filename`n"
					Start-Process -FilePath $filename
				} else {
					Write-Host "    - 빠른 실행:`n      $filename`n    - 매개변수:`n      $param`n"
					Start-Process -FilePath $filename -ArgumentList $param
				}
			}
			Wait
			{
				if ([string]::IsNullOrEmpty($param))
				{
					Write-Host "    - 완료 대기:`n      $filename`n"
					Start-Process -FilePath $filename -Wait
				} else {
					Write-Host "    - 완료 대기:`n      $filename`n    - 매개변수:`n      $param`n"
					Start-Process -FilePath $filename -ArgumentList $param -Wait
				}
			}
			Queue
			{
				Write-Host "    - 빠른 실행:`n      $filename"
				if ([string]::IsNullOrEmpty($param))
				{
					$AppRunQueue = Start-Process -FilePath $filename -passthru
					$Global:AppQueue += @{
						ID="$($AppRunQueue.Id)";
						PATH="$($filename)"
					}
					Write-Host "    - 대기열 추가: $($AppRunQueue.Id)`n"
				} else {
					$AppRunQueue = Start-Process -FilePath $filename -ArgumentList $param -passthru
					$Global:AppQueue += @{
						ID="$($AppRunQueue.Id)";
						PATH="$($filename)"
					}
					Write-Host "    - 매개변수:`n      $param"
					Write-Host "    - 대기열 추가: $($AppRunQueue.Id)`n"
				}
			}
		}
	} else {
		Write-Host "    - 설치 파일을 찾을 수 없습니다. 무결성을 확인하십시오: $filename`n" -ForegroundColor Red
	}
}

Function ToMainpage
{
	param
	(
		[int]$wait
	)
	Write-Host "`n   설치 스크립트는 다음 위치에 있습니다 $wait 몇 초 후에 자동으로 종료됩니다." -ForegroundColor Red
	Start-Sleep -s $wait
	exit
}

Function ObtainAndInstall
{
	Write-Host "`n   正在安装软件中`n   ---------------------------------------------------"
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
		Write-Host "   사용자가 설치를 취소했습니다." -ForegroundColor Red
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
		Text           = "소프트웨어 목록 설치 ( 총 $($app.Count) )"
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
		Text           = "설정"
	}
	$Start             = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "148,635"
		Height         = 36
		Width          = 184
		add_Click      = $OK_Click
		Text           = "결정"
	}
	$Canel             = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "337,635"
		Height         = 36
		Width          = 184
		add_Click      = $Canel_Click
		Text           = "취소"
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
	$SelectMenu.Items.Add("모두 선택").add_Click($AllSel_Click)
	$SelectMenu.Items.Add("모두 지우기").add_Click($AllClear_Click)
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
				Write-Host "   설치 대기 중  - $($app[$i][0])" -ForegroundColor Green
			}
			Disable
			{
				Write-Host "   설치 건너뛰기 - $($app[$i][0])" -ForegroundColor Red
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

   소프트웨어 목록 설치 ( 총 $($app.Count) )`n   ---------------------------------------------------"
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
	Write-Host "   - 시작 항목 삭제"
	foreach ($nsf in $GroupCleanRun) {
		Remove-ItemProperty -Name $nsf -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue | Out-Null
	}
}

Function ProcessOther
{
	Write-Host "`n   기타 처리:" -ForegroundColor Green

	CleanRun

	Write-Host "   - 예약된 작업 비활성화"
	Disable-ScheduledTask -TaskName GoogleUpdateTaskMachineCore -ErrorAction SilentlyContinue | Out-Null
	Disable-ScheduledTask -TaskName GoogleUpdateTaskMachineUA -ErrorAction SilentlyContinue | Out-Null

	Write-Host "   - 중복 바로 가기 삭제"
	Set-Location "$env:public\Desktop"
	Remove-Item ".\Kleopatra.lnk" -Force -ErrorAction SilentlyContinue | Out-Null

	Write-Host "   - 이름 바꾸기"
	#Rename-Item-NewName "구글 크롬.lnk"  -Path ".\Google Chrome.lnk" -ErrorAction SilentlyContinue | Out-Null
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