<#
	.Summary
	.摘要
	 Yi's Solutions

	.PowerShell must be run with elevated privileges, run
	.PowerShell 必须以提升的特权运行，运行
	 powershell -Command "Set-ExecutionPolicy -ExecutionPolicy Bypass -Force"

	.Or run in a PowerShell session, PS C:\>
	.或在 PowerShell 会话中运行, PS C:\>
	 Set-ExecutionPolicy -ExecutionPolicy Bypass -Force

	.EXAMPLE
	.示例
	 PS C:\> .\Engine.ps1
	 PS C:\> .\Engine.ps1 -Function "Function1 -Param", "Function2 -Param"

	.LINK
	 https://github.com/ilikeyi/Multilingual
	  - https://github.com/ilikeyi/solutions/tree/main/scheme/Engine/Multilingual

	  https://gitee.com/ilikeyi/Multilingual
	  - https://gitee.com/ilikeyi/solutions/tree/master/scheme/Engine/Multilingual
	 
	.NOTES
	 Author:  Yi
	 Website: http://fengyi.tel
#>

[CmdletBinding()]
param
(
	[switch]$FirstExperience,
	[string[]]$Functions
)

Remove-Module -Name Engine -Force -ErrorAction Ignore | Out-Null
Import-Module -Name $PSScriptRoot\Modules\Engine.psd1 -PassThru -Force | Out-Null

<#
	.设置语言，用法
	.Set language pack, usage:
	 Language                | Language selected by the user       | 选择语言，交互
	 Language -Auto          | Automatic matching                  | 自动选择，不提示
	 Language -Force "zh-CN" | Mandatory use of specified language | 强制选择语言
#>
Language -Auto

<#
	.Prerequisites
	.先决条件
#>
Requirements

<#
	.启用日志记录并将其保存在脚本文件夹中。
	.Enable logging and save it in the script folder.
#>
Logging

# Go
if ($Functions) {
	foreach ($Function in $Functions) {
		Invoke-Expression -Command $Function
	}
	exit
}

if ($FirstExperience) {
	Signup -FirstExperience
} else {
	Mainpage
}