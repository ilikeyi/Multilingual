<#
	.about us
	.关于我们
#>
$Global:UniqueID  = "Yi"
$Global:AuthorURL = "https://fengyi.tel"

<#
	.Available languages
	.可用语言

	.Sorting rules: group type, regional language, short name, region name, time region
	.排序规则：分组类型、区域 ID、区域语言、短名称、区域名称、时间区域

	.Group type: 1. Language pack; 2. Language interface pack (LIP)
	.分组类型：1、语言包；2、语言界面包（LIP）

	.Starting from Windows 11, five new types have been added, totaling 43 types ( ca-ES, eu-ES, gl-ES, id-ID, vi-VN )
	.从 Windows 11 开始，新增五种，共计 43 种（ca-ES、eu-ES、gl-ES、id-ID、vi-VN）

	https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/available-language-packs-for-windows
	https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-time-zones?view=windows-11
#>
$Global:AvailableLanguages = @(
	<#
           Language/region decimal ID
                    Language/region tag
                                      ISO3166            Language/region                                   Timezone                             LIP ID
	#>
	("1",  "1025",  "ar-SA",          "ar",              "Arabic (Saudi Arabia)",                          "Argentina Standard Time",           "9N4S78P86PKX"),
	("1",  "1026",  "bg-BG",          "bg",              "Bulgarian (Bulgaria)",                           "FLE Standard Time",                 "9MX54588434F"),
	("1",  "2052",  "zh-CN",          "cn",              "Chinese (Simplified, China)",                    "China Standard Time",               "9NRMNT6GMZ70"),
	("1",  "1028",  "zh-TW",          "tw",              "Chinese (Traditional, Taiwan)",                  "Taipei Standard Time",              "9PCJ4DHCQ1JQ"),
	("1",  "1050",  "hr-HR",          "hr",              "Croatian (Croatia)",                             "Central European Standard Time",    "9NW01VND4LTW"),
	("1",  "1029",  "cs-CZ",          "dz",              "Czech (Czech Republic)",                         "W. Central Africa Standard Time",   "9P3WXZ1KTM7C"),
	("1",  "1030",  "da-DK",          "dk",              "Danish (Denmark)",                               "Romance Standard Time",             "9NDMT2VKSNL1"),
	("1",  "1043",  "nl-NL",          "nl",              "Dutch (Netherlands)",                            "W. Europe Standard Time",           "9PF1C9NB5PRV"),
	("1",  "1033",  "en-US",          "en",              "English (United States)",                        "Pacific Standard Time",             "9PDSCC711RVF"),
	("1",  "2057",  "en-GB",          "gb",              "English (United Kingdom)",                       "GMT Standard Time",                 "9NT52VQ39BVN"),
	("1",  "1061",  "et-EE",          "ee",              "Estonian (Estonia)",                             "FLE Standard Time",                 "9NFBHFMCR30L"),
	("1",  "1035",  "fi-FI",          "fi",              "Finnish (Finland)",                              "FLE Standard Time",                 "9MW3PQ7SD3QK"),
	("1",  "3084",  "fr-CA",          "ca",              "French (Canada)",                                "Eastern Standard Time",             "9MTP2VP0VL92"),
	("1",  "1036",  "fr-FR",          "fr",              "French (France)",                                "Central European Time",             "9NHMG4BJKMDG"),
	("1",  "1031",  "de-DE",          "de",              "German (Germany)",                               "W. Europe Standard Time",           "9P6CT0SLW589"),
	("1",  "1032",  "el-GR",          "gr",              "Greek (Greece)",                                 "GTB Standard Time",                 "9N586B13PBLD"),
	("1",  "1037",  "he-IL",          "il",              "Hebrew (Israel)",                                "Israel Standard Time",              "9NB6ZFND5HCQ"),
	("1",  "1038",  "hu-HU",          "hu",              "Hungarian (Hungary)",                            "Central Europe Standard Time",      "9MWN3C58HL87"),
	("1",  "1040",  "it-IT",          "it",              "Italian (Italy)",                                "W. Europe Standard Time",           "9P8PQWNS6VJX"),
	("1",  "1041",  "ja-JP",          "jp",              "Japanese (Japan)",                               "Tokyo Standard Time",               "9N1W692FV4S1"),
	("1",  "1042",  "ko-KR",          "kr",              "Korean (Korea)",                                 "Korea Standard Time",               "9N4TXPCVRNGF"),
	("1",  "1062",  "lv-LV",          "lv",              "Latvian (Latvia)",                               "FLE Standard Time",                 "9N5CQDPH6SQT"),
	("1",  "1063",  "lt-LT",          "lt",              "Lithuanian (Lithuania)",                         "FLE Standard Time",                 "9NWWD891H6HN"),
	("1",  "1044",  "nb-NO",          "no",              "Norwegian, Bokmål (Norway)",                     "W. Europe Standard Time",           "9N6J0M5DHCK0"),
	("1",  "1045",  "pl-PL",          "pl",              "Polish (Poland)",                                "Central European Standard Time",    "9NC5HW94R0LD"),
	("1",  "1046",  "pt-BR",          "br",              "Portuguese (Brazil)",                            "E. South America Standard Time",    "9P8LBDM4FW35"),
	("1",  "2070",  "pt-PT",          "pt",              "Portuguese (Portugal)",                          "GMT Standard Time",                 "9P7X8QJ7FL0X"),
	("1",  "1048",  "ro-RO",          "ro",              "Romanian (Romania)",                             "GTB Standard Time",                 "9MWXGPJ5PJ3H"),
	("1",  "1049",  "ru-RU",          "ru",              "Russian (Russia)",                               "Russian Standard Time",             "9NMJCX77QKPX"),
	("1",  "1051",  "sk-SK",          "sk",              "Slovak (Slovakia)",                              "Central Europe Standard Time",      "9N7LSNN099WB"),
	("1",  "1060",  "sl-SI",          "si",              "Slovenian (Slovenia)",                           "Central Europe Standard Time",      "9NV27L34J4ST"),
	("1",  "2058",  "es-MX",          "mx",              "Spanish (Mexico)",                               "Central Standard Time (Mexico)",    "9N8MCM1X3928"),
	("1",  "3082",  "es-ES",          "es-ES",           "Spanish (Spain)",                                "Romance Standard Time",             "9NWVGWLHPB1Z"),
	("1",  "1053",  "sv-SE",          "se",              "Swedish (Sweden)",                               "W. Europe Standard Time",           "9P0HSNX08177"),
	("1",  "1054",  "th-TH",          "th",              "Thai (Thailand)",                                "SE Asia Standard Time",             "9MSTWFRL0LR4"),
	("1",  "1055",  "tr-TR",          "tr",              "Turkish (Turkey)",                               "Turkey Standard Time",              "9NL1D3T5HG9R"),
	("1",  "1058",  "uk-UA",          "ua",              "Ukrainian (Ukraine)",                            "FLE Standard Time",                 "9PPPMZRSGHR8"),
	("1",  "1027",  "ca-es",          "ca-es",           "Catalan",                                        "Romance Standard Time",             "9P6JMKJQZ9S7"),
	("1",  "1069",  "eu-es",          "eu-es",           "Basque (Basque)",                                "Romance Standard Time",             "9NMCHQHZ37HZ"),
	("1",  "1110",  "gl-es",          "gl",              "Galician",                                       "Greenland Standard Time",           "9NXRNBRNJN9B"),
	("1",  "1057",  "id-id",          "id",              "Indonesian (Indonesia)",                         "SE Asia Standard Time",             "9P4X3N4SDK8P"),
	("1",  "1066",  "vi-vn",          "vi-vn",           "Vietnamese",                                     "SE Asia Standard Time",             "9P0W68X0XZPT"),
	("1",  "9242",  "sr-latn-rs",     "sr-latn-rs",      "Serbian (Latin, Serbia)",                        "Central Europe Standard Time",      "9NBZ0SJDPPVT"),

	<#
		.Language Interface Pack (LIP)
		.语言界面包 (LIP)
	#>
	("2",  "1078",  "af-za",          "af",              "Afrikaans (South Africa)",                       "Afghanistan Standard Time",         "9PDW16B5HMXR"),
	("2",  "1118",  "am-et",          "am-et",           "Amharic (Ethiopia)",                             "E. Africa Standard Time",           "9NGL4R61W3PL"),
	("2",  "1101",  "as-in",          "as-in",           "Assamese (India)",                               "India Standard Time",               "9NTJLXMXX35J"),
	("2",  "1068",  "az-latn-az",     "az-latn-az",      "Azerbaijan",                                     "Azerbaijan Standard Time",          "9P5TFKZHQ5K8"),
	("2",  "1059",  "be-by",          "be-by",           "Belarusian (Belarus)",                           "W. Central Africa Standard Time",   "9MXPBGNNDW3L"),
	("2",  "2117",  "bn-bd",          "bn-bd",           "Bangla (Bangladesh)",                            "Bangladesh Standard Time",          "9PH7TKVXGGM8"),
	("2",  "1093",  "bn-in",          "bn-in",           "Bangla (India)",                                 "India Standard Time",               "9P1M44L7W84T"),
	("2",  "5146",  "bs-latn-ba",     "bs-latn-ba",      "Bosnian (Latin)",                                "Central European Standard Time",    "9MVFKLJ10MFL"),
	("2",  "2051",  "ca-es-valencia", "ca-es-valencia",  "Valencian",                                      "Romance Standard Time",             "9P9K3WMFSW90"),
	("2",  "1116",  "chr-cher-us",    "chr-cher-us",     "Cherokee",                                       "Central Standard Time (Mexico)",    "9MX15485N3RK"),
	("2",  "1106",  "cy-gb",          "cy",              "Welsh (United Kingdom)",                         "E. Europe Standard Time",           "9NKJ9TBML4HB"),
	("2",  "1065",  "fa-ir",          "fa",              "Farsi (Iran)",                                   "Iran Standard Time",                "9NGS7DD4QS21"),
	("2",  "1124",  "fil-ph",         "fil-ph",          "Filipino",                                       "Singapore Standard Time",           "9NWM2KGTDSSS"),
	("2",  "2108",  "ga-ie",          "ga-ie",           "Irish (Ireland)",                                "GMT Standard Time",                 "9P0L5Q848KXT"),
	("2",  "1169",  "gd-gb",          "gd-gb",           "Scottish Gaelic",                                "GMT Standard Time",                 "9P1DBPF36BF3"),
	("2",  "1095",  "gu-in",          "gu",              "Gujarati (India)",                               "West Pacific Standard Time",        "9P2HMSWDJDQ1"),
	("2",  "1128",  "ha-latn-ng",     "ha-latn-ng",      "Hausa (Latin, Nigeria)",                         "W. Central Africa Standard Time",   "9N1L95DBGRG3"),
	("2",  "1081",  "hi-in",          "hi",              "Hindi (India)",                                  "India Standard Time",               "9NZC3GRX8LD3"),
	("2",  "1067",  "hy-am",          "hy",              "Armenian (Armenia)",                             "Caucasus Standard Time",            "9NKM28TM6P67"),
	("2",  "1136",  "ig-ng",          "ig-ng",           "Igbo (Nigeria)",                                 "W. Central Africa Standard Time",   "9PG4ZFJ48JSX"),
	("2",  "1039",  "is-is",          "is",              "Icelandic (Iceland)",                            "Greenwich Standard Time",           "9NTHJR7TQXX1"),
	("2",  "1079",  "ka-ge",          "ka",              "Georgian (Georgia)",                             "Greenwich Standard Time",           "9P60JZL05WGH"),
	("2",  "1087",  "kk-kz",          "kk",              "Kazakh (Kazakhstan)",                            "Central Asia Standard Time",        "9PHV179R97LV"),
	("2",  "1107",  "km-kh",          "km-kh",           "Khmer (Cambodia)",                               "SE Asia Standard Time",             "9PGKTS4JS531"),
	("2",  "1099",  "kn-in",          "kn",              "Kannada (India)",                                "SA Western Standard Time",          "9NC6DB7N95F9"),
	("2",  "1111",  "kok-in",         "kok",             "Konkani (India)",                                "India Standard Time",               "9MV3P55CMZ6P"),
	("2",  "1170",  "ku-arab-iq",     "ku-arab-iq",      "Central Kurdish",                                "Arabic Standard Time",              "9P1C18QL3D7H"),
	("2",  "1088",  "ky-kg",          "ky",              "Kyrgyz (Kyrgyzstan)",                            "SA Pacific Standard Time",          "9P7D3JJGZM48"),
	("2",  "1134",  "lb-lu",          "lb-lu",           "Luxembourgish (Luxembourg)",                     "W. Europe Standard Time",           "9N0ST1WBZ9D9"),
	("2",  "1108",  "lo-la",          "lo-la",           "Lao (Laos)",                                     "SE Asia Standard Time",             "9N8X352G5NZV"),
	("2",  "1153",  "mi-nz",          "mi",              "Maori (New Zealand)",                            "New Zealand Standard Time",         "9P2GDFB3JPSX"),
	("2",  "1071",  "mk-mk",          "mk",              "FYRO Macedonian",                                "Central European Standard Time",    "9P1X6XB1K3RN"),
	("2",  "1100",  "ml-in",          "ml-in",           "Malayalam (India)",                              "Central European Standard Time",    "9NWDTV8FFV7L"),
	("2",  "1104",  "mn-mn",          "mn",              "Mongolian (Mongolia)",                           "Ulaanbaatar Standard Time",         "9PG1DHC4VTZW"),
	("2",  "1102",  "mr-in",          "mr",              "Marathi (India)",                                "Greenwich Standard Time",           "9MWXCKHJVR1J"),
	("2",  "1086",  "ms-my",          "ms-my",           "Malay (Malaysia)",                               "Singapore Standard Time",           "9NPXL8ZSDDQ7"),
	("2",  "1082",  "mt-mt",          "mt",              "Maltese (Malta)",                                "W. Europe Standard Time",           "9PDG96SQ6BN8"),
	("2",  "1121",  "ne-np",          "ne-np",           "Nepali (Federal Democratic Republic of Nepal)",  "Nepal Standard Time",               "9P7CHPLWDQVN"),
	("2",  "2068",  "nn-no",          "nn-no",           "Norwegian (Nynorsk) (Norway)",                   "W. Europe Standard Time",           "9PK7KM3Z06KH"),
	("2",  "1132",  "nso-za",         "nso-za",          "Sesotho sa Leboa (South Africa)",                "South Africa Standard Time",        "9NS49QLX5CDV"),
	("2",  "1096",  "or-in",          "or-in",           "Odia (India)",                                   "India Standard Time",               "9NTHCXCXSJDH"),
	("2",  "2118",  "pa-arab-pk",     "pa-arab-pk",      "Punjabi (Arabic, Pakistan)",                     "Pakistan Standard Time",            "9NJRL03WH6FM"),
	("2",  "1094",  "pa-in",          "pa",              "Punjabi (India)",                                "SA Pacific Standard Time",          "9NSNC0ZJX69B"),
	("2",  "1164",  "prs-af",         "prs-af",          "Dari",                                           "SA Pacific Standard Time",          "9P3NGC6X5ZQC"),
	("2",  "1158",  "quc-latn-gt",    "quc-latn-gt",     "K'iche' (Guatemala)",                            "Central America Standard Time",     "9P2V6MNNQZ0B"),
	("2",  "3179",  "quz-pe",         "quz-pe",          "Quechua (Peru)",                                 "SA Pacific Standard Time",          "9NHTX8NVQ04K"),
	("2",  "1159",  "rw-rw",          "rw-rw",           "Kinyarwanda",                                    "South Africa Standard Time",        "9NFW0M20H9WG"),
	("2",  "2137",  "sd-arab-pk",     "sd-arab-pk",      "Sindhi (Arabic)",                                "Pakistan Standard Time",            "9NB9JSCXW9X5"),
	("2",  "1115",  "si-lk",          "si-lk",           "Sinhala (Sri Lanka)",                            "Sri Lanka Standard Time",           "9NVF9QSLGTL0"),
	("2",  "1052",  "sq-al",          "sq",              "Albanian (Albania)",                             "Central Europe Standard Time",      "9MWLRGNMDGK7"),
	("2",  "7194",  "sr-cyrl-ba",     "sr-cyrl-ba",      "Serbian (Cyrillic, Bosnia and Herzegovina)",     "Central European Standard Time",    "9MXGN7V65C7B"),
	("2",  "10266", "sr-cyrl-rs",     "sr-cyrl-rs",      "Serbian (Cyrillic, Serbia)",                     "Central Europe Standard Time",      "9PPD6CCK9K5H"),
	("2",  "1089",  "sw-ke",          "sw-ke",           "Kiswahili (Kenya)",                              "E. Africa Standard Time",           "9NFF2M19DQ55"),
	("2",  "1097",  "ta-in",          "ta-in",           "Tamil (India)",                                  "India Standard Time",               "9PDZB1WT1B34"),
	("2",  "1098",  "te-in",          "te-in",           "Telugu (India)",                                 "India Standard Time",               "9PMQJJGF63FW"),
	("2",  "1064",  "tg-cyrl-tj",     "tg-cyrl-tj",      "Tajik (Cyrillic)",                               "West Asia Standard Time",           "9MZHLBPPT2HC"),
	("2",  "1139",  "ti-et",          "ti-et",           "Tigrinya",                                       "E. Africa Standard Time",           "9NC8C9RDNK2S"),
	("2",  "1090",  "tk-tm",          "tk-tm",           "Turkmen",                                        "West Asia Standard Time",           "9NKHQ4GL6VLT"),
	("2",  "1074",  "tn-za",          "tn-za",           "Tswana (South Africa)",                          "South Africa Standard Time",        "9NFSXM123DHT"),
	("2",  "1092",  "tt-ru",          "tt-ru",           "Tatar (Russia)",                                 "Russian Standard Time",             "9NV90Q1X1ZR2"),
	("2",  "1152",  "ug-cn",          "ug-cn",           "Uyghur",                                         "E. Africa Standard Time",           "9P52C5D7VL5S"),
	("2",  "1056",  "ur-pk",          "ur-pk",           "Urdu (Islamic Republic of Pakistan)",            "Pakistan Standard Time",            "9NDWFTFW12BQ"),
	("2",  "1091",  "uz-latn-uz",     "uz-latn-uz",      "Uzbek (Latin)",                                  "West Asia Standard Time",           "9P5P2T5P5L9S"),
	("2",  "1160",  "wo-sn",          "wo-sn",           "Wolof",                                          "Greenwich Standard Time",           "9NH3SW1CR90F"),
	("2",  "1076",  "xh-za",          "xh-za",           "Xhosa (South Africa)",                           "South Africa Standard Time",        "9NW3QWSLQD17"),
	("2",  "1130",  "yo-ng",          "yo-ng",           "Yoruba (Nigeria)",                               "W. Central Africa Standard Time",   "9NGM3VPPZS5V"),
	("2",  "1130",  "zu-za",          "zu-za",           "Zulu (South Africa)",                            "South Africa Standard Time",        "9NNRM7KT5NB0")
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
					Language_Change -lang $GetLanguage
					Modules_Import -Import
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
			Language_Change -lang $GetLanguage
		} else {
			Language_Change -lang (Get-Culture).Name
		}
		Modules_Import -Import
		return
	}

	<#
		.Mandatory use of the specified language
		.强制使用指定语言
	#>
	if (-not (([string]::IsNullOrEmpty($Force))))
	{
		Language_Change -lang $Force
		Modules_Import -Import
		return
	}

	<#
		.Saved language
		.已保存语言
	#>
	if (([string]::IsNullOrEmpty($Global:IsLang))) {
		Language_Select_GUI
		if ($Global:Quit) {
			Modules_Import
			$Global:Quit = $False
			exit
		}
	} else {
		Language_Change -lang $Global:IsLang
		Modules_Import -Import
	}
}

Function Language_Select_GUI
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
					Language_Change -lang $_.Tag
					Modules_Import -Import
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
		Height         = 720
		Width          = 550
		Text           = "Choose your country or region."
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
	}
	$GUISelectLanguagePanel = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		Height         = 530
		Width          = 550
		BorderStyle    = 0
		autoSizeMode   = 0
		autoScroll     = $True
		Padding        = 6
		Dock           = 1
	}
	$GUISelectLanguageErrorMsg = New-Object system.Windows.Forms.Label -Property @{
		Location       = "8,545"
		Height         = 22
		Width          = 508
		Text           = ""
	}
	$GUISelectLanguageDontPrompt = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 22
		Width          = 508
		Text           = "&Remember the chosen language"
		Location       = '10,566'
		add_Click      = $GUISelectLanguageDontPromptClick
	}
	$GUISelectLanguageOK = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "8,595"
		Height         = 36
		Width          = 515
		add_Click      = $GUISelectLanguageOKClick
		Text           = "&OK"
	}
	$GUISelectLanguageCanel = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Location       = "8,635"
		Height         = 36
		Width          = 515
		add_Click      = $GUISelectLanguageCanelClick
		Text           = "&Cancel"
	}
	$GUISelectLanguage.controls.AddRange((
		$GUISelectLanguagePanel,
		$GUISelectLanguageDontPrompt,
		$GUISelectLanguageErrorMsg,
		$GUISelectLanguageOK,
		$GUISelectLanguageCanel
	))

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine" -Name "Language" -ErrorAction SilentlyContinue) {
		$FlagsDefaultLanguage = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\$($Global:UniqueID)\Engine" -Name "Language"
	} else {
		$FlagsDefaultLanguage = (Get-Culture).Name
	}

	for ($i=0; $i -lt $Global:AvailableLanguages.Count; $i++) {
		if (Test-Path -Path "$($PSScriptRoot)\langpacks\$($Global:AvailableLanguages[$i][2])" -PathType Container) {
			$CheckBox   = New-Object System.Windows.Forms.RadioButton -Property @{
				Height  = 40
				Width   = 400
				Text    = "$($Global:AvailableLanguages[$i][4])`n$($Global:AvailableLanguages[$i][2])"
				Tag     = $Global:AvailableLanguages[$i][2]
			}

			if ($Global:AvailableLanguages[$i][2] -eq $FlagsDefaultLanguage) {
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
			$GUISelectLanguage.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
		}
	}

	$GUISelectLanguage.FormBorderStyle = 'Fixed3D'
	$GUISelectLanguage.ShowDialog() | Out-Null
}

<#
	.Change language
	.更改语言
#>
Function Language_Change
{
	param
	(
		[string]$lang
	)

	if (Test-Path -Path "$($PSScriptRoot)\langpacks\$lang\lang.psd1" -PathType Leaf) {
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
			Modules_Import
			$Global:Quit = $False
			exit
		}
	}
}

<#
	.Refresh all modules
	.刷新所有模块
#>
Function Modules_Refresh
{
	param
	(
		[string[]]$Functions
	)

	Write-Host "`n   $($lang.RefreshModules)"
	Language -Auto
	Write-Host "   $($lang.Done)" -ForegroundColor Green

	if ($Functions) {
		foreach ($Function in $Functions) {
			Invoke-Expression -Command $Function
		}
	}
}

<#
	.Import all modules
	.导入所有模块
#>
Function Modules_Import
{
	param
	(
		[switch]$Import
	)

	<#
		.Remove all Engine modules
		.删除所有 Engine 模块
	#>
	Get-Module -Name Engine* | Where-Object -Property Name -like "Engine*" | ForEach-Object {
		Remove-Module -Name $_.Name -Force -ErrorAction Ignore
	}

	if ($Import) {
		Import-Module -Name $PSScriptRoot\..\Modules\Engine.psd1 -Scope Global -Force | Out-Null
		<#
			.Import all *.psd1
			.导入所有 *.psd1
		#>
		Get-ChildItem –Path "$($PSScriptRoot)\Functions" –Recurse -include "Engine.*.psd1" | ForEach-Object {
			Import-Module -Name $_.FullName -Scope Global -Force
		}
	}
}