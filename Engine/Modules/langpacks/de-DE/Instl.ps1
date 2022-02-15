<#

  PowerShell Installationssoftware

  . Die Hauptfunktion
    1. Das Installationspaket existiert nicht lokal, aktivieren Sie die Download Funktion;
    2. Wenn Sie die Download Funktion verwenden, beurteilt sie automatisch den Systemtyp, wählt automatisch in der Reihenfolge aus und so weiter;
    3. Laufwerksbuchstaben automatisch auswählen:
        3.1    Der Laufwerksbuchstabe kann angegeben werden und das aktuelle Systemlaufwerk wird nach der Einstellung automatisch ausgeschlossen.
               Wenn kein verfügbarer Datenträger gefunden wird, kehren Sie zum aktuellen Systemdatenträger zurück;
        3.2    Der minimal erforderliche verbleibende freie Speicherplatz kann eingestellt werden, der Standardwert beträgt 1 GB;
    4. Der Name der Suchdatei unterstützt die Fuzzy Suche, Platzhalter *；
    5. Warteschlange, nach dem Ausführen des Installationsprogramms zur Warteschlange hinzufügen und auf das Ende warten;
    6. Suchen Sie sequentiell gemäß der voreingestellten Struktur:
       * Ursprüngliche Downloadadresse: https://fengyi.tel/Instl.Packer.Latest.exe
         + Unscharfer Dateiname: Instl.Packer*
             Bedingung 1: Systemsprache: en-US, Suchbedingung: Instl.Packer*en-US*
           - Bedingung 2: Suche nach unscharfen Dateinamen: Instl.Packer*
           - Bedingung 3: Durchsuchen Sie die Website, um den ursprünglichen Dateinamen herunterzuladen: Instl.Packer.Latest
    7. Dynamische Funktion: Vorlauf und Nachlaufverarbeitung hinzufügen, zu Function OpenApp {} wechseln, um das Modul zu ändern;
    8. Unterstützen Sie die Verarbeitung von Dekompressionspaketen usw.

  . Voraussetzungen
    - PowerShell 5.1 oder höher

  . verbinden
  	- https://github.com/ilikeyi/powershell.install.software


  Tutorial zur Paketkonfiguration

 Softwarepaket                                            beschreiben
("Windows Defender Control",                              Paketname
 [Status]::Enable,                                        Status: Enable - Ermöglichen; Disable - Deaktivieren;
 [Action]::Install,                                       Aktion: Install - Installieren; NoInst - Nach dem Download nicht installieren; Unzip - Erst nach dem Download entpacken; To - In Verzeichnis installieren
 [Mode]::Wait,                                            Betriebsmodus: Wait - Warten Sie auf die Fertigstellung; Fast - Direkt laufen
 "auto",                                                  Nach der Einstellung automatisch wird die aktuelle Systemfestplatte ausgeschlossen. Wenn keine verfügbare Festplatte gefunden wird, ist die Standardeinstellung die aktuelle Systemfestplatte; geben Sie den Laufwerksbuchstaben an [A:]-[Z:]; Geben Sie den Pfad an: \\192.168.1.1
 "Installationspaket\Tools",                              Verzeichnisaufbau
 "sordum",                                                Komprimiertes Paket-Dekomprimierungskennwort
 "https://www.sordum.org/files/download/d-control/dControl.zip", Standard, einschließlich x86-Download-Adresse
 "",                                                      x64 Download-Link
 "",                                                      Arm64 Download-Link
 "dfControl*",                                            Fuzzy-Suche nach Dateinamen (*)
 "/D",                                                    Betriebsparameter
 "",                                                      Vor dem Laufen
 "")                                                      Nach dem Ausführen: Wählen Sie Schema 1; dfControl = Name der Konfigurationsdatei; ini = Typ, gehen Sie zu Funktion OpenApp {}, um das Modul zu ändern

 .Erstellen Sie eine Konfigurationsdatei

 - Standard
   Kopieren Sie dfControl.ini und wechseln Sie zu dfControl.Default.ini

 - Englisch
   Kopieren Sie dfControl.ini und wechseln Sie zu dfControl.en-US.ini
   Öffnen Sie dfControl.en-US.ini und ändern Sie Language=Auto in Language=English

 - Chinesisch
   Kopieren Sie dfControl.ini und ändern Sie es in dfControl.zh-CN.ini
   Öffnen Sie dfControl.zh-CN.ini und ändern Sie Language=Auto in Language=Chinese_Simplified Chinese

   Löschen Sie dfControl.ini, nachdem Sie es erstellt haben.

#>

#Requires -version 5.1

# Skriptparameter abrufen ( falls vorhanden )
[CmdletBinding()]
param
(
	[Switch]$Force,
	[Switch]$Silent
)

# Autor
$Global:UniqueID  = "Yi"
$Global:AuthorURL = "https://fengyi.tel"

# Initialisieren und wählen Sie automatisch die minimale Festplattengröße: 1 GB
$Global:DiskMinSize = 1

# Warteschlange zurücksetzen
$Global:AppQueue = @()

# Titel
$Host.UI.RawUI.WindowTitle = "Software installieren"

# Alle Softwarekonfigurationen
$app = @(
	("$($Global:UniqueID)'s Themenpaket Dunkle Persönlichkeit",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Fast,
	 "auto",
	 "Installationspaket\THEMENPAKET",
	 "",
	 "$($Global:AuthorURL)/$($Global:UniqueID).deskthemepack",
	 "",
	 "",
	 "$($Global:UniqueID)*",
	 "",
	 "",
	 ""),
	("$($Global:UniqueID)'s Themenpaket mit heller Persönlichkeit",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Fast,
	 "auto",
	 "Installationspaket\THEMENPAKET",
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
	 "Installationspaket\TREIBER\Grafikkarte",
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
	 "Installationspaket\AIO",
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
	 "Installationspaket\AIO",
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
	 "Installationspaket\SOFTWARE ENTWICKELN",
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
	 "Installationspaket\Bürosoftware",
	 "",
	 "https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/onlinesetup/distsrc/600.1002/wpsinst/wps_office_inst.exe",
	 "",
	 "",
	 "wps*",
	 "",
	 "",
	 ""),
	("Kugou Musik",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "Installationspaket\MUSIKSOFTWARE",
	 "",
	 "https://downmini.yun.kugou.com/web/kugou10021.exe",
	 "",
	 "",
	 "kugou*",
	 "/S",
	 "",
	 ""),
	("NetEase Cloud-Musik",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "Installationspaket\MUSIKSOFTWARE",
	 "",
	 "https://d1.music.126.net/dmusic/cloudmusicsetup2.9.5.199424.exe",
	 "",
	 "",
	 "cloudmusicsetup*",
	 "/S",
	 "",
	 ""),
	("QQ Musik",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "Installationspaket\MUSIKSOFTWARE",
	 "",
	 "https://dldir1.qq.com/music/clntupate/QQMusicSetup.exe",
	 "",
	 "",
	 "QQMusicSetup",
	 "",
	 "",
	 ""),
	("Donner 11",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "Installationspaket\Download Tool",
	 "",
	 "https://down.sandai.net/thunder11/XunLeiWebSetup11.2.6.1790gw.exe",
	 "",
	 "",
	 "XunLeiWebSetup11*",
	 "/S",
	 "",
	 ""),
	("Tencent QQ",
	 [Status]::Enable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "Installationspaket\soziale Anwendung",
	 "",
	 "https://down.qq.com/qqweb/PCQQ/PCQQ_EXE/QQ9.5.2.27905.exe",
	 "",
	 "",
	 "PCQQ2021",
	 "/S",
	 "",
	 ""),
	("WeChat",
	 [Status]::Enable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "Installationspaket\soziale Anwendung",
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
	 "Installationspaket\ONLINE TV",
	 "",
	 "https://dldir1.qq.com/qqtv/TencentVideo11.32.2015.0.exe",
	 "",
	 "",
	 "TencentVideo*",
	 "/S",
	 "",
	 ""),
	("Iqiyi Video",
	 [Status]::Disable,
	 [Action]::Install,
	 [Mode]::Queue,
	 "auto",
	 "Installationspaket\ONLINE TV",
	 "",
	 "https://dl-static.iqiyi.com/hz/IQIYIsetup_z40.exe",
	 "",
	 "",
	 "IQIYIsetup*",
	 "/S",
	 "",
	 "")
)
# Last ) Verwenden Sie nicht das, am Ende, sonst werden Sie es verstehen.

# Zustand
Enum Status
{
	Enable
	Disable
}

# Laufmodus
Enum Mode
{
	Wait    # warte auf Fertigstellung
	Fast    # direkt laufen
	Queue   # Warteschlange
}

<#
	.Aktion ausführen
#>
Enum Action
{
	Install # Installieren
	NoInst  # Nach dem Download nicht installieren
	To      # Laden Sie das komprimierte Paket in das Verzeichnis herunter
	Unzip   # Erst nach dem Download entpacken
}

<#
	.Systemstruktur
#>
Function GetArchitecture
{
	<#
		.Aus der Registry beziehen: benutzerspezifische Systemarchitektur
	#>
	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "Architecture" -ErrorAction SilentlyContinue) {
		$Global:InstlArchitecture = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "Architecture"
		return
	}

	<#
		.Initialisierung: Systemarchitektur
	#>
	SetArchitecture -Type $env:PROCESSOR_ARCHITECTURE
}

<#
	.Einrichten der Systemarchitektur
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
	.Automatisch Datenträger auswählen
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
		.Festplattenbedingungen durchsuchen, Systemfestplatten ausschließen
	#>
	$drives = Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | Where-Object { -not ((JoinMainFolder -Path $env:SystemDrive) -eq $_.Root) } | Select-Object -ExpandProperty 'Root'

	<#
		.Holen Sie sich aus der Registrierung, ob der freie Speicherplatz auf der Festplatte überprüft werden soll
	#>
	$GetDiskStatus = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskStatus"

	<#
		.Holen Sie sich die ausgewählte Festplatte aus der Registrierung
	#>
	$GetDiskMinSize = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Install" -Name "DiskMinSize"

	<#
		.Festplattenbedingungen durchsuchen, Systemfestplatten ausschließen
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
		.Keine verfügbare Festplatte gefunden, Initialisierung: aktuelle Systemfestplatte
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
	.Holen Sie sich die ausgewählte Festplatte aus der Registrierung und beurteilen Sie, ob die Festplatte eingestellt werden muss, überspringen Sie die Überprüfung des verbleibenden Festplattenspeichers, fahren Sie fort
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
	.Holen Sie sich aus der Registrierung, ob der freie Speicherplatz auf der Festplatte überprüft werden soll
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
	.Verfügbare Festplatte einstellen
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
	.Überprüfen Sie die verfügbare Festplattengröße
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
	.Speicherplatzgröße konvertieren
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
		$SoftwareTipsErrorMsg.Text = "Bevorzugen Sie die arm64 Downloadadresse, wählen Sie in der Reihenfolge: x64, x86."
	}
	$OK_ArchitectureAMD64_Click = {
		$SoftwareTipsErrorMsg.Text = "Bevorzugen Sie den x64 Download Speicherort, wählen Sie in der Reihenfolge: x86."
	}
	$OK_ArchitectureX86_Click = {
		$SoftwareTipsErrorMsg.Text = "Wählen Sie nur die x86 Downloadadresse aus."
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
		$ErrorMsg.Text = "Fehler: Standardmäßig kein Datenträger ausgewählt"
	}
	$FormSelectDiSK    = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = "installieren"
		TopMost        = $False
		MaximizeBox    = $False
		StartPosition  = "CenterScreen"
		MinimizeBox    = $false
		BackColor      = "#ffffff"
	}
	$ArchitectureTitle = New-Object System.Windows.Forms.Label -Property @{
		Height         = 22
		Width          = 490
		Text           = "Bevorzugte Downloadadresse"
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
		Text           = "Wenn die verfügbare Festplatte automatisch ausgewählt wird"
		Location       = '10,115'
	}
	$FormSelectDiSKLowSize = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 400
		Text           = "Überprüfe den niedrigsten verfügbaren freien Speicherplatz"
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
		Text           = "Datenträger standardmäßig verwenden ( Aktualisieren )"
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
		Text           = "Bestätigen"
	}
	$Canel             = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "8,635"
		Height         = 36
		Width          = 515
		add_Click      = $Canel_Click
		Text           = "Abbrechen"
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
			Write-Host "    - Verzeichnis konnte nicht erstellt werden: $($chkpath)`n" -ForegroundColor Red
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
			Write-Host "   Installing                - $($appname)" -ForegroundColor Green
		}
		Disable
		{
			Write-Host "   Installation überspringen - $($appname)" -ForegroundColor Red
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
						Write-Host "    - Lokal vorhanden: $($_.fullname)"
						OpenApp -filename $($_.fullname) -param $param -mode $mode -Before $Before -After $After
						break
					}
					Get-ChildItem -Path $OutTo -Filter "*$($filename)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						Write-Host "    - Lokal vorhanden: $($_.fullname)"
						OpenApp -filename $($_.fullname) -param $param -mode $mode -Before $Before -After $After
						break
					}
					Get-ChildItem -Path $OutTo -Filter "*$($packer)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						Write-Host "   - $($lang.LocallyExist)`n     $($_.fullname)"
						OpenApp -filename $($_.fullname) -param $param -mode $mode -Before $Before -After $After
						break
					}
					if (Test-Path $OutAny) {
						Write-Host "    - Vorhandenes Installationspaket"
					} else {
						Write-Host "    * Starte Download"
						if ([string]::IsNullOrEmpty($url)) {
							Write-Host "    - Die Download-Adresse ist ungültig." -ForegroundColor Red
						} else {
							if (TestURI $url) {
								Write-Host "      > Angeschlossen: `n        $url`n      + Speichern unter:`n        $OutAny"
								CheckCatalog -chkpath $OutTo
								Invoke-WebRequest -Uri $url -OutFile "$($OutAny)" -ErrorAction SilentlyContinue | Out-Null
							} else {
								Write-Host "      - Status: nicht verfügbar" -ForegroundColor Red
							}
						}
					}
					if (Test-Path $OutAny) {
						Write-Host "    - Auspacken"
						Archive -Password $pwd -filename $OutAny -to $OutTo
						Write-Host "    - Dekompression ist abgeschlossen"
						Remove-Item -path $OutAny -force -ErrorAction SilentlyContinue
					} else {
						Write-Host "      - Beim Download ist ein Fehler aufgetreten`n" -ForegroundColor Red
					}
					Get-ChildItem -Path $OutTo -Filter "*$($filename)*$((Get-Culture).Name)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						Write-Host "    - Lokal vorhanden: $($_.fullname)"
						OpenApp -filename $($_.fullname) -param $param -mode $mode -Before $Before -After $After
						break
					}
					Get-ChildItem -Path $OutTo -Filter "*$($filename)*.exe" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
						Write-Host "    - Lokal vorhanden: $($_.fullname)"
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
						Write-Host "    - Eingerichtet`n"
					} else {
						Write-Host "    * Starte Download"
						if ([string]::IsNullOrEmpty($url)) {
							Write-Host "      - Die Download-Adresse ist ungültig." -ForegroundColor Red
						} else {
							if (TestURI $url) {
								Write-Host "      > Angeschlossen: `n        $url`n      + Speichern unter:`n        $OutAny"
								CheckCatalog -chkpath $OutTo
								Invoke-WebRequest -Uri $url -OutFile "$($OutAny)" -ErrorAction SilentlyContinue | Out-Null
							} else {
								Write-Host "      - Status: nicht verfügbar`n" -ForegroundColor Red
							}
						}
					}
				}
				To
				{
					$newoutputfoldoer = "$($OutTo)\$($packer)"
					if (Test-Path $newoutputfoldoer -PathType Container) {
						Write-Host "    - Eingerichtet`n"
						break
					}
					if (Test-Path $OutAny) {
						Write-Host "    - Komprimiertes Paket verfügbar"
					} else {
						Write-Host "    * Starte Download"
						if ([string]::IsNullOrEmpty($url)) {
							Write-Host "      - Die Download-Adresse ist ungültig." -ForegroundColor Red
						} else {
							Write-Host "      > Angeschlossen: `n        $url`n      + Speichern unter:`n        $OutAny"
							Invoke-WebRequest -Uri $url -OutFile $OutAny -ErrorAction SilentlyContinue | Out-Null
						}
					}
					if (Test-Path $OutAny) {
						Write-Host "    - Nur entpacken"
						Archive -Password $pwd -filename $OutAny -to $newoutputfoldoer
						Write-Host "    - Dekompression ist abgeschlossen`n"
						Remove-Item -path $OutAny -force -ErrorAction SilentlyContinue
					} else {
						Write-Host "      - Beim Download ist ein Fehler aufgetreten`n" -ForegroundColor Red
					}
				}
				Unzip
				{
					if (Test-Path $OutAny) {
						Write-Host "    - Vorhandenes Installationspaket"
					} else {
						Write-Host "    * Starte Download"
						if ([string]::IsNullOrEmpty($url)) {
							Write-Host "      - Die Download-Adresse ist ungültig." -ForegroundColor Red
						} else {
							if (TestURI $url) {
								Write-Host "      > Angeschlossen: `n        $url`n      + Speichern unter:`n        $OutAny"
								CheckCatalog -chkpath $OutTo
								Invoke-WebRequest -Uri $url -OutFile $OutAny -ErrorAction SilentlyContinue | Out-Null
							} else {
								Write-Host "      - Status: nicht verfügbar`n" -ForegroundColor Red
							}
						}
					}
					if (Test-Path $OutAny) {
						Write-Host "    - Nur entpacken`n"
						Archive -Password $pwd -filename $OutAny -to $OutTo
						Write-Host "    - Dekompression ist abgeschlossen`n"
						Remove-Item -path $OutAny -force -ErrorAction SilentlyContinue
					} else {
						Write-Host "      - Beim Download ist ein Fehler aufgetreten`n" -ForegroundColor Red
					}
				}
			}
		}
		default
		{
			if (Test-Path $OutAny -PathType Leaf) {
				OpenApp -filename $OutAny -param $param -mode $mode -Before $Before -After $After
			} else {
				Write-Host "    * Starte Download"
				if ([string]::IsNullOrEmpty($url)) {
					Write-Host "      - Die Download-Adresse ist ungültig.`n" -ForegroundColor Red
				} else {
					Write-Host "      > Angeschlossen: `n        $url"
					if (TestURI $url) {
						Write-Host "      + Speichern unter:`n        $OutAny"
						CheckCatalog -chkpath $OutTo
						Invoke-WebRequest -Uri $url -OutFile $OutAny -ErrorAction SilentlyContinue | Out-Null
						OpenApp -filename $OutAny -param $param -mode $mode -Before $Before -After $After
					} else {
						Write-Host "      - Status: nicht verfügbar`n" -ForegroundColor Red
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
		Write-host "    - benutzen $Global:Zip Software entpacken"
		if ([string]::IsNullOrEmpty($Password)) {
			$arguments = "x ""-r"" ""-tzip"" ""$filename"" ""-o$to"" ""-y"""
		} else {
			$arguments = "x ""-p$Password"" ""-r"" ""-tzip"" ""$filename"" ""-o$to"" ""-y"""
		}
		Start-Process $Global:Zip "$arguments" -Wait -WindowStyle Minimized
	} else {
		Write-host "    - Verwenden Sie die mit dem System gelieferte Dekompressionssoftware"
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
	Write-Host "`n   In der Schlange warten" -ForegroundColor Green
	for ($i=0; $i -lt $Global:AppQueue.Count; $i++) {
		Write-Host "    * PID: $($Global:AppQueue[$i]['ID'])".PadRight(22) -NoNewline
		if ((Get-Process -ID $($Global:AppQueue[$i]['ID']) -ErrorAction SilentlyContinue).Path -eq $Global:AppQueue[$i]['PATH']) {
			Wait-Process -id $($Global:AppQueue[$i]['ID']) -ErrorAction SilentlyContinue
		}
		Write-Host "    - abgeschlossen" -ForegroundColor Yellow
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
					Write-Host "    - SCHNELLER LAUF: `n      $filename`n"
					Start-Process -FilePath $filename
				} else {
					Write-Host "    - SCHNELLER LAUF: `n      $filename`n    - PARAMETER: `n      $param`n"
					Start-Process -FilePath $filename -ArgumentList $param
				}
			}
			Wait
			{
				if ([string]::IsNullOrEmpty($param))
				{
					Write-Host "    - AUF ABSCHLUSS WARTEN: `n      $filename`n"
					Start-Process -FilePath $filename -Wait
				} else {
					Write-Host "    - AUF ABSCHLUSS WARTEN: `n      $filename`n    - PARAMETER: `n      $param`n"
					Start-Process -FilePath $filename -ArgumentList $param -Wait
				}
			}
			Queue
			{
				Write-Host "    - SCHNELLER LAUF: `n      $filename"
				if ([string]::IsNullOrEmpty($param))
				{
					$AppRunQueue = Start-Process -FilePath $filename -passthru
					$Global:AppQueue += @{
						ID="$($AppRunQueue.Id)";
						PATH="$($filename)"
					}
					Write-Host "    - WARTESCHLANGE HINZUFÜGEN: $($AppRunQueue.Id)`n"
				} else {
					$AppRunQueue = Start-Process -FilePath $filename -ArgumentList $param -passthru
					$Global:AppQueue += @{
						ID="$($AppRunQueue.Id)";
						PATH="$($filename)"
					}
					Write-Host "    - PARAMETER: `n      $param"
					Write-Host "    - WARTESCHLANGE HINZUFÜGEN: $($AppRunQueue.Id)`n"
				}
			}
		}
	} else {
		Write-Host "    - Es wurden keine Installationsdateien gefunden, bitte überprüfen Sie die Integrität: $filename`n" -ForegroundColor Red
	}
}

Function ToMainpage
{
	param
	(
		[int]$wait
	)
	Write-Host "`n   Das Installationsskript wird in $wait Nach Sekunden automatisch beenden." -ForegroundColor Red
	Start-Sleep -s $wait
	exit
}

Function ObtainAndInstall
{
	Write-Host "`n   Software installieren`n   ---------------------------------------------------"
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
		Write-Host "   Der Benutzer hat die Installation abgebrochen." -ForegroundColor Red
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
		Text           = "Softwareliste installieren ( Insgesamt $($app.Count) )"
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
		Text           = "installieren"
	}
	$Start             = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "148,635"
		Height         = 36
		Width          = 184
		add_Click      = $OK_Click
		Text           = "bestimmen"
	}
	$Canel             = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "337,635"
		Height         = 36
		Width          = 184
		add_Click      = $Canel_Click
		Text           = "Stornieren"
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
	$SelectMenu.Items.Add("Wählen Sie Alle").add_Click($AllSel_Click)
	$SelectMenu.Items.Add("Alles löschen").add_Click($AllClear_Click)
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
				Write-Host "   Warten auf Installation   - $($app[$i][0])" -ForegroundColor Green
			}
			Disable
			{
				Write-Host "   Installation überspringen - $($app[$i][0])" -ForegroundColor Red
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

   Softwareliste installieren ( Insgesamt $($app.Count) )`n   ---------------------------------------------------"
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
	Write-Host "   - Startobjekte löschen"
	foreach ($nsf in $GroupCleanRun) {
		Remove-ItemProperty -Name $nsf -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue | Out-Null
	}
}

Function ProcessOther
{
	Write-Host "`n   Verarbeitung Sonstiges:" -ForegroundColor Green

	CleanRun

	Write-Host "   - Geplante Aufgaben deaktivieren"
	Disable-ScheduledTask -TaskName GoogleUpdateTaskMachineCore -ErrorAction SilentlyContinue | Out-Null
	Disable-ScheduledTask -TaskName GoogleUpdateTaskMachineUA -ErrorAction SilentlyContinue | Out-Null

	Write-Host "   - Überflüssige Verknüpfungen löschen"
	Set-Location "$env:public\Desktop"
	Remove-Item ".\Kleopatra.lnk" -Force -ErrorAction SilentlyContinue | Out-Null

	Write-Host "   - Umbenennen"
	#Rename-Item-NewName "Google Chrome.lnk"  -Path ".\Google Chrome.lnk" -ErrorAction SilentlyContinue | Out-Null
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