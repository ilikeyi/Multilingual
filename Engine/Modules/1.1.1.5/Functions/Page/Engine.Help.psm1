<#
	.Help
	.帮助
#>
Function Engine_Help
{
	Clear-Host
	Logo -Title $lang.Help

	write-host "  $($lang.Short_Cmd)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"
	write-host "    lang".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.SwitchLanguage

	write-host "    lang list".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.AvailableLanguages

	write-host "    lang auto".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.SwitchLanguage), $($lang.LanguageReset)"

	write-host "    lang {}".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.SwitchLanguage), $($lang.LanguageCode) { " -NoNewline
	Write-Host "lang zh-CN" -NoNewline -ForegroundColor Green
	Write-Host " }"

	Write-Host
	write-host "    Update".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.ChkUpdate

	write-host "    Update auto".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.ChkUpdate), $($lang.UpdateSilent)"
}