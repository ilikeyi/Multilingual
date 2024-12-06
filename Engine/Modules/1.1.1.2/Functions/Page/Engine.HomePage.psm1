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
	Write-Host "   " -NoNewline
	Write-Host " $((Get-Module -Name Engine).Author)'s Solutions " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " v$((Get-Module -Name Engine).Version.ToString()) " -NoNewline -BackgroundColor DarkGreen -ForegroundColor White

	if ($ShowUpdate) {
		Write-Host " $($lang.ChkUpdate) " -NoNewline -BackgroundColor White -ForegroundColor Black
		Write-Host " Update " -BackgroundColor DarkMagenta -ForegroundColor White
	} else {
		Write-Host
	}

	Write-Host "   " -NoNewline
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

	Write-Host "   $($lang.ToMsg -f $wait)" -ForegroundColor Red
	start-process "timeout.exe" -argumentlist "/t $($wait) /nobreak" -wait -nonewwindow
}

<#
	.主界面
	.Main interface
#>
Function Mainpage
{
	Logo -Title $lang.Mainname -ShowUpdate
	Write-Host "   $($lang.Mainname)" -ForegroundColor Yellow
	Write-Host "   $('-' * 80)"

	Write-Host "     " -NoNewline
	Write-Host " 1 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.ChkUpdate) " -ForegroundColor Green

	Write-Host "     " -NoNewline
	Write-Host " 2 " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.FirstDeployment) " -ForegroundColor Green

	Write-Host
	Write-Host "     " -NoNewline
	Write-Host " L " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.SwitchLanguage) " -ForegroundColor Green

	Write-Host "     " -NoNewline
	Write-Host " R " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host "  $($lang.RefreshModules) " -ForegroundColor Green

	Write-Host
	Write-Host "   " -NoNewline
	Write-Host " H " -NoNewline -BackgroundColor DarkMagenta -ForegroundColor White
	Write-Host " $($lang.Help) " -NoNewline -BackgroundColor White -ForegroundColor Black
	Write-Host " " -NoNewline
	switch -Wildcard (Read-Host $lang.PleaseChooseMain)
	{
		"update" {
			Update
			Modules_Refresh -Function "ToMainpage -wait 2", "Mainpage"
		}
		"update *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			$NewType = $PSItem.Remove(0, 7).Replace(' ', '')
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
		"l" {
			Language -Reset
			Mainpage
		}
		"lang" {
			Language -Reset
			ToMainpage -wait 2
			Mainpage
		}
		"lang *" {
			Write-Host "`n   $($lang.Short_Cmd)" -ForegroundColor Yellow

			$NewLanguage = $PSItem.Remove(0, 5).Replace(' ', '')
			$Langpacks_Sources = "$($PSScriptRoot)\..\..\langpacks"
			switch ($NewLanguage) {
				"list" {
					Write-Host "`n   $($lang.AvailableLanguages)"
					Write-Host "   $('-' * 80)"

					$Match_Available_Languages = @()
					Get-ChildItem -Path $Langpacks_Sources -Directory -ErrorAction SilentlyContinue | ForEach-Object {
						if (Test-Path "$($_.FullName)\Lang.psd1" -PathType Leaf) {
							$Match_Available_Languages += $_.Basename
						}
					}

					if ($Match_Available_Languages.count -gt 0) {
						ForEach ($item in $Global:Languages_Available) {
							if ($Match_Available_Languages -contains $item.Region) {
								Write-Host "   $($item.Region)".PadRight(20) -NoNewline -ForegroundColor Green
								Write-Host $item.Name -ForegroundColor Yellow
							}
						}

						Get_Next
					} else {

					}
				}
				"auto" {
					Write-Host "`n   $($lang.SwitchLanguage): "
					Write-Host "   $('-' * 80)"
					Remove-ItemProperty -Path "HKCU:\SOFTWARE\$((Get-Module -Name Engine).Author)\Multilingual" -Name "Language" -ErrorAction SilentlyContinue
					Write-Host "   $($lang.Done)" -ForegroundColor Green
					Modules_Refresh -Function "ToMainpage -wait 2", "Mainpage"
				}
				default {
					Write-Host "`n   $($lang.SwitchLanguage): " -NoNewline
					Write-Host $NewLanguage -ForegroundColor Green
					Write-Host "   $('-' * 80)"

					if (Test-Path "$($Langpacks_Sources)\$($NewLanguage)\Lang.psd1" -PathType Leaf) {
						Write-Host "   $($lang.Done)" -ForegroundColor Green
						Save_Dynamic -regkey "Multilingual" -name "Language" -value $NewLanguage -String
						Modules_Refresh -Function "ToMainpage -wait 2", "Mainpage"
					} else {
						Write-Host "   $($lang.UpdateUnavailable)" -ForegroundColor Red
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
			.快速测试区域
		#>
		"t" {
			Write-Host "`n   $($lang.Developers_Mode)" -ForegroundColor Yellow
			Write-Host "   $('-' * 80)"

			# Start






			# End

			Write-Host "   $('-' * 80)"
			Write-Host "   $($lang.Developers_Mode), $($lang.Done)" -ForegroundColor Green

			<#
				.添加 ToMainpage 防止直接退出
			#>
			ToMainpage -wait 2
			Mainpage
		}
		"h" {
			Engine_Help
			Get_Next
			ToMainpage -wait 2
			Mainpage
		}
		"q" {
			return
		}
		default { Mainpage }
	}
}