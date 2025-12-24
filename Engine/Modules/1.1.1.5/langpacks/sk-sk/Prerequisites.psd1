ConvertFrom-StringData -StringData @'
	# sk-SK
	# Slovak (Slovakia)

	Prerequisites                   = Predpoklady
	Check_PSVersion                 = Skontrolujte verziu PS 5.1 a vyššiu
	Check_OSVersion                 = Skontrolujte verziu systému Windows > 10.0.16299.0
	Check_Higher_elevated           = Kontrola musí byť povýšená na vyššie oprávnenia
	Check_execution_strategy        = Skontrolujte stratégiu vykonávania

	Check_Pass                      = Prejsť
	Check_Did_not_pass              = Nepodarilo
	Check_Pass_Done                 = Gratulujem, prešiel.
	How_solve                       = Ako vyriešiť
	UpdatePSVersion                 = Nainštalujte si najnovšiu verziu prostredia PowerShell
	UpdateOSVersion                 = 1. Prejdite na oficiálnu webovú stránku spoločnosti Microsoft a stiahnite si najnovšiu verziu operačného systému\n   2. Nainštalujte najnovšiu verziu operačného systému a skúste to znova
	HigherTermail                   = 1. Otvorte terminál alebo PowerShell ISE ako správca, \n      Nastaviť politiku vykonávania prostredia PowerShell: Obísť, príkazový riadok PS: \n\n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n   2. Po vyriešení príkaz znova spustite.
	HigherTermailAdmin              = 1. Otvorte terminál alebo PowerShell ISE ako správca. \n    2. Po vyriešení príkaz znova spustite.
'@