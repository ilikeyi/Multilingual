<#
	.LOGO
#>
Function Logo
{
	param
	(
		$Title,
		[switch]$ShowUpdate
	)

	Clear-Host
	$Host.UI.RawUI.WindowTitle = "$((Get-Module -Name Engine).Author)'s Solutions | $($Title)"

	Write-Host
	write-host "  " -NoNewline
	Write-Host " $((Get-Module -Name Engine).Author)'s Solutions " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " v$((Get-Module -Name Engine).Version.ToString()) " -NoNewline -BackgroundColor DarkGreen -ForegroundColor White

	if ($ShowUpdate) {
		Write-Host " $($lang.ChkUpdate) " -NoNewline -BackgroundColor White -ForegroundColor Black
		Write-Host " Upd " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	}

	if ($Global:Developers_Mode) {
		$Host.UI.RawUI.WindowTitle += " | $($lang.Developers_Mode)"
		Write-Host " $($lang.Developers_Mode) " -NoNewline -BackgroundColor White -ForegroundColor Black
		Write-Host " Dev " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	}

	Write-Host
	write-host "  " -NoNewline
	Write-Host " $($lang.Learn) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " $((Get-Module -Name Engine).PrivateData.PSData.ProjectUri) " -BackgroundColor DarkBlue -ForegroundColor White

	Write-Host
}

<#
	.返回到主界面
	.Return to the main interface
#>
Function ToMainpage
{
	param
	(
		[int]$Wait
	)

	Write-Host
	Write-Host "  $($lang.ToMsg -f $wait)" -ForegroundColor Red
	start-process "timeout.exe" -argumentlist "/t $($wait) /nobreak" -wait -nonewwindow
}

<#
	.主界面
	.Main interface
#>
Function Mainpage
{
	Logo -Title $lang.Mainname -ShowUpdate
	write-host "  $($lang.Mainname)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	write-host "     " -NoNewline
	Write-Host " 1 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host "  $($lang.ChkUpdate) " -ForegroundColor Green

	write-host "     " -NoNewline
	Write-Host " 2 " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host "  $($lang.FirstDeployment) " -ForegroundColor Green

	Write-Host
	Write-Host
	write-host "  " -NoNewline
	Write-Host " lang " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.SwitchLanguage) " -ForegroundColor Green

	write-host "     " -NoNewline
	Write-Host " R " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.RefreshModules) " -ForegroundColor Green

	Write-Host
	write-host "  " -NoNewline
	Write-Host " $($lang.Help) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " H'elp * " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White

	Write-Host " $($lang.Short_Cmd) " -NoNewline -BackgroundColor White -ForegroundColor Black

	Write-Host " $($lang.Options) " -NoNewline -BackgroundColor Green -ForegroundColor Black
	Write-Host ": " -NoNewline

	$NewEnter = Read-Host

	<#
		.The prefix cannot contain spaces
		.前缀不能带空格
	#>
	while ($true) {
		if ($NewEnter -match '^\s') {
			$NewEnter = $NewEnter.Remove(0, 1)
		} else {
			break
		}
	}

	switch -Wildcard ($NewEnter)
	{
		"Dev" {
			write-host "`n  $($lang.Developers_Mode)" -ForegroundColor Yellow
			write-host "  $('-' * 80)"
			write-host "  $($lang.Setting)".PadRight(28) -NoNewline
			if ($Global:Developers_Mode) {
				$Global:Developers_Mode = $False
				Write-Host $lang.Disable -ForegroundColor Green
			} else {
				$Global:Developers_Mode = $True
				Write-Host $lang.Enable -ForegroundColor Green
			}

			ToMainpage -wait 2
			Mainpage
		}
		"Upd" {
			Update
			Modules_Refresh -Function "ToMainpage -wait 2", "Mainpage"
		}
		"Upd *" {
			write-host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow

			$NewType = $PSItem.Remove(0, 4).Replace(' ', '')
			switch ($NewType) {
				"auto" {
					Update -Auto
				}
				default {
					Update
				}
			}

			Modules_Refresh -Function "ToMainpage -wait 2", "Mainpage"
		}
		"1" {
			Update
			Modules_Refresh -Function "ToMainpage -wait 2", "Mainpage"
		}
		"2" {
			FirstExperience
			ToMainpage -wait 2
			Mainpage
		}
		"lang" {
			Language -Reset
			ToMainpage -wait 2
			Mainpage
		}
		"lang *" {
			write-host "`n  $($lang.Short_Cmd)" -ForegroundColor Yellow

			$NewLanguage = $PSItem.Remove(0, 5).Replace(' ', '')
			$Langpacks_Sources = "$($PSScriptRoot)\..\..\langpacks"
			switch ($NewLanguage) {
				"list" {
					write-host "`n  $($lang.AvailableLanguages)"
					write-host "  $('-' * 80)"

					$Match_Available_Languages = @()
					Get-ChildItem -Path $Langpacks_Sources -Directory -ErrorAction SilentlyContinue | ForEach-Object {
						if (Test-Path "$($_.FullName)\Lang.psd1" -PathType Leaf) {
							$Match_Available_Languages += $_.Basename
						}
					}

					if ($Match_Available_Languages.count -gt 0) {
						ForEach ($item in $Global:Languages_Available) {
							if ($Match_Available_Languages -contains $item.Region) {
								write-host "  $($item.Region)".PadRight(20) -NoNewline -ForegroundColor Green
								Write-Host $item.Name -ForegroundColor Yellow
							}
						}

						Get_Next
					} else {

					}
				}
				"auto" {
					write-host "`n  $($lang.SwitchLanguage): "
					write-host "  $('-' * 80)"
					Remove-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Engine).Author)\Multilingual" -Name "Language" -ErrorAction SilentlyContinue
					write-host "  $($lang.Done)" -ForegroundColor Green
					Modules_Refresh -Function "ToMainpage -wait 2", "Mainpage"
				}
				default {
					write-host "`n  $($lang.SwitchLanguage): " -NoNewline
					Write-Host $NewLanguage -ForegroundColor Green
					write-host "  $('-' * 80)"

					if (Test-Path "$($Langpacks_Sources)\$($NewLanguage)\Lang.psd1" -PathType Leaf) {
						write-host "  $($lang.Done)" -ForegroundColor Green
						Save_Dynamic -regkey "Multilingual" -name "Language" -value $NewLanguage -String
						Modules_Refresh -Function "ToMainpage -wait 2", "Mainpage"
					} else {
						write-host "  $($lang.UpdateUnavailable)" -ForegroundColor Red
					}
				}
			}

			ToMainpage -wait 2
			Mainpage
		}
		"r" {
			Modules_Refresh -Function "ToMainpage -wait 2", "Mainpage"
		}

		<#
			.Help
			.帮助
		#>
		{ "H", "Help", "H'elp" -eq $_ } {
			Engine_Help
			Get_Next
			ToMainpage -wait 2
			Mainpage
		}
		"q" {
			return
		}
		default { Mainpage }

		<#
			.快速测试区域
		#>
		"t" {
			write-host "`n  $($lang.Developers_Mode)" -ForegroundColor Yellow
			write-host "  $('-' * 80)"

			# Start










			


			# End

			write-host "  $('-' * 80)"
			write-host "  $($lang.Developers_Mode), $($lang.Done)" -ForegroundColor Green

			<#
				.添加 ToMainpage 防止直接退出
			#>
			ToMainpage -wait 2
			Mainpage
		}
	}
}