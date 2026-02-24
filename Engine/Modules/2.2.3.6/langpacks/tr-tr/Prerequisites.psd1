ConvertFrom-StringData -StringData @'
	# tr-TR
	# Turkish (Turkey)

	Prerequisites                   = Önkoşullar
	Check_PSVersion                 = PS sürüm 5.1 ve üstünü kontrol edin
	Check_OSVersion                 = Windows sürümünü kontrol edin > 10.0.16299.0
	Check_Higher_elevated           = Çekin daha yüksek ayrıcalıklara yükseltilmesi gerekiyor
	Check_execution_strategy        = Yürütme stratejisini kontrol edin

	Check_Pass                      = Geçmek
	Check_Did_not_pass              = Arızalı
	Check_Pass_Done                 = Tebrikler, geçti.
	How_solve                       = Nasıl çözülür?
	UpdatePSVersion                 = Lütfen en son PowerShell sürümünü yükleyin
	UpdateOSVersion                 = 1. İşletim sisteminin en son sürümünü indirmek için Microsoft'un resmi web sitesine gidin\n   2. İşletim sisteminin en son sürümünü yükleyin ve tekrar deneyin
	HigherTermail                   = 1. Terminal veya PowerShell ISE'yi yönetici olarak açın, \n      PowerShell yürütme politikasını ayarlayın: Baypas, PS komut satırı: \n\n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n   2. Çözüldükten sonra komutu yeniden çalıştırın.
	HigherTermailAdmin              = 1. Terminal veya PowerShell ISE'yi yönetici olarak açın. \n    2. Çözüldükten sonra komutu yeniden çalıştırın.
'@