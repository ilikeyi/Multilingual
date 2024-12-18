<#
	.Help
	.帮助
#>
Function Engine_Help
{
	Clear-Host
	Logo -Title $lang.Help

	Write-Host "   $($lang.Short_Cmd)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"
	Write-Host "     lang".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.SwitchLanguage

	Write-Host "     lang list".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.AvailableLanguages

	Write-Host "     lang auto".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.SwitchLanguage), $($lang.LanguageReset)"

	Write-Host "     lang {}".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.SwitchLanguage), $($lang.LanguageCode) { " -NoNewline
	Write-Host "lang zh-CN" -NoNewline -ForegroundColor Green
	Write-Host " }"

	Write-Host
	Write-Host "     Update".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host $lang.ChkUpdate

	Write-Host "     Update auto".PadRight(20) -NoNewline -ForegroundColor Yellow
	Write-Host "$($lang.ChkUpdate), $($lang.UpdateSilent)"
}