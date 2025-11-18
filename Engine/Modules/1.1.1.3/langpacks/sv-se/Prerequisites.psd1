ConvertFrom-StringData -StringData @'
	# sv-SE
	# Swedish (Sweden)

	Prerequisites                   = Förutsättningar
	Check_PSVersion                 = Kontrollera PS version 5.1 och högre
	Check_OSVersion                 = Kontrollera Windows-version > 10.0.16299.0
	Check_Higher_elevated           = Check måste höjas till högre privilegier
	Check_execution_strategy        = Kontrollera exekveringsstrategi

	Check_Pass                      = Passera
	Check_Did_not_pass              = Misslyckades
	Check_Pass_Done                 = Grattis, godkänd.
	How_solve                       = Hur man löser
	UpdatePSVersion                 = Installera den senaste PowerShell-versionen
	UpdateOSVersion                 = 1. Gå till Microsofts officiella webbplats för att ladda ner den senaste versionen av operativsystemet\n   2. Installera den senaste versionen av operativsystemet och försök igen
	HigherTermail                   = 1. Öppna Terminal eller PowerShell ISE som administratör, \n      Ställ in PowerShell-körningspolicy: Bypass, PS-kommandorad: \n\n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n   2. När det är löst, kör kommandot igen.
	HigherTermailAdmin              = 1. Öppna Terminal eller PowerShell ISE som administratör. \n    2. När det är löst, kör kommandot igen.
'@