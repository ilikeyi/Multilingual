ConvertFrom-StringData -StringData @'
	# zh-TW
	# Chinese (Traditional, Taiwan)

	ChkUpdate                 = 檢查更新
	UpdateServerSelect        = 自動選擇服務器或自定義選擇
	UpdateServerNoSelect      = 請選擇可用的服務器
	UpdateSilent              = 有可用更新時，靜默更新
	UpdateClean               = 允許空閒時清理舊版本
	ForceUpdate               = 強行檢查並更新
	UpdateReset               = 重置此解決方案
	UpdateResetTips           = 下載地址可用時，強制下載並自動更新。
	UpdateCheckServerStatus   = 檢查服務器狀態 ( 共 {0} 個可選 )
	UpdateServerAddress       = 服務器地址
	UpdatePriority            = 已設置為優先級
	UpdateServerTestFailed    = 未通過服務器狀態測試
	UpdateQueryingUpdate      = 正在查詢更新中...
	UpdateQueryingTime        = 正檢查是否有最新版本可用，連接耗時 {0} 毫秒。
	UpdateConnectFailed       = 無法連接到遠程服務器，檢查更新已中止。
	UpdateREConnect           = 連線失敗，正在進行第 {0}/{1} 次重試。
	UpdateMinimumVersion      = 滿足最低更新程序版本要求，最低要求版本：{0}
	UpdateVerifyAvailable     = 驗證地址是否可用
	UpdateDownloadAddress     = 下載地址
	UpdateAvailable           = 可用
	UpdateUnavailable         = 不可用
	UpdateCurrent             = 當前使用版本
	UpdateLatest              = 可用最新版本
	UpdateNewLatest           = 發現新的可用版本！
	UpdateSkipUpdateCheck     = 預先配置策略，不允許首次執行自動更新。
	UpdateTimeUsed            = 所用的時間
	UpdatePostProc            = 後期處理
	UpdateNotExecuted         = 不執行
	UpdateNoPost              = 未找到後期處理任務
	UpdateUnpacking           = 正在解壓：
	UpdateDone                = 已成功更新！
	UpdateDoneRefresh         = 更新完成後，執行函數處理。
	UpdateUpdateStop          = 下載更新時發生錯誤，更新過程中止。
	UpdateInstall             = 您要安裝此更新嗎？
	UpdateInstallSel          = 是，將安裝上述更新\n否，則不會安裝該更新
	UpdateNotSatisfied        = \n  不滿足最低更新程序版本要求，\n\n  最低要求版本：{0}\n\n  請重新下載。\n\n  檢查更新已中止。 \
	IsAllowSHA256Check        = 允許校驗 SHA256 雜湊值
	GetSHAFailed              = 取得下載檔案對比的哈希失敗。
	Verify_Done               = 驗證成功。
	Verify_Failed             = 驗證失敗，哈希不匹配。"最低要求版本：{0}\n\n  請重新下載 {1}'s Solutions 的副本，以更新此工具。 \n\n  檢查更新已中止。 \
	Auto_Update_Allow         = 允許後台自動檢查更新
	Auto_Update_New_Allow     = 檢查到有新的更新時，允許自動更新
	Auto_Check_Time           = 小時，每次自動檢查間隔時間
	Auto_Last_Check_Time      = 上次自動更新檢查時間
	Auto_Next_Check_Time      = 未超過 {0} 小時，下次檢查時間
	Auto_First_Check          = 未執行過更新檢查，將執行首次更新檢查
	Auto_Update_Last_status   = 上次更新狀態
	Auto_Update_IsLatest      = 已經是最新的版本。
'@