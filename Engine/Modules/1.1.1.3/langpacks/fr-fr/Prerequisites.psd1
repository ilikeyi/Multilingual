ConvertFrom-StringData -StringData @'
	# fr-FR
	# French (France)

	Prerequisites                   = Conditions préalables
	Check_PSVersion                 = Vérifiez la version PS 5.1 et supérieure
	Check_OSVersion                 = Vérifiez la version de Windows > 10.0.16299.0
	Check_Higher_elevated           = Le chèque doit être élevé à des privilèges plus élevés
	Check_execution_strategy        = Vérifier la stratégie d'exécution

	Check_Pass                      = Passer
	Check_Did_not_pass              = Échoué
	Check_Pass_Done                 = Félicitations, c'est réussi.
	How_solve                       = Comment résoudre
	UpdatePSVersion                 = Veuillez installer la dernière version de PowerShell
	UpdateOSVersion                 = 1. Accédez au site officiel de Microsoft pour télécharger la dernière version du système d'exploitation\n   2. Installez la dernière version du système d'exploitation et réessayez
	HigherTermail                   = 1. Ouvrez Terminal ou PowerShell ISE en tant qu'administrateur, \n      Définir la politique d'exécution PowerShell: contourner, ligne de commande PS: \n\n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n   2. Une fois résolu, réexécutez la commande.
	HigherTermailAdmin              = 1. Ouvrez Terminal ou PowerShell ISE en tant qu'administrateur. \n    2. Une fois résolu, réexécutez la commande.
'@