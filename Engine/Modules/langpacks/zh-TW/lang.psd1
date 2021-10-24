ConvertFrom-StringData -StringData @'
	# Main page
	Mainname                  = 解決方案
	Mainpage                  = 解決方案工具箱
	Update                    = 檢查更新
	Reset                     = 重置
	Disable                   = 禁用
	Done                      = 完成
	OK                        = 確定
	Cancel                    = 取消
	Exit                      = 退出
	AllSel                    = 選擇所有
	AllClear                  = 清除所有
	Operable                  = 可操作
	Inoperable                = 不可操作
	ForceUpdate               = 強行檢查並更新
	SettingLangAndKeyboard    = 設置系統語言和鍵盤
	SwitchLanguage            = 切換語言
	RefreshModules            = 重新加載模塊
	Choose                    = 請選擇
	FailedCreateFolder        = 創建目錄失敗：
	ToMsg                     = \n   {0} 秒後自動返回到主菜單。
	ToQuit                    = \n   {0} 秒後退出主菜單。
	DiskSearch                = 搜索計劃：
	DiskSearchFind            = 搜索到，正在運行中：{0}
	DeployCleanup             = 清理 Deploy 目錄
	FirstDeployment           = 首次體驗部署
	FirstDeploymentWarning    = 請勿關閉任務欄顯示的 PowerShell 圖標。
	FirstDeploymentDone       = 已完成部署。
	FirstDeploymentPopup      = 彈出主界面
	FirstExpFinishOnDemand    = 允許首次預體驗，按計劃
	DeployTask                = 部署任務：
	Reboot                    = 完成後，重新啟動計算機

	DeployPackerTips          = 有可用的部署合集包
	DeployPackerTipsDone      = 部署合集包已完成。
	DeployOfficeTips          = 有可用的 Office 部署計劃
	DeployOfficeTipsDone      = Office 部署計劃已完成。

	NetworkLocationWizard     = 網絡位置嚮導
	UseZip                    = 使用 {0} 解壓軟件
	UseOSZip                  = 使用系統自帶的解壓軟件
	UserCancel                = 用戶已取消操作。
	SetLang                   = 設置系統首選語言：
	KeyboardSequence          = 鍵盤順序：
	Wubi                      = 五筆
	Pinyi                     = 拼音

	# update
	UpdateServerSelect        = 自動選擇服務器或自定義選擇
	UpdateServerNoSelect      = 請選擇可用的服務器
	UpdateSilent              = 有可用更新時，靜默更新
	UpdateReset               = 重置此解決方案
	UpdateResetTips           = 下載地址可用時，強制下載並自動更新。
	UpdateExit                = 自動更新腳本將會在 {0} 秒後自動退出。
	UpdateCheckServerStatus   = 檢查服務器狀態 ( 共 {0} 個可選 )
	UpdateServerAddress       = 服務器地址：{0}
	UpdateServeravailable     = 狀態：可用
	UpdateServerUnavailable   = 狀態：不可用
	UpdatePriority            = 已設置為優先級
	UpdateServerTestFailed    = 未通過服務器狀態測試
	UpdateQueryingUpdate      = 正在查詢更新中...
	UpdateQueryingTime        = 正檢查是否有最新版本可用，連接耗時 {0} 毫秒。
	UpdateConnectFailed       = 無法連接到遠程服務器，檢查更新已中止。
	UpdateMinimumVersion      = 滿足最低更新程序版本要求，最低要求版本：{0}
	UpdateVerifyAvailable     = 驗證地址是否可用
	UpdateDownloadAddress     = 下載地址：
	UpdateAvailable           = 可用
	UpdateUnavailable         = 不可用
	UpdateCurrent             = 當前使用版本: \
	UpdateLatest              = 可用最新版本: \
	UpdateNewLatest           = 發現新的可用版本！
	UpdateForce               = 正在強制進行更新。
	UpdateSkipUpdateCheck     = 預配置策略，不允許首次運行自動更新。
	UpdateTimeUsed            = 所用的時間：
	UpdatePostProc            = 後期處理
	UpdateNotExecuted         = 不執行
	UpdateNoPost              = 未找到後期處理任務
	UpdateUnpacking           = 正在解壓：
	UpdateDone                = 已成功更新！
	UpdateUpdateStop          = 下載更新時發生錯誤，更新過程中止。
	UpdateInstall             = 您要安裝此更新嗎？
	UpdateInstallSel          = 是，將安裝上述更新\n否，則不會安裝該更新
	UpdateNoUpdateAvailable   = \n   沒有可用的更新。\n\n   您正在運行 {0}'s Solutions 的最新可用版本。\n
	UpdateNotSatisfied        = \n   不滿足最低更新程序版本要求，\n\n   最低要求版本：{0}\n\n   請重新下載 {1}'s Solutions 的副本，以更新此工具。\n\n   檢查更新已中止。\n

	# Create Update
	UpdateCreate              = 創建升級包
	UpdateLow                 = 最低要求: \
	UpCreateRear              = 創建後需要做些什麼
	UpCreateASC               = 給升級包添加 PGP 簽名，證書密碼：
	UpCreateSHA256            = 給升級包生成 .SHA-256
	Uping                     = 正在生成
	SkipCreate                = 跳過生成，未找到
	ZipStatus                 = 未安裝 7-Zip。
	ASCStatus                 = 未安裝 Gpg4win。
'@