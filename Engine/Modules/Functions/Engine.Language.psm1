<#
 .Synopsis
  Language Setting

 .Description
  Language Setting Feature Modules

 .NOTES
  Author:  Yi
  Website: http://fengyi.tel
#>

<#
	.Set system language settings
	.设置系统语言
#>
Function LanguageSetting
{
	Write-Host "`n   $($lang.SettingLangAndKeyboard)"

	<#
		.Current UI main language
		.当前 UI 主语言
	#>
	$Global:UILanguage = (Get-Culture).Name

	<#
		.Reset the array and initialize the language
		.重置数组和初始化语言
	#>
	$Global:GroupLanguage = @()
	$Global:GroupLanguage = New-WinUserLanguageList $Global:UILanguage
	$Global:GroupLanguage[0].InputMethodTips.Clear()

	<#
		.Add current preferred language
		.添加当前首选语言
	#>
	Write-Host "   - $($lang.SetLang)$($Global:UILanguage)" -ForegroundColor Green
	LanguageProcess -NewLang $Global:UILanguage

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
		if ($Global:UILanguage -ne "en-US" ) {
			LanguageProcess -NewLang "en-US"
		}
	} else {
		<#
			.Processing: other unrestricted versions
			.处理：其它不受限制版本
		#>
		<#
			.Get the languages installed on the system
			.获取系统已安装的语言
		#>
		foreach ($item in (Get-WmiObject -Class Win32_OperatingSystem).MUILanguages) {
			if ($Global:UILanguage -ne $item) {
				LanguageProcess -NewLang $item
			}
		}
	}

	<#
		.Execute add language
		.执行添加语言
	#>
	Set-WinUserLanguageList $Global:GroupLanguage -Force

	<#
		.Set the default keyboard: English
		.设置默认键盘：英文
	#>
	Set-WinDefaultInputMethodOverride -InputTip "0409:00000409"

	<#
		.Set regional codes to match known languages to prevent illegal matches.
		.设置区域编码，根据已知语言匹配，防止非法匹配。
	#>
	for ($i=0; $i -lt $Global:AvailableLanguages.Count; $i++) {
		$LanguageName = $Global:AvailableLanguages[$i][1]

		if (Test-Path -Path "$PSScriptRoot\..\..\Deploy\Region\$($LanguageName)") {
			Set-WinSystemLocale $LanguageName
			break
		}
	}

	<#
		.Setting time
		.设置时间
	#>
#	Set-TimeZone -Id "China Standard Time" -PassThru | Out-Null

	<#
		.Beta: Use Unicode UTF-8 for worldwide language support
	#>
	if (Test-Path "$PSScriptRoot\..\..\Deploy\UseUTF8" -PathType Leaf) {
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "ACP" -Type String -Value 65001 -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "OEMCP" -Type String -Value 65001 -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "MACCP" -Type String -Value 65001 -ErrorAction SilentlyContinue | Out-Null
	}
}

<#
	.Specialize different languages, specify and add hidden input methods
	.特殊化处理不同的语言，指定添加隐藏的输入法

     https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-input-locales-for-windows-language-packs	
#>
Function LanguageProcess {
	param (
		$NewLang
	)

	<#
		.Set judgment language flag
		.设置判断语言标记
	#>
	$FlagsNewLanguage = $False

	if ($NewLang -eq "zh-CN" ) {
		$FlagsNewLanguage = $True
		Write-Host "   - $($lang.KeyboardSequence)$($lang.Pinyi)"
		$Global:GroupLanguage[0].InputMethodTips.add('0804:{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}{FA550B04-5AD7-411f-A5AC-CA038EC515D7}')      # Pinyin

		Write-Host "   - $($lang.KeyboardSequence)$($lang.Wubi)"
		$Global:GroupLanguage[0].InputMethodTips.add('0804:{6a498709-e00b-4c45-a018-8f9e4081ae40}{82590C13-F4DD-44f4-BA1D-8667246FDF8E}')      # Wubi
	}

	<#
		.Unmatched languages, add directly
		.未匹配的语言，直接添加
	#>
	if (-not ($FlagsNewLanguage)) {
		$Global:GroupLanguage.Add($NewLang)
	}
}

Export-ModuleMember -Function LanguageSetting, LanguageProcess