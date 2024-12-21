<#
	.Log function
	.日志功能
#>
Function Logging
{
	<#
		.Logs are saved to
		.日志保存到
	#>
	$TestLogSaveFolder = "$($PSScriptRoot)\..\..\..\..\..\Logs"

	if (Test_Available_Disk -Path $TestLogSaveFolder) {
		$Global:LogsSaveFolder = Convert-Path -Path $TestLogSaveFolder -ErrorAction SilentlyContinue
	} else {
		$TestLogSaveFolder = Join-Path -Path $env:LOCALAPPDATA -ChildPath "$((Get-Module -Name Engine).Author)\Logs"
		Check_Folder -chkpath $TestLogSaveFolder
		$Global:LogsSaveFolder = $TestLogSaveFolder
	}
	
	<#
		.Generate Logs directory
		.生成 Logs 目录
	#>
	Check_Folder -chkpath "$($Global:LogsSaveFolder)\$($Global:LogSaveTo)"
	Logs_Clear_Old

	<#
		.Operation record
		.操作记录
	#>
	Start-Transcript -Path "$($Global:LogsSaveFolder)\$($Global:LogSaveTo)\Logging.log" -Force -ErrorAction SilentlyContinue | Out-Null
}

<#
	.Write log format as csv
	.写入日志格式为 csv
#>
Function Logs_Write
{
	[cmdletbinding()]
	param
	(
		$Message,

		[ValidateSet('Info', 'Warning', 'Error', 'Verbose')]
		$Level = 'Info',

		[string[]]
		$Tag,
		
		[Switch]
		$OutputToScreen,

		[switch]
		$Main
	)

	#Write-Verbose "$Title $Message"
	If ($OutputToScreen -or ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $VerbosePreference))
	{
		switch ($Level)
		{
			'Info' { Write-Host $Message }
			'Warning' { Write-Warning $Message }
			'Error' { Write-Host $Message -ForegroundColor Red }
			'Verbose' { Write-Verbose $Message }
		}
	}

	$callItem = (Get-PSCallstack)[1]
	$data = [PSCustomObject][ordered]@{
		Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff'
		Logs      = $Global:LogSaveTo
		Level     = $Level
		Tag       = $Tag -join ","
		Line      = $callItem.ScriptLineNumber
		File      = $callItem.ScriptName
		Message   = $Message
	}

	if ($Main) {
		Export-Csv -InputObject $data -Path "$($Global:LogsSaveFolder)\Logging.csv" -NoTypeInformation -Append
	} else {
		Export-Csv -InputObject $data -Path "$($Global:LogsSaveFolder)\$($Global:LogSaveTo)\Logging.csv" -NoTypeInformation -Append
	}
}

<#
	.Clean up all logs from 7 days ago
	.清理 7 天前的所有日志
#>
Function Logs_Clear_Old
{
	Get-ChildItem -Path $Global:LogsSaveFolder -Directory -Exclude $Global:LogSaveTo -ErrorAction SilentlyContinue | Where-Object {
		if ($_.LastWriteTime -lt (Get-Date).AddDays(-7)) {
			Remove-Item -path $_.Fullname -Force -Recurse -ErrorAction SilentlyContinue
		}
	}
}