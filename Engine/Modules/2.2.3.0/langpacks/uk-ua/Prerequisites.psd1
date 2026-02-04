ConvertFrom-StringData -StringData @'
	# uk-UA
	# Ukrainian (Ukraine)

	Prerequisites                   = передумови
	Check_PSVersion                 = Перевірте PS версії 5.1 і вище
	Check_OSVersion                 = Перевірте версію Windows > 10.0.16299.0
	Check_Higher_elevated           = Чек повинен бути підвищений до вищих привілеїв
	Check_execution_strategy        = Перевірити стратегію виконання

	Check_Pass                      = пропуск
	Check_Did_not_pass              = не вдалося
	Check_Pass_Done                 = Вітаю, пройдено.
	How_solve                       = Як вирішити
	UpdatePSVersion                 = Установіть останню версію PowerShell
	UpdateOSVersion                 = 1. Перейдіть на офіційний сайт Microsoft, щоб завантажити останню версію операційної системи\n   2. Установіть останню версію операційної системи та повторіть спробу
	HigherTermail                   = 1. Відкрийте термінал або PowerShell ISE як адміністратор, \n      Налаштуйте політику виконання PowerShell: обхід, командний рядок PS: \n\n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n   2. Після вирішення повторно запустіть команду.
	HigherTermailAdmin              = 1. Відкрийте термінал або PowerShell ISE як адміністратор. \n    2. Після вирішення повторно запустіть команду.
'@