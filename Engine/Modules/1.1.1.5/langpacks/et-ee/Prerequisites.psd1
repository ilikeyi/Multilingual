ConvertFrom-StringData -StringData @'
	# et-EE
	# Estonian (Estonia)

	Prerequisites                   = Eeldused
	Check_PSVersion                 = Kontrollige PS versiooni 5.1 ja uuemat
	Check_OSVersion                 = Kontrollige Windowsi versiooni > 10.0.16299.0
	Check_Higher_elevated           = Tšekk peab olema tõstetud kõrgematele õigustele
	Check_execution_strategy        = Kontrollige täitmisstrateegiat

	Check_Pass                      = Läbida
	Check_Did_not_pass              = Ebaõnnestunud
	Check_Pass_Done                 = Õnnitleme, läbitud.
	How_solve                       = Kuidas lahendada
	UpdatePSVersion                 = Installige uusim PowerShelli versioon
	UpdateOSVersion                 = 1. Operatsioonisüsteemi uusima versiooni allalaadimiseks minge Microsofti ametlikule veebisaidile\n   2. Installige operatsioonisüsteemi uusim versioon ja proovige uuesti
	HigherTermail                   = 1. Avage administraatorina terminal või PowerShell ISE, \n      Seadke PowerShelli täitmispoliitika: ümbersõit, PS-i käsurida: \n\n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n   2. Kui see on lahendatud, käivitage käsk uuesti.
	HigherTermailAdmin              = 1. Avage administraatorina terminal või PowerShell ISE.\n    2. Kui see on lahendatud, käivitage käsk uuesti.
'@