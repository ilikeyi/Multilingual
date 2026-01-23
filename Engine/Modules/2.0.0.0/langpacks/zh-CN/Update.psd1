ConvertFrom-StringData -StringData @'
	# zh-CN
	# Chinese (Simplified, China)

	ChkUpdate                 = 检查更新
	UpdateServerSelect        = 自动选择服务器或自定义选择
	UpdateServerNoSelect      = 请选择可用的服务器
	UpdateSilent              = 有可用更新时，静默更新
	UpdateClean               = 允许空闲时清理旧版本
	ForceUpdate               = 强行检查并更新
	UpdateReset               = 重置此解决方案
	UpdateResetTips           = 下载地址可用时，强制下载并自动更新。
	UpdateCheckServerStatus   = 检查服务器状态 ( 共 {0} 个可选 )
	UpdateServerAddress       = 服务器地址
	UpdatePriority            = 已设置为优先级
	UpdateServerTestFailed    = 未通过服务器状态测试
	UpdateQueryingUpdate      = 正在查询更新中...
	UpdateQueryingTime        = 正检查是否有最新版本可用，连接耗时 {0} 毫秒。
	UpdateConnectFailed       = 无法连接到远程服务器，检查更新已中止。
	UpdateREConnect           = 连接失败，正在进行第 {0}/{1} 次重试。
	UpdateMinimumVersion      = 满足最低更新程序版本要求，最低要求版本：{0}
	UpdateVerifyAvailable     = 验证地址是否可用
	UpdateDownloadAddress     = 下载地址
	UpdateAvailable           = 可用
	UpdateUnavailable         = 不可用
	UpdateCurrent             = 当前使用版本
	UpdateLatest              = 可用最新版本
	UpdateNewLatest           = 发现新的可用版本！
	UpdateSkipUpdateCheck     = 预配置策略，不允许首次运行自动更新。
	UpdateTimeUsed            = 所用的时间
	UpdatePostProc            = 后期处理
	UpdateNotExecuted         = 不执行
	UpdateNoPost              = 未找到后期处理任务
	UpdateUnpacking           = 正在解压
	UpdateDone                = 已成功更新！
	UpdateDoneRefresh         = 更新完成后，执行函数处理。
	UpdateUpdateStop          = 下载更新时发生错误，更新过程中止。
	UpdateInstall             = 您要安装此更新吗？
	UpdateInstallSel          = 是，将安装上述更新\n否，则不会安装该更新
	UpdateNoUpdateAvailable   = \n  没有可用的更新。\n\n  您正在运行 {0}'s Solutions 的最新可用版本。\n
	UpdateNotSatisfied        = \n  不满足最低更新程序版本要求，\n\n  最低要求版本：{0}\n\n  请重新下载 {1}'s Solutions 的副本，以更新此工具。\n\n  检查更新已中止。\n
	IsAllowSHA256Check        = 允许校验 SHA256 哈希值
	GetSHAFailed              = 获取下载文件对比的哈希失败。
	Verify_Done               = 验证成功。
	Verify_Failed             = 验证失败，哈希不匹配。
	Auto_Update_Allow         = 允许后台自动检查更新
	Auto_Update_New_Allow     = 检查到有新的更新时，允许自动更新
	Auto_Check_Time           = 小时，每次自动检查间隔时间
	Auto_Last_Check_Time      = 上次自动更新检查时间
	Auto_Next_Check_Time      = 未超过 {0} 小时，下次检查时间
	Auto_First_Check          = 未执行过更新检查，将执行首次更新检查
	Auto_Update_Last_status   = 上次更新状态
	Auto_Update_IsLatest      = 您正在运行 {0} 的是最新版。
'@