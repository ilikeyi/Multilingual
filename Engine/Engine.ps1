<#
	.Summary
	 Yi's Solutions

	.Open "Terminal" or "PowerShell ISE" as an administrator,
	 set PowerShell execution policy: Bypass, PS command line: 

	 Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force

	.Example
	 PS C:\> .\Engine.ps1
	 PS C:\> .\Engine.ps1 -Function "Function1 -Param", "Function2 -Param"

	.LINK
	 https://github.com/ilikeyi/Multilingual

	.About
	 Author:  Yi
	 Website: http://fengyi.tel
#>

[CmdletBinding()]
param
(
	[switch]$Force,
	[string[]]$Functions
)

<#
	.The log is saved to the directory name
	.日志保存到目录名称
#>
$Global:LogSaveTo = "Log-$(Get-Date -Format "yyyyMMddHHmmss")"

Remove-Module -Name Engine -Force -ErrorAction Ignore | Out-Null
Import-Module -Name $PSScriptRoot\Modules\Engine.psd1 -PassThru -Force | Out-Null

<#
	.设置语言，用法
	.Set language pack, usage:
	 Language                  | Language selected by the user       | 选择语言，交互
	 Language -Auto            | Automatic matching                  | 自动选择，不提示
	 Language -NewLang "zh-CN" | Mandatory use of specified language | 强制选择语言
#>
Language -Auto

<#
	.Prerequisites
	.先决条件
#>
Prerequisite

<#
	.启用日志记录并将其保存在脚本文件夹中。
	.Enabled logging and save it in the script folder.
#>
Logging

# Go
if ($Functions) {
	ForEach ($Function in $Functions) {
		Invoke-Expression -Command $Function
	}
	Modules_Import
	Stop-Process $PID
	exit
}

if ($Force) {
	FirstExperience -Force
} else {
	Mainpage
}