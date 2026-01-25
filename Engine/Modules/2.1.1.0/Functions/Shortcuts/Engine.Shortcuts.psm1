<#
	.快捷指令：PS *
#>
Function Shortcuts_PS_Cmd
{
	param
	(
		$Command
	)

	$Command = $Command.Remove(0, 3)

	Write-Host "`n  $($lang.Command): " -NoNewline
	Write-host "PS" -ForegroundColor Green

	Write-Host "  $($lang.SpecialFunction): " -NoNewline
	Write-host $Command -ForegroundColor Green
	Write-Host "  $('-' * 80)"

	<#
		.拆分
	#>
	$Command = $Command -split ';' | Where-Object { -not ([string]::IsNullOrEmpty($_) -or [string]::IsNullOrWhiteSpace($_))} | Select-Object -Unique
	$IsFunction = @()
	Get-Command -CommandType Function | ForEach-Object {
		if ($Command -Contains $_) {
			$IsFunction += $_.name
		}
	}

	Write-Host "`n  $($lang.LXPsWaitAssign)" -ForegroundColor Yellow
	Write-Host "  $('-' * 80)"
	if ($IsFunction.Count -gt 0) {
		ForEach ($item in $IsFunction) {
			Write-Host "  $($item)" -ForegroundColor Green
		}

		Write-Host "`n  $($lang.WaitQueue)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $IsFunction) {
			write-host "  $($lang.Running): " -NoNewline
			Write-Host $item -ForegroundColor Green
			Write-Host "  $('-' * 80)"

			Invoke-Expression -Command $item

			Write-Host "  $('-' * 80)"
			write-host "  $($lang.Command): " -NoNewline
			Write-Host $item -ForegroundColor Green

			Write-Host "  " -NoNewline
			Write-Host " $($lang.Running) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		}
	} else {
		Write-Host "  $($lang.NoWork)" -ForegroundColor Red

		Write-Host "`n  $($lang.WaitQueue)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Command) {
			Write-Host "  $($item)" -ForegroundColor Green
		}

		Write-Host "`n  $($lang.YesWork)" -ForegroundColor Yellow
		Write-Host "  $('-' * 80)"
		ForEach ($item in $Command) {
			write-host "  $($lang.Running): " -NoNewline
			Write-Host $item -ForegroundColor Green
			Write-Host "  $('-' * 80)"

			Invoke-Expression $item

			Write-Host "  $('-' * 80)"
			write-host "  $($lang.Command): " -NoNewline
			Write-Host $item -ForegroundColor Green

			Write-Host "  " -NoNewline
			Write-Host " $($lang.Running) " -NoNewline -BackgroundColor White -ForegroundColor Black
			Write-Host " $($lang.Done) " -BackgroundColor DarkGreen -ForegroundColor White
		}
	}
}