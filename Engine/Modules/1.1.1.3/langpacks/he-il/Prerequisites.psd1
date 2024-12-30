ConvertFrom-StringData -StringData @'
	# he-IL
	# Hebrew (Israel)

	Prerequisites                   = דרישות מוקדמות
	Check_PSVersion                 = בדוק PS גרסה 5.1 ומעלה
	Check_OSVersion                 = בדוק את גרסת Windows > 10.0.16299.0
	Check_Higher_elevated           = יש להעלות את ההמחאה להרשאות גבוהות יותר
	Check_execution_strategy        = בדוק אסטרטגיית ביצוע

	Check_Pass                      = לַעֲבוֹר
	Check_Did_not_pass              = נִכשָׁל
	Check_Pass_Done                 = מזל טוב, עבר.
	How_solve                       = איך לפתור
	UpdatePSVersion                 = אנא התקן את גרסת PowerShell העדכנית ביותר
	UpdateOSVersion                 = 1. עבור לאתר הרשמי של מיקרוסופט כדי להוריד את הגרסה העדכנית ביותר של מערכת ההפעלה\n   2. התקן את הגרסה העדכנית ביותר של מערכת ההפעלה ונסה שוב
	HigherTermail                   = 1. פתח את Terminal או PowerShell ISE כמנהל, \n      הגדר מדיניות ביצוע של PowerShell: עוקף, שורת פקודה PS: \n\n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force\n\n   2. לאחר פתרון, הפעל מחדש את הפקודה.
	HigherTermailAdmin              = 1. פתח את Terminal או PowerShell ISE כמנהל. \n    2. לאחר פתרון, הפעל מחדש את הפקודה.
'@