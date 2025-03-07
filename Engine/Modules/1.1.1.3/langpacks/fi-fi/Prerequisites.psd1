ConvertFrom-StringData -StringData @'
	# fi-FI
	# Finnish (Finland)

	Prerequisites                   = Edellytykset
	Check_PSVersion                 = Tarkista PS-versio 5.1 ja uudemmat
	Check_OSVersion                 = Tarkista Windows-versio > 10.0.16299.0
	Check_Higher_elevated           = Sekki on korotettava korkeampiin oikeuksiin
	Check_execution_strategy        = Tarkista toteutusstrategia

	Check_Pass                      = Syöttö
	Check_Did_not_pass              = Epäonnistunut
	Check_Pass_Done                 = Onnittelut, ohitettu.
	How_solve                       = Miten ratkaista
	UpdatePSVersion                 = Asenna uusin PowerShell-versio
	UpdateOSVersion                 = 1. Lataa käyttöjärjestelmän uusin versio siirtymällä Microsoftin viralliselle verkkosivustolle\n   2. Asenna käyttöjärjestelmän uusin versio ja yritä uudelleen
	HigherTermail                   = 1. Avaa Terminal tai PowerShell ISE järjestelmänvalvojana, \n      Aseta PowerShell-suorituskäytäntö: Ohitus, PS-komentorivi: \n\n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n   2. Kun se on ratkaistu, suorita komento uudelleen.
	HigherTermailAdmin              = 1. Avaa Terminal tai PowerShell ISE järjestelmänvalvojana. \n    2. Kun se on ratkaistu, suorita komento uudelleen.
'@