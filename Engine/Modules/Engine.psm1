<#
	.about us
	.关于我们
#>
Push-Location "$($PSScriptRoot)\..\..\"
$Global:UniqueMainFolder = $(Get-Location)
$Global:UniqueID = [IO.Path]::GetFileName($(Get-Location))
$Global:AuthorURL = "https://fengyi.tel"

<#
	.Log file name prefix
	.日志文件名前缀
#>
$Global:SaveTo = "Log-$(Get-Date -Format "yyyyMMddHHmmss")"

<#
	.Available languages
	.可用语言

	.Group type: 1. Language pack; 2. Language interface pack (LIP)
	.分组类型：1、语言包；2、语言界面包（LIP）

	https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/available-language-packs-for-windows
#>
$Global:AvailableLanguages = @(
	("1", "ar-SA",          "ar",              "Arabic - Saudi Arabia"),
	("1", "bg-BG",          "bg",              "Bulgarian (Bulgaria)"),
	("1", "zh-HK",          "hk",              "Chinese - Hong Kong SAR"),
	("1", "zh-CN",          "cn",              "Chinese - China"),
	("1", "zh-TW",          "tw",              "Chinese - Taiwan"),
	("1", "hr-HR",          "hr",              "Croatian (Croatia)"),
	("1", "cs-CZ",          "dz",              "Czech (Czech Republic)"),
	("1", "da-DK",          "dk",              "Danish (Denmark)"),
	("1", "nl-NL",          "nl",              "Dutch - Netherlands"),
	("1", "en-US",          "en",              "English - United States"),
	("1", "en-GB",          "gb",              "English - Great Britain"),
	("1", "et-EE",          "ee",              "Estonian (Estonia)"),
	("1", "fi-FI",          "fi",              "Finnish (Finland)"),
	("1", "fr-CA",          "ca",              "French - Canada"),
	("1", "fr-FR",          "fr",              "French - France"),
	("1", "de-DE",          "de",              "German - Germany"),
	("1", "el-GR",          "gr",              "Greek (Greece)"),
	("1", "he-IL",          "il",              "Hebrew (Israel)"),
	("1", "hu-HU",          "hu",              "Hungarian (Hungary)"),
	("1", "it-IT",          "it",              "Italian - Italy"),
	("1", "ja-JP",          "jp",              "Japanese (Japan)"),
	("1", "ko-KR",          "kr",              "Korean (Korea)"),
	("1", "lv-LV",          "lv",              "Latvian (Latvia)"),
	("1", "lt-LT",          "lt",              "Lithuanian (Lithuania)"),
	("1", "nb-NO",          "no",              "Norwegian (Bokm?l) (Norway)"),
	("1", "pl-PL",          "pl",              "Polish (Poland)"),
	("1", "pt-BR",          "br",              "Portuguese - Brazil"),
	("1", "pt-PT",          "pt",              "Portuguese - Portugal"),
	("1", "ro-RO",          "ro",              "Romanian (Romania)"),
	("1", "ru-RU",          "ru",              "Russian (Russia)"),
	("1", "sk-SK",          "sk",              "Slovak (Slovakia)"),
	("1", "sl-SI",          "si",              "Slovenian (Slovenia)"),
	("1", "es-MX",          "mx",              "Spanish (Mexico)"),
	("1", "es-ES",          "es-ES",           "Spanish (Castilian)"),
	("1", "sv-SE",          "se",              "Swedish (Sweden)"),
	("1", "th-TH",          "th",              "Thai (Thailand)"),
	("1", "tr-TR",          "tr",              "Turkish (Turkey)"),
	("1", "uk-UA",          "ua",              "Ukrainian (Ukraine)"),
	("2", "af-za",          "af",              "Afrikaans (South Africa)"),
	("2", "am-et",          "am-et",           "Amharic (Ethiopia)	"),
	("2", "as-in",          "as-in",           "Assamese (India)"),
	("2", "az-latn-az",     "az-latn-az",      "Azerbaijan"),
	("2", "be-by",          "be-by",           "Belarusian (Belarus)"),
	("2", "bn-bd",          "bn-bd",           "Bangla (Bangladesh)"),
	("2", "bn-in",          "bn-in",           "Bangla (India)"),
	("2", "bs-latn-ba",     "bs-latn-ba",      "Bosnian (Latin)"),
	("2", "ca-es",          "ca-es",           "Catalan (Spain)"),
	("2", "ca-es-valencia", "ca-es-valencia",  "Valencian"),
	("2", "chr-cher-us",    "chr-cher-us",     "Cherokee"),
	("2", "cy-gb",          "cy",              "Welsh (United Kingdom)"),
	("2", "eu-es",          "eu-es",           "Basque (Spain)"),
	("2", "fa-ir",          "fa",              "Farsi (Iran)"),
	("2", "fil-ph",         "fil-ph",          "Filipino"),
	("2", "ga-ie",          "ga-ie",           "Irish (Ireland)"),
	("2", "gd-gb",          "gd-gb",           "Scottish Gaelic	"),
	("2", "gl-es",          "gl",              "Galician (Spain)"),
	("2", "gu-in",          "gu",              "Gujarati (India)"),
	("2", "ha-latn-ng",     "ha-latn-ng",      "Hausa (Latin, Nigeria)"),
	("2", "hi-in",          "hi",              "Hindi (India)"),
	("2", "hy-am",          "hy",              "Armenian (Armenia)"),
	("2", "id-id",          "id",              "Indonesian (Indonesia)"),
	("2", "ig-ng",          "ig-ng",           "Igbo (Nigeria)"),
	("2", "is-is",          "is",              "Icelandic (Iceland)"),
	("2", "ka-ge",          "ka",              "Georgian (Georgia)"),
	("2", "kk-kz",          "kk",              "Kazakh (Kazakhstan)"),
	("2", "km-kh",          "km-kh",           "Khmer (Cambodia)"),
	("2", "kn-in",          "kn",              "Kannada (India)"),
	("2", "kok-in",         "kok",             "Konkani (India)"),
	("2", "ku-arab-iq",     "ku-arab-iq",      "Central Kurdish"),
	("2", "ky-kg",          "ky",              "Kyrgyz (Kyrgyzstan)"),
	("2", "lb-lu",          "lb-lu",           "Luxembourgish (Luxembourg)"),
	("2", "lo-la",          "lo-la",           "Lao (Laos)"),
	("2", "mi-nz",          "mi",              "Maori (New Zealand)"),
	("2", "mk-mk",          "mk",              "FYRO Macedonian"),
	("2", "ml-in",          "ml-in",           "Malayalam (India)"),
	("2", "mn-mn",          "mn",              "Mongolian (Mongolia)"),
	("2", "mr-in",          "mr",              "Marathi (India)"),
	("2", "ms-my",          "ms-my",           "Malay (Malaysia)"),
	("2", "mt-mt",          "mt",              "Maltese (Malta)"),
	("2", "ne-np",          "ne-np",           "Nepali (Federal Democratic Republic of Nepal)"),
	("2", "nn-no",          "nn-no",           "Norwegian (Nynorsk) (Norway)"),
	("2", "nso-za",         "nso-za",          "Sesotho sa Leboa (South Africa)"),
	("2", "or-in",          "or-in",           "Odia (India)"),
	("2", "pa-arab-pk",     "pa-arab-pk",      "pa-arab-pk"),
	("2", "pa-in",          "pa",              "Punjabi (India)"),
	("2", "prs-af",         "prs-af",          "Dari"),
	("2", "quc-latn-gt",    "quc-latn-gt",     "K'iche' (Guatemala)"),
	("2", "quz-pe",         "quz-pe",          "Quechua (Peru)"),
	("2", "rw-rw",          "rw-rw",           "Kinyarwanda"),
	("2", "sd-arab-pk",     "sd-arab-pk",      "Sindhi (Arabic)"),
	("2", "si-lk",          "si-lk",           "Sinhala (Sri Lanka)"),
	("2", "sq-al",          "sq",              "Albanian (Albania)"),
	("2", "sr-cyrl-ba",     "sr-cyrl-ba",      "Serbian (Cyrillic, Bosnia and Herzegovina)"),
	("2", "sr-cyrl-rs",     "sr-cyrl-rs",      "Serbian (Cyrillic, Serbia)"),
	("2", "sr-latn-rs",     "sr-latn-rs",      "Serbian (Latin, Serbia)"),
	("2", "sw-ke",          "sw-ke",           "Kiswahili (Kenya)"),
	("2", "ta-in",          "ta-in",           "Tamil (India)"),
	("2", "te-in",          "te-in",           "Telugu (India)"),
	("2", "tg-cyrl-tj",     "tg-cyrl-tj",      "Tajik (Cyrillic)"),
	("2", "ti-et",          "ti-et",           "Tigrinya"),
	("2", "tk-tm",          "tk-tm",           "Turkmen"),
	("2", "tn-za",          "tn-za",           "Tswana (South Africa)"),
	("2", "tt-ru",          "tt-ru",           "Tatar (Russia)"),
	("2", "ug-cn",          "ug-cn",           "Uyghur"),
	("2", "ur-pk",          "ur-pk",           "Urdu (Islamic Republic of Pakistan)"),
	("2", "uz-latn-uz",     "uz-latn-uz",      "Uzbek (Latin)"),
	("2", "vi-vn",          "vi-vn",           "Vietnamese (Viet Nam)"),
	("2", "wo-sn",          "wo-sn",           "Wolof"),
	("2", "xh-za",          "xh-za",           "Xhosa (South Africa)"),
	("2", "yo-ng",          "yo-ng",           "Yoruba (Nigeria)"),
	("2", "zu-za",          "zu-za",           "Zulu (South Africa)")
)


<#
	.Language Module
	.语言模块
#>
Function Language
{
	param
	(
		[string]$Force,
		[switch]$Reset,
		[switch]$Auto
	)
	$Host.UI.RawUI.WindowTitle = "$($Global:UniqueID)'s Solutions | Choose your country or region."

	<#
		.Reset
		.重置
	#>
	if ($Reset)
	{
		$Global:IsLang = $null
	} else {
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine" -Name "LanguagePrompt" -ErrorAction SilentlyContinue) {
			$GetLanguagePrompt = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine" -Name "LanguagePrompt"
			if ($GetLanguagePrompt -eq "True") {
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine" -Name "Language" -ErrorAction SilentlyContinue) {
					$GetLanguage = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine" -Name "Language"
					LanguageChange -lang $GetLanguage
					ImportModules
					return
				}
			}
		}
	}

	<#
		.Automatic
		.自动
	#>
	if ($Auto)
	{
		if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine" -Name "Language" -ErrorAction SilentlyContinue) {
			$GetLanguage = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine" -Name "Language"
			LanguageChange -lang $GetLanguage
		} else {
			LanguageChange -lang (Get-Culture).Name
		}
		ImportModules
		return
	}

	<#
		.Mandatory use of the specified language
		.强制使用指定语言
	#>
	if (-not (([string]::IsNullOrEmpty($Force))))
	{
		LanguageChange -lang $Force
		ImportModules
		return
	}

	<#
		.Saved language
		.已保存语言
	#>
	if (([string]::IsNullOrEmpty($Global:IsLang))) {
		LanguageSelectGUI
		if ($Global:Quit) { exit }
	} else {
		LanguageChange -lang $Global:IsLang
		ImportModules
	}
}

Function LanguageSelectGUI
{
	$Path = "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine"
	if (-not (Test-Path $Path)) {
		New-Item -Path $Path -Force -ErrorAction SilentlyContinue | Out-Null
	}

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()
	
	Clear-Host
	Write-Host "`n   Choose your country or region."
	
	$GUISelectLanguageDontPromptClick = {
		if ($GUISelectLanguageDontPrompt.Checked) {
			New-ItemProperty -Path $Path -Name "LanguagePrompt" -Value "True" -PropertyType string -Force | Out-Null
		} else {
			New-ItemProperty -Path $Path -Name "LanguagePrompt" -Value "False" -PropertyType string -Force | Out-Null
		}
	}
	$GUISelectLanguageCanelClick = {
		$GUISelectLanguage.Close()
		$Global:Quit = $True
	}
	$GUISelectLanguageOKClick = {
		$FlagsLanguageCheck = $False
		$GUISelectLanguagePanel.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.RadioButton]) {
				if ($_.Checked) {
					$FlagsLanguageCheck = $True
					New-ItemProperty -Path $Path -Name "Language" -Value $_.Tag -PropertyType string -Force | Out-Null
					LanguageChange -lang $_.Tag
					ImportModules
				}
			}
		}

		if ($FlagsLanguageCheck) {
			$GUISelectLanguage.Close()
		} else {
			$GUISelectLanguageErrorMsg.Text = "Please select your preferred language"
		}
	}
	$GUISelectLanguage = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 568
		Width          = 450
		Text           = "Choose your country or region."
		TopMost        = $True
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
	}
	$GUISelectLanguagePanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 428
		Width          = 450
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = 6
		Dock           = 1
	}
	$GUISelectLanguageErrorMsg = New-Object system.Windows.Forms.Label -Property @{
		Location       = "10,435"
		Height         = 22
		Width          = 400
		Text           = ""
	}
	$GUISelectLanguageDontPrompt = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 400
		Text           = "Remember the chosen language"
		Location       = '12,455'
		add_Click      = $GUISelectLanguageDontPromptClick
	}
	$GUISelectLanguageOK = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "10,482"
		Height         = 36
		Width          = 202
		add_Click      = $GUISelectLanguageOKClick
		Text           = "OK"
	}
	$GUISelectLanguageCanel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "218,482"
		Height         = 36
		Width          = 202
		add_Click      = $GUISelectLanguageCanelClick
		Text           = "Cancel"
	}
	$GUISelectLanguage.controls.AddRange((
		$GUISelectLanguagePanel,
		$GUISelectLanguageDontPrompt,
		$GUISelectLanguageErrorMsg,
		$GUISelectLanguageOK,
		$GUISelectLanguageCanel
	))

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine" -Name "Language" -ErrorAction SilentlyContinue) {
		$GetLanguage = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine" -Name "Language"
		$FlagsDefaultLanguage = $GetLanguage
	} else {
		$FlagsDefaultLanguage = (Get-Culture).Name
	}

	for ($i=0; $i -lt $Global:AvailableLanguages.Count; $i++) {
		if (Test-Path -Path "$($PSScriptRoot)\langpacks\$($Global:AvailableLanguages[$i][1])" -PathType Container) {
			$CheckBox   = New-Object System.Windows.Forms.RadioButton -Property @{
				Height  = 28
				Width   = 400
				Text    = $Global:AvailableLanguages[$i][3]
				Tag     = $Global:AvailableLanguages[$i][1]
			}

			if ($Global:AvailableLanguages[$i][1] -eq $FlagsDefaultLanguage) {
				$CheckBox.Checked = $True
			}

			$GUISelectLanguagePanel.controls.AddRange($CheckBox)
		}
	}

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine" -Name "LanguagePrompt" -ErrorAction SilentlyContinue) {
		$GetLanguagePrompt = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine" -Name "LanguagePrompt"
		switch ($GetLanguagePrompt) {
			"True" { $GUISelectLanguageDontPrompt.Checked = $True }
			"False" { $GUISelectLanguageDontPrompt.Checked = $False }
		}
	}

	switch ($Global:IsLang) {
		"zh-CN" {
			$GUISelectLanguage.Font = New-Object System.Drawing.Font("Microsoft YaHei", 9, [System.Drawing.FontStyle]::Regular)
		}
		Default {
			$GUISelectLanguage.Font = New-Object System.Drawing.Font("Arial", 9, [System.Drawing.FontStyle]::Regular)
		}
	}

	$GUISelectLanguage.FormBorderStyle = 'Fixed3D'
	$GUISelectLanguage.ShowDialog() | Out-Null
}

<#
	.Change language
	.更改语言
#>
Function LanguageChange
{
	param
	(
		[string]$lang
	)

	if (Test-Path -Path "$($PSScriptRoot)\langpacks\$lang\lang.psd1" -PathType Leaf)
	{
		$Global:IsLang = $lang
		Import-LocalizedData -BindingVariable Global:Lang -UICulture $lang -FileName "lang.psd1" -BaseDirectory "$($PSScriptRoot)\langpacks\$lang"
	} else {
		if (Test-Path -Path "$($PSScriptRoot)\langpacks\en-US\lang.psd1" -PathType Leaf) {
			$Global:IsLang = "en-US"
			Import-LocalizedData -BindingVariable Global:Lang -UICulture $lang -FileName "lang.psd1" -BaseDirectory "$($PSScriptRoot)\langpacks\en-US"
		} else {
			Clear-Host
			Write-Host "`n  There is no language pack locally, it will automatically exit after 6 seconds." -ForegroundColor Red
			Start-Sleep -s 6
			exit
		}
	}
}

<#
	.Refresh all modules
	.刷新所有模块
#>
Function RefreshModules
{
	param
	(
		[switch]$Silent
	)

	Write-Host "`n   $($lang.RefreshModules)"
	Language -Auto
	Write-Host "   $($lang.Done)`n" -ForegroundColor Green

	if (-not ($Silent)) {
		ToMainpage -wait 2
	}
}

<#
	.Import all modules
	.导入所有模块
#>
Function ImportModules
{
	<#
		.Remove all Engine modules
		.删除所有 Engine 模块
	#>
	Get-Module -Name Engine* | Where-Object -Property Name -like "Engine*" | ForEach-Object {
		Remove-Module -Name $_.Name -Force -ErrorAction Ignore
	}

	<#
		.Import all *.psm1
		.导入所有 *.psm1
	#>
	Get-ChildItem –Path  "$($PSScriptRoot)\Functions" –Recurse -include "Engine*.psm1" | ForEach-Object {
		Import-Module $_.FullName -Scope Global -Force
	}
}