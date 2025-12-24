ConvertFrom-StringData -StringData @'
	# el-GR
	# Greek (Greece)

	Prerequisites                   = Προαπαιτούμενα
	Check_PSVersion                 = Ελέγξτε την έκδοση PS 5.1 και νεότερη
	Check_OSVersion                 = Ελέγξτε την έκδοση των Windows > 10.0.16299.0
	Check_Higher_elevated           = Η επιταγή πρέπει να ανυψωθεί σε υψηλότερα προνόμια
	Check_execution_strategy        = Ελέγξτε τη στρατηγική εκτέλεσης

	Check_Pass                      = Πέρασμα
	Check_Did_not_pass              = Αποτυχημένος
	Check_Pass_Done                 = Συγχαρητήρια, πέρασε.
	How_solve                       = Πώς να λύσετε
	UpdatePSVersion                 = Εγκαταστήστε την πιο πρόσφατη έκδοση PowerShell
	UpdateOSVersion                 = 1. Μεταβείτε στον επίσημο ιστότοπο της Microsoft για λήψη της πιο πρόσφατης έκδοσης του λειτουργικού συστήματος\n   2. Εγκαταστήστε την πιο πρόσφατη έκδοση του λειτουργικού συστήματος και δοκιμάστε ξανά
	HigherTermail                   = 1. Ανοίξτε το Terminal ή το PowerShell ISE ως διαχειριστής, \n      Ορισμός πολιτικής εκτέλεσης PowerShell: Παράκαμψη, γραμμή εντολών PS: \n\n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n   2. Μόλις επιλυθεί, εκτελέστε ξανά την εντολή.
	HigherTermailAdmin              = 1. Ανοίξτε το Terminal ή το PowerShell ISE ως διαχειριστής. \n    2. Μόλις επιλυθεί, εκτελέστε ξανά την εντολή.
'@