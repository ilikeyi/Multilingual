<#
	.LOGO
#>
Function Logo
{
	param
	(
		$Title
	)

	Clear-Host
	$Host.UI.RawUI.WindowTitle = "$((Get-Module -Name Engine).Author)'s Solutions | $($Title)"
	Write-Host "`n   Author: $((Get-Module -Name Engine).Author) ( $((Get-Module -Name Engine).HelpInfoURI) )

   From: $((Get-Module -Name Engine).Author)'s Solutions
   buildstring: $((Get-Module -Name Engine).Version.ToString()).bs_release.2024.04.18`n"
}

<#
	.主界面
	.Main interface
#>
Function Mainpage
{
	Logo -Title $($lang.Mainname)
	Write-Host "   $($lang.Mainname)`n   $('-' * 80)"

	write-host "     1  $($lang.ChkUpdate)
     2. $($lang.FirstDeployment)" -ForegroundColor Green

   write-host  "`n     L  $($lang.SwitchLanguage)
     R  $($lang.RefreshModules)`n"

	switch (Read-Host "   $($lang.PleaseChoose)")
	{
		"1" {
			Update
			Modules_Refresh -Function "ToMainpage -wait 2"
		}
		"2" {
			FirstExperience
			ToMainpage -wait 2
		}
		"l" {
			Language -Reset
			Mainpage
		}
		"r" {
			Modules_Refresh -Function "ToMainpage -wait 2"
		}
		"q" {
			Stop-Process $PID
			exit
		}
		default { Mainpage }
	}
}

<#
	.返回到主界面
	.Return to the main interface
#>
Function ToMainpage
{
	param
	(
		[int]$wait
	)

	Write-Host $($lang.ToMsg -f $wait) -ForegroundColor Red
	Start-Sleep -s $wait
	Mainpage
}