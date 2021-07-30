<#
 .Synopsis
  Logs

 .Description
  Logs Feature Modules

 .NOTES
  Author:  Yi
  Website: http://fengyi.tel
#>

<#
	.Logs are saved to
	.日志保存到
#>
$LogsSaveFolder = "$($PSScriptRoot)\..\..\Logs"

<#
	.Log file name prefix
	.日志文件名前缀
#>
$SaveTo = "Log-$(Get-Date -Format "yyyyMMddHHmmss")"

<#
	.Clean up file types
	.清理文件类型
#>
$CleanFileTypes = @(
	"*.log"
	"*.csv"
)

<#
	.Clean up all logs from 7 days ago
	.清理 7 天前的所有日志
#>
Function CleanOldlogs
{
	Get-ChildItem –Path $LogsSaveFolder –Recurse -include ($CleanFileTypes) | Where-Object {
		$_.CreationTime –lt (Get-Date).AddDays(-7)
	} | Remove-Item -Force -ErrorAction SilentlyContinue
}

<#
	.Write log format as csv
	.写入日志格式为 csv
#>
function WriteLogs
{
	[cmdletbinding()]
	param (
		$Message,

		[ValidateSet('Info', 'Warning', 'Error', 'Verbose')]
		$Level = 'Info',

		[string[]]
		$Tag,
		
		[Switch]
		$OutputToScreen 
	)
	
	#Write-Verbose "$Title $Message"
	If ($OutputToScreen -or ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $VerbosePreference))
	{
		switch ($Level)
		{
			'Info' { Write-Host    "$Message" }
			'Warning' { Write-Warning "$Message" }
			'Error' { Write-Host    "$Message" -ForegroundColor Red }
			'Verbose' {Write-Verbose "$Message"}
		}
	}

	$callItem = (Get-PSCallstack)[1]
	$data = [PSCustomObject][ordered]@{
		Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff'
		Level     = $Level
		Tag       = $Tag -join ","
		Line      = $callItem.ScriptLineNumber
		File      = $callItem.ScriptName
		Message   = $Message
	}
	Export-Csv -InputObject $data -Path "$LogsSaveFolder\$SaveTo.csv" -NoTypeInformation -Append
}

<#
	.Log function
	.日志功能
#>
Function Logging
{
	<#
		.Generate Logs directory
		.生成 Logs 目录
	#>
	CheckCatalog -chkpath $LogsSaveFolder
	CleanOldlogs

	<#
		.Operation record
		.操作记录
	#>
	Start-Transcript -Path "$LogsSaveFolder\$SaveTo.log" -Force -ErrorAction SilentlyContinue
}

Export-ModuleMember -Function Logging, WriteLogs