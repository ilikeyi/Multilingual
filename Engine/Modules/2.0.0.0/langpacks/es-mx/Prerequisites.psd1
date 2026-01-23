ConvertFrom-StringData -StringData @'
	# es-MX
	# Spanish (Mexico)

	Prerequisites                   = Requisitos previos
	Check_PSVersion                 = Verifique la versión de PS 5.1 y superior
	Check_OSVersion                 = Verifique la versión de Windows > 10.0.16299.0
	Check_Higher_elevated           = El cheque debe estar elevado a privilegios más altos
	Check_execution_strategy        = Verificar estrategia de ejecución

	Check_Pass                      = Aprobar
	Check_Did_not_pass              = Fallido
	Check_Pass_Done                 = Felicitaciones, pasó.
	How_solve                       = Como resolver
	UpdatePSVersion                 = Instale la última versión de PowerShell
	UpdateOSVersion                 = 1. Vaya al sitio web oficial de Microsoft para descargar la última versión del sistema operativo.\n   2. Instale la última versión del sistema operativo y vuelva a intentarlo
	HigherTermail                   = 1. Abra Terminal o PowerShell ISE como administrador, \n      Establecer política de ejecución de PowerShell: omitir, línea de comando PS: \n\n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n   2. Una vez resuelto, vuelva a ejecutar el comando.
	HigherTermailAdmin              = 1. Abra Terminal o PowerShell ISE como administrador. \n    2. Una vez resuelto, vuelva a ejecutar el comando.
'@