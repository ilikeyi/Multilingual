ConvertFrom-StringData -StringData @'
	# ru-RU
	# Russian (Russia)

	Prerequisites                   = Предварительные условия
	Check_PSVersion                 = Проверьте версию PS 5.1 и выше.
	Check_OSVersion                 = Проверьте версию Windows > 10.0.16299.0.
	Check_Higher_elevated           = Проверка должна быть повышена до более высоких привилегий
	Check_execution_strategy        = Проверьте стратегию исполнения

	Check_Pass                      = Проходить
	Check_Did_not_pass              = Неуспешный
	Check_Pass_Done                 = Поздравляю, прошло.
	How_solve                       = Как решить
	UpdatePSVersion                 = Пожалуйста, установите последнюю версию PowerShell.
	UpdateOSVersion                 = 1. Перейдите на официальный сайт Microsoft, чтобы загрузить последнюю версию операционной системы.\n   2. Установите последнюю версию операционной системы и повторите попытку.
	HigherTermail                   = 1. Откройте терминал или PowerShell ISE от имени администратора, \n      Установите политику выполнения PowerShell: Обход, командная строка PS: \n\n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n   2. После решения повторите команду.
	HigherTermailAdmin              = 1. Откройте терминал или PowerShell ISE от имени администратора. \n    2. После решения повторите команду.
'@