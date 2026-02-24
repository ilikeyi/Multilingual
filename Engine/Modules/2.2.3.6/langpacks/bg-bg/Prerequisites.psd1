ConvertFrom-StringData -StringData @'
	# bg-BG
	# Bulgarian (Bulgaria)

	Prerequisites                   = Предпоставки
	Check_PSVersion                 = Проверете PS версия 5.1 и по-нова
	Check_OSVersion                 = Проверете версия на Windows > 10.0.16299.0
	Check_Higher_elevated           = Чекът трябва да бъде повишен до по-високи привилегии
	Check_execution_strategy        = Проверете стратегията за изпълнение

	Check_Pass                      = Пас
	Check_Did_not_pass              = Не успя
	Check_Pass_Done                 = Поздравления, премина.
	How_solve                       = Как да решим
	UpdatePSVersion                 = Моля, инсталирайте най-новата версия на PowerShell
	UpdateOSVersion                 = 1. Отидете на официалния уебсайт на Microsoft, за да изтеглите най-новата версия на операционната система\n   2. Инсталирайте най-новата версия на операционната система и опитайте отново
	HigherTermail                   = 1. Отворете терминал или PowerShell ISE като администратор, \n      Задайте политика за изпълнение на PowerShell: Bypass, PS команден ред: \n\n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n   2. След като бъде решен, изпълнете отново командата.
	HigherTermailAdmin              = 1. Отворете терминал или PowerShell ISE като администратор. \n    2. След като бъде решен, изпълнете отново командата.
'@