<#
	.Set system language settings
	.设置系统语言
#>
Function Language_Setting
{
	Write-Host "`n   $($lang.SettingLangAndKeyboard)"

	<#
		.Current UI main language
		.当前 UI 主语言
	#>
	$Script:UILanguage = (Get-Culture).Name

	<#
		.Refresh all known languages installed
		.刷新已安装的所有已知语言
	#>
	Language_Known_Available

	<#
		.Reset the array and initialize the language
		.重置数组和初始化语言
	#>
	$Script:GroupLanguage = @()
	$Script:GroupLanguage = New-WinUserLanguageList $Script:UILanguage
	$Script:GroupLanguage[0].InputMethodTips.Clear()

	<#
		.Add current preferred language
		.添加当前首选语言
	#>
	Write-Host "   $($lang.SetLang)$($Script:UILanguage)" -ForegroundColor Green
	Language_Process -NewLang $Script:UILanguage

	<#
		.Specialized processing: monolingual, and non-monolingual
		.特殊化处理：单语言、和非单语
	#>
	$FlagsSingleLanguage = $False
	if ((Get-WindowsEdition -online).Edition -like "*Single*") {
		$FlagsSingleLanguage = $True
	}

	if ($FlagsSingleLanguage) {
		<#
			.Processing: Single language
			.处理：单语版
		#>
		if (($Global:AvailableLanguages) -Contains "en-US") {
			Language_Process -NewLang "en-US"
			Write-Host "   $($lang.AddTo), en-US"
		}
	} else {
		<#
			.Processing: other unrestricted versions
			.处理：其它不受限制版本
		#>
		foreach ($item in $Global:AvailableLanguages) {
			if ($Script:UILanguage -ne $item) {
				Language_Process -NewLang $item
				Write-Host "   $($lang.AddTo), $item"
			}
		}
	}

	<#
		.Execute add language
		.执行添加语言
	#>
	Set-WinUserLanguageList $Script:GroupLanguage -Force -ErrorAction SilentlyContinue | Out-Null

	<#
		.Set the default keyboard: English
		.设置默认键盘：英文
	#>
	Set-WinDefaultInputMethodOverride -InputTip "0409:00000409" -ErrorAction SilentlyContinue | Out-Null

	<#
		.Different input methods used for each application window
		.为每个应用程序窗口使用不同的输入法

		.Enabled
		 Set-WinLanguageBarOption -UseLegacySwitchMode -ErrorAction SilentlyContinue | Out-Null

		.Disable
		 Set-WinLanguageBarOption -ErrorAction SilentlyContinue | Out-Null
	#>
#	Set-WinLanguageBarOption -UseLegacySwitchMode -ErrorAction SilentlyContinue | Out-Null

	<#
		.Regional codes
		.区域编码

		-Match | 匹配
		-Force | 强行同步与当前系统主语言一致
	#>
	Language_Region_Setting -Force
	Language_Region_Setting -Match

	<#
		.Beta: Use Unicode UTF-8 for worldwide language support
	#>
	if (Deploy_Sync -Mark "UseUTF8") {
		Language_Use_UTF8 -Enabled
	} else {
		Write-Host "   $($lang.SettingUTF8)"
		Write-Host "   $($lang.Inoperable)`n" -ForegroundColor Red
	}

	<#
		.Setting time
		.设置时间
	#>
	if (Deploy_Sync -Mark "TimeZone") {
		for ($i=0; $i -lt $Global:AvailableLanguages.Count; $i++) {
			if ($Script:UILanguage -eq $Global:AvailableLanguages[$i][2]) {
				Write-Host "`n   $($lang.SetTimezone)"
				Write-Host "   $($Global:AvailableLanguages[$i][5])" -ForegroundColor Green
				Set-TimeZone -Id $Global:AvailableLanguages[$i][5] -PassThru | Out-Null
				break
			}
		}

		<#
			.Resynchronize time
			.重新同步时间
		#>
		W32tm /resync /force | Out-Null
	}
}

<#
	.Specialize different languages, specify and add hidden input methods
	.特殊化处理不同的语言，指定添加隐藏的输入法

     https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-input-locales-for-windows-language-packs	
#>
Function Language_Process
{
	param
	(
		$NewLang
	)

	<#
		.Set judgment language flag
		.设置判断语言标记
	#>
	$FlagsNewLanguage = $False

	if ($NewLang -eq "zh-CN" ) {
		$FlagsNewLanguage = $True
		Write-Host "   $($lang.KeyboardSequence)$($lang.Pinyi)"
		$Script:GroupLanguage[0].InputMethodTips.add('0804:{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}{FA550B04-5AD7-411f-A5AC-CA038EC515D7}')      # Pinyin

		Write-Host "   $($lang.KeyboardSequence)$($lang.Wubi)"
		$Script:GroupLanguage[0].InputMethodTips.add('0804:{6a498709-e00b-4c45-a018-8f9e4081ae40}{82590C13-F4DD-44f4-BA1D-8667246FDF8E}')      # Wubi
	}

	<#
		.Unmatched languages, add directly
		.未匹配的语言，直接添加
	#>
	if (-not ($FlagsNewLanguage)) {
		$Script:GroupLanguage.Add($NewLang)
	}
}

<#
	.Get all known languages installed by the running operating system
	.获取正在运行的操作系统已安装的所有已知语言
#>
Function Language_Known_Available
{
	<#
		.Get the language installed in the system and generate it into an array
		.获取系统已安装语言，并生成到数组里
	#>
	$Global:AvailableLanguages = @()
	Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty MUILanguages | Foreach-Object {
		$Global:AvailableLanguages += $_
	}
}

<#
	.Set regional codes to match known languages to prevent illegal matches.
	.设置区域编码，根据已知语言匹配，防止非法匹配。
#>
Function Language_Region_Setting
{
	param
	(
		[switch]$Match,
		[switch]$Force
	)

	Write-Host "`n   $($lang.SettingLocale)"
	if ($Match) {
		for ($i=0; $i -lt $Global:AvailableLanguages.Count; $i++) {
			$LanguageName = $Global:AvailableLanguages[$i][2]

			if (Test-Path -Path "$($PSScriptRoot)\..\..\Deploy\Region\$($LanguageName)" -PathType Leaf) {
				Write-Host "   $($LanguageName)"
				Set-WinSystemLocale $LanguageName -ErrorAction SilentlyContinue | Out-Null
				Write-Host "   $($lang.Done)`n" -ForegroundColor Green
				break
			}
		}
	} else {
		Write-Host "   $($lang.Inoperable)`n" -ForegroundColor Red
	}

	if ($Force) {
		Write-Host "   $((Get-Culture).Name)"
		Set-WinSystemLocale (Get-Culture).Name -ErrorAction SilentlyContinue | Out-Null
		Write-Host "   $($lang.Done)`n" -ForegroundColor Green
	} else {
		Write-Host "   $($lang.Inoperable)`n" -ForegroundColor Red
	}
}

Function Language_Use_UTF8
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	Write-Host "   $($lang.SettingUTF8)"
	if ($Enabled) {
		Write-Host "   $($lang.Enabled)".PadRight(22) -NoNewline
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "ACP" -Type String -Value 65001 -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "OEMCP" -Type String -Value 65001 -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "MACCP" -Type String -Value 65001 -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		Write-Host "   $($lang.Disable)".PadRight(22) -NoNewline
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "ACP" -Type String -Value 936 -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "OEMCP" -Type String -Value 936 -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "MACCP" -Type String -Value 10008 -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}