ConvertFrom-StringData -StringData @'
	# lv-LV
	# Latvian (Latvia)

	Prerequisites                   = Priekšnoteikumi
	Check_PSVersion                 = Pārbaudiet PS versiju 5.1 un jaunāku versiju
	Check_OSVersion                 = Pārbaudiet Windows versiju > 10.0.16299.0
	Check_Higher_elevated           = Čekam jābūt paaugstinātam, lai iegūtu augstākas privilēģijas
	Check_execution_strategy        = Pārbaudiet izpildes stratēģiju

	Check_Pass                      = Caurlaide
	Check_Did_not_pass              = Neizdevās
	Check_Pass_Done                 = Apsveicu, pagājis.
	How_solve                       = Kā atrisināt
	UpdatePSVersion                 = Lūdzu, instalējiet jaunāko PowerShell versiju
	UpdateOSVersion                 = 1. Dodieties uz Microsoft oficiālo vietni, lai lejupielādētu jaunāko operētājsistēmas versiju\n   2. Instalējiet jaunāko operētājsistēmas versiju un mēģiniet vēlreiz
	HigherTermail                   = 1. Atveriet termināli vai PowerShell ISE kā administratoru, \n      Iestatīt PowerShell izpildes politiku: apiet, PS komandrinda: \n\n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n   2. Kad tas ir atrisināts, palaidiet komandu vēlreiz.
	HigherTermailAdmin              = 1. Atveriet termināli vai PowerShell ISE kā administratoru. \n    2. Kad tas ir atrisināts, palaidiet komandu vēlreiz.
'@