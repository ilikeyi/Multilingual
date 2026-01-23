<#
	.Set system language settings
	.设置系统语言
#>
Function Language_Setting
{
	write-host "`n  $($lang.SettingLangAndKeyboard)"

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
	Language_Process -NewLang $Script:UILanguage

	write-host "  $($lang.SetLang)"
	write-host "  $($Script:UILanguage)" -ForegroundColor Green

	write-host "`n  $($lang.LanguageInstalled)"
	ForEach ($item in $Global:LanguagesAreInstalled) {
		write-host "  $($item)" -ForegroundColor Green
	}

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

			Rules:
			规则：
				If it is monolingual:
				如果是单语：
					Proceed to the next step.
					·进行下一步。

				If it is multilingual:
				如果是多语：
					.Determine whether there is en-US, and if there is, it is added as a second language first
					·判断是否有 en-US，有则优先添加为第二语言，

					 There is no en-US, and other languages are added randomly to mark as second languages.
					 如果没有 en-US，随机添加其它语言标记为第二语言。
		#>

		<#
			.Single language
			.单语
		#>
		if ($Global:LanguagesAreInstalled.Count -le 1) {
			write-host "`n  $($lang.LangSingle)"
		} else {
			<#
				.Multilingual
				.多语
			#>
			write-host "`n  $($lang.LangMul)"

			<#
				.There is no en-US, and other languages are added randomly to mark as second languages.
				.没有 en-US，随机添加其它语言标记为第二语言。
			#>
			$initWaitRandomlyLang = @()
			ForEach ($item in $Global:LanguagesAreInstalled) {
				if ($Script:UILanguage -ne $item) {
					$initWaitRandomlyLang += $item
				}
			}

			<#
				.Determine whether there is en-US, and if there is, it is added as a second language first
				.判断是否有 en-US，有则优先添加为第二语言
			#>
			if ($initWaitRandomlyLang -Contains "en-US") {
				Language_Process -NewLang "en-US"
				write-host "`n  $($lang.AddTo): en-US"
			} else {
				write-host "`n  $($lang.RandomlyWaitSel)"
				ForEach ($item in $initWaitRandomlyLang) {
					write-host "  $($item)"
				}

				write-host "`n  $($lang.RandomlySelResults)"
				$RandomlySelectLang = $initWaitRandomlyLang | Get-Random
				write-host "  $($RandomlySelectLang)" -ForegroundColor Green
				Language_Process -NewLang $RandomlySelectLang
			}
		}
	} else {
		<#
			.Processing: other unrestricted versions
			.处理：其它不受限制版本
		#>
		ForEach ($item in $Global:LanguagesAreInstalled) {
			if ($Script:UILanguage -ne $item) {
				Language_Process -NewLang $item
				write-host "  $($lang.AddTo): $($item)"
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
	if (Deploy_Sync -Mark "Use_UTF8") {
		Language_Use_UTF8 -Enabled
	} else {
		write-host "  $($lang.SettingUTF8)"
		write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
	}
}

<#
	.Specialize different languages, specify and add hidden input methods
	.特殊化处理不同的语言，指定添加隐藏的输入法

     https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-input-locales-for-windows-language-packs?view=windows-11
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
		write-host "  $($lang.KeyboardSequence)$($lang.Pinyi)"
		$Script:GroupLanguage[0].InputMethodTips.add('0804:{81D4E9C9-1D3B-41BC-9E6C-4B40BF79E35E}{FA550B04-5AD7-411f-A5AC-CA038EC515D7}')      # Pinyin

		write-host "  $($lang.KeyboardSequence)$($lang.Wubi)"
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
	$Global:LanguagesAreInstalled = @()
	Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object -ExpandProperty MUILanguages | ForEach-Object {
		$Global:LanguagesAreInstalled += $_
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

	write-host "`n  $($lang.SettingLocale)"
	if ($Match) {
		$Region = Language_Region
		ForEach ($itemRegion in $Region) {
			if (Test-Path -Path "$($PSScriptRoot)\..\..\..\..\..\Deploy\Region\$($itemRegion.Region)" -PathType Leaf) {
				write-host "  $($itemRegion.Name)"
				write-host "  $($itemRegion.Region)"
				Set-WinSystemLocale $itemRegion.Region -ErrorAction SilentlyContinue | Out-Null

				<#
					.Setting time
					.设置时间
				#>
#				write-host "`n  $($lang.SetTimezone)"
#				write-host "  $($itemRegion.Timezone)" -ForegroundColor Green
#				Set-TimeZone -Id $itemRegion.Timezone -PassThru | Out-Null

				<#
					.Resynchronize time
					.重新同步时间
				#>
				Start-Service "W32Time"
				Get-Service "W32Time"
				W32tm /resync /force

				write-host "  $($lang.Done)`n" -ForegroundColor Green
				break
			}
		}
	} else {
		write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
	}

	if ($Force) {
		write-host "  $((Get-Culture).Name)"
		Set-WinSystemLocale (Get-Culture).Name -ErrorAction SilentlyContinue | Out-Null
		write-host "  $($lang.Done)`n" -ForegroundColor Green
	} else {
		write-host "  $($lang.Inoperable)`n" -ForegroundColor Red
	}
}

Function Language_Use_UTF8
{
	param
	(
		[switch]$Enabled,
		[switch]$Disable
	)

	write-host "  $($lang.SettingUTF8)"
	if ($Enabled) {
		write-host "  $($lang.Enable)".PadRight(22) -NoNewline
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "ACP" -Type String -Value 65001 -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "OEMCP" -Type String -Value 65001 -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "MACCP" -Type String -Value 65001 -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}

	if ($Disable) {
		write-host "  $($lang.Disable)".PadRight(22) -NoNewline
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "ACP" -Type String -Value 936 -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "OEMCP" -Type String -Value 936 -ErrorAction SilentlyContinue | Out-Null
		Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Nls\CodePage" -Name "MACCP" -Type String -Value 10008 -ErrorAction SilentlyContinue | Out-Null
		Write-Host "$($lang.Done)`n" -ForegroundColor Green
	}
}