ConvertFrom-StringData -StringData @'
	# zh-TW
	# Chinese (Traditional, Taiwan)

	Prerequisites                   = 先決條件
	Check_PSVersion                 = 檢查 PS 版本 5.1 以上
	Check_OSVersion                 = 檢查 Windows 版本 > 10.0.16299.0
	Check_Higher_elevated           = 檢查必須提升至更高權限
	Check_execution_strategy        = 檢查執行策略

	Check_Pass                      = 透過
	Check_Did_not_pass              = 沒有通過
	Check_Pass_Done                 = 恭喜，通過了。
	How_solve                       = 如何解決
	UpdatePSVersion                 = 請安裝最新的 PowerShell 版本
	UpdateOSVersion                 = 1. 前往微軟官方網站下載最新版本的作業系統\n   2. 安裝最新版本的作業系統並重試
	HigherTermail                   = 1. 以管理員身分開啟"終端”或"PowerShell ISE”，\n      設定 PowerShell 執行策略：繞過，PS命令列：\n\n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n   2. 解決後，重新運行命令。
	HigherTermailAdmin              = 1. 以管理員身分開啟"終端”或"PowerShell ISE”。\n    2. 解決後，重新運行命令。
'@