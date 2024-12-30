<#
	.Summary
	 Yi's Solutions

	.Open "Terminal" or "PowerShell ISE" as an administrator,
	 set PowerShell execution policy: Bypass, PS command line: 

	 Set-ExecutionPolicy -ExecutionPolicy Bypass -Force

	.Example
	 PS C:\> .\_get.ps1                   | User interactive
	 PS C:\> .\_get.ps1 -Reset            | Reset script usage history

	 PS C:\> .\_get.ps1 -Cus              | Any website connection, example: 
											"https://fengyi.tel/latest.zip", "https://Github.com/latest.zip"

	 PS C:\> .\_get.ps1 -To               | Install to
											"AutoSelectDisk" = Automatically search available disks
											"Desktop"        = Current user desktop
											"Download"       = Current user downloads
											"Documents"      = Current user documents

	 PS C:\> .\_get.ps1 -GoTo             | After installation, go to
											"Main"           = Main Program
											"Upgrade"        = Creating an upgrade package
											"No"             = Do not go

	 PS C:\> .\_get.ps1 -Silent           | After customizing the interactive mode, you can add a silent installation command to perform the installation.

	.Learn
	 Interactive installation
		https://github.com/ilikeyi/Multilingual/blob/main/_Learn/Get/Get.pdf

	.LINK
	 https://github.com/ilikeyi/Multilingual

	.About
	 Author:  Yi
	 Website: http://fengyi.tel
#>

[CmdletBinding()]
param
(
	[String]
	$Language,

	[Switch]
	$Reset,

	[String[]]
	$Cus,

	[String]
	$To,

	[String]
	$GoTo,

	[switch]
	$Silent
)

$Default_directory_name = "Multilingual"
$Update_Server = @(
	"https://fengyi.tel/download/solutions/update/Multilingual/latest.zip"
	"https://github.com/ilikeyi/Multilingual/raw/main/update/latest.zip"
)

<#
	.Language
#>
$Global:lang = @()
$Global:IsLang = ""
$AvailableLanguages = @(
	@{
		Region   = "en-US"
		Name     = "English (United States)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Get it online Automatically add installed languages to Windows systems"
			UpdateServerSelect       = "Automatic server selection or custom selection"
			UpdateServerNoSelect     = "Please select an available server"
			UpdatePriority           = "has been set as priority"
			UpdateServerTestFailed   = "Failed server status test"
			UpdateQueryingUpdate     = "Querying and updating..."
			UpdateQueryingTime       = "Checking if the latest version is available,`n  the connection took {0} milliseconds."
			UpdateConnectFailed      = "Unable to connect to the remote server, access to online has been aborted."
			UpdateCheckServerStatus  = "Check server status ( total {0} optional )"
			UpdateServerAddress      = "Server address"
			UpdateServeravailable    = "Status: Available"
			UpdateServerUnavailable  = "Status: Unavailable"
			InstlTo                  = "Install to, new name"
			SelectFolder             = "Select directory"
			OpenFolder               = "Open Directory"
			Paste                    = "Copy path"
			FailedCreateFolder       = "Failed to create directory"
			Failed                   = "Failed"
			IsOldFile                = "Please delete the old file and try again"
			RestoreTo                = "Automatically select when restoring the installation path"
			RestoreToDisk            = "Automatically select available disk"
			RestoreToDesktop         = "Desktop"
			RestoreToDownload        = "Download"
			RestoreToDocuments       = "Documents"
			FileName                 = "File name"
			Done                     = "Done"
			Inoperable               = "Inoperable"
			FileFormatError          = "File format error."
			AdvOption                = "Optional function"
			Ok_Go_To                 = "First visit to"
			Ok_Go_To_Main            = "Main Program"
			Ok_Go_To_No              = "Not going"
			OK_Go_To_Upgrade_package = "Creating an upgrade package"
			Unpacking                = "Unpacking"
			Running                  = "Running"
			SaveTo                   = "Save to"
			OK                       = "OK"
			Cancel                   = "Cancel"
			UserCancel               = "The user has cancelled the operation."
			AllSel                   = "Select all"
			AllClear                 = "Clear all"
			Prerequisites            = "Prerequisites"
			Check_PSVersion          = "Checking PS version 5.1 and above"
			Check_OSVersion          = "Checking Windows version > 10.0.16299.0"
			Check_Higher_elevated    = "Checking Must be elevated to higher authority"
			Check_execution_strategy = "Check execution strategy"
			Check_Pass               = "Pass"
			Check_Did_not_pass       = "Did not pass"
			Check_Pass_Done          = "Congratulations, it has passed."
			How_solve                = "How to solve it"
			UpdatePSVersion          = "Please install the latest PowerShell version"
			UpdateOSVersion          = "1. Go to the official Microsoft website to download the latest`n      version of the operating system`n`n   2. Install the latest version of the operating system and try again"
			HigherTermail            = "1. Open ""Terminal"" or ""PowerShell ISE"" as an administrator, `n      set PowerShell execution policy: Bypass, PS command line: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Once resolved, rerun the command."
			HigherTermailAdmin       = "1. Open Terminal or PowerShell ISE as an administrator.`n    2. Once resolved, rerun the command."
		}
	}
	@{
		Region   = "ar-SA"
		Name     = "Arabic (Saudi Arabia)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "احصل عليه عبر الإنترنت قم بإضافة اللغات المثبتة تلقائيًا إلى نظام Windows الخاص بك"
			UpdateServerSelect       = "اختيار الخادم التلقائي أو الاختيار المخصص"
			UpdateServerNoSelect     = "الرجاء تحديد الخادم المتاح"
			UpdatePriority           = "تم تعيينها بالفعل كأولوية"
			UpdateServerTestFailed   = "فشل اختبار حالة الخادم"
			UpdateQueryingUpdate     = "الاستعلام عن التحديثات..."
			UpdateQueryingTime       = "جارٍ التحقق لمعرفة ما إذا كان الإصدار الأحدث متاحًا، استغرق الاتصال {0} مللي ثانية."
			UpdateConnectFailed      = "غير قادر على الاتصال بالخادم البعيد، تم إحباط البحث عن التحديثات."
			UpdateCheckServerStatus  = "التحقق من حالة الخادم ( يتوفر {0} من الخيارات )"
			UpdateServerAddress      = "عنوان الخادم"
			UpdateServeravailable    = "الحالة: متاح"
			UpdateServerUnavailable  = "الحالة: غير متوفر"
			InstlTo                  = "التثبيت على الاسم الجديد"
			SelectFolder             = "حدد الدليل"
			OpenFolder               = "افتح الدليل"
			Paste                    = "مسار النسخ"
			FailedCreateFolder       = "فشل في إنشاء الدليل"
			Failed                   = "يفشل"
			IsOldFile                = "يرجى حذف الملفات القديمة والمحاولة مرة أخرى"
			RestoreTo                = "يتم تحديده تلقائيًا عند استعادة مسار التثبيت"
			RestoreToDisk            = "تحديد الأقراص المتوفرة تلقائيًا"
			RestoreToDesktop         = "سطح المكتب"
			RestoreToDownload        = "تحميل"
			RestoreToDocuments       = "وثيقة"
			FileName                 = "اسم الملف"
			Done                     = "ينهي"
			Inoperable               = "غير صالح للعمل"
			FileFormatError          = "تنسيق الملف غير صحيح"
			AdvOption                = "ميزات اختيارية"
			Ok_Go_To                 = "متاح ل"
			Ok_Go_To_Main            = "البرنامج الرئيسي"
			Ok_Go_To_No              = "لن أذهب"
			OK_Go_To_Upgrade_package = "إنشاء حزمة ترقية محرك النشر"
			Unpacking                = "فك الضغط"
			Running                  = "جري"
			SaveTo                   = "حفظ ل"
			OK                       = "بالتأكيد"
			Cancel                   = "يلغي"
			UserCancel               = "لقد ألغى المستخدم العملية."
			AllSel                   = "حدد الكل"
			AllClear                 = "مسح الكل"
			Prerequisites            = "المتطلبات الأساسية"
			Check_PSVersion          = "تحقق من إصدار PS 5.1 وما فوق"
			Check_OSVersion          = "تحقق من إصدار Windows> 10.0.16299.0"
			Check_Higher_elevated    = "يجب أن يتم رفع الشيك إلى امتيازات أعلى"
			Check_execution_strategy = "التحقق من استراتيجية التنفيذ"
			Check_Pass               = "يمر"
			Check_Did_not_pass       = "فشل"
			Check_Pass_Done          = "مبروك، مرت."
			How_solve                = "كيفية الحل"
			UpdatePSVersion          = "الرجاء تثبيت أحدث إصدار من PowerShell"
			UpdateOSVersion          = "1. انتقل إلى موقع Microsoft الرسمي لتنزيل أحدث إصدار من نظام التشغيل`n   2. قم بتثبيت أحدث إصدار من نظام التشغيل وحاول مرة أخرى"
			HigherTermail            = "1. افتح ""المحطة الطرفية"" أو ""PowerShell ISE"" كمسؤول،, `n      تعيين سياسة تنفيذ PowerShell: التجاوز، سطر أوامر PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. بمجرد حل المشكلة، أعد تشغيل الأمر."
			HigherTermailAdmin       = "1. افتح ""المحطة الطرفية"" أو ""PowerShell ISE"" كمسؤول،. `n    2. بمجرد حل المشكلة، أعد تشغيل الأمر."
		}
	}
	@{
		Region   = "bg-BG"
		Name     = "Bulgarian (Bulgaria)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Вземете го онлайн Автоматично добавяне на инсталирани езици към вашата Windows система"
			UpdateServerSelect       = "Автоматичен избор на сървър или персонализиран избор"
			UpdateServerNoSelect     = "Моля, изберете наличен сървър"
			UpdatePriority           = "Вече e зададен като приоритет"
			UpdateServerTestFailed   = "Неуспешен тест за състояние на сървъра"
			UpdateQueryingUpdate     = "Извършва ce заявка за актуализации..."
			UpdateQueryingTime       = "Проверка дали e налична най-новата версия, връзката отне {0} милисекунди."
			UpdateConnectFailed      = "He може да ce свърже c отдалечен сървър, проверката за актуализации e прекратена."
			UpdateCheckServerStatus  = "Проверете състоянието на сървъра ( налични ca {0} опции )"
			UpdateServerAddress      = "Адрес на сървъра"
			UpdateServeravailable    = "Статус: Наличен"
			UpdateServerUnavailable  = "Състояние: He e налично"
			InstlTo                  = "Инсталиране на, ново име"
			SelectFolder             = "Изберете директория"
			OpenFolder               = "Отворете директорията"
			Paste                    = "път за копиране"
			FailedCreateFolder       = "Неуспешно създаване на директория"
			Failed                   = "провалят ce"
			IsOldFile                = "Моля, изтрийте старите файлове и опитайте отново"
			RestoreTo                = "Избира ce автоматично при възстановяване на инсталационния път"
			RestoreToDisk            = "Автоматично избиране на наличните дискове"
			RestoreToDesktop         = "работен плот"
			RestoreToDownload        = "изтегляне"
			RestoreToDocuments       = "документ"
			FileName                 = "име на файл"
			Done                     = "Завършете"
			Inoperable               = "Неработоспособен"
			FileFormatError          = "Файловият формат e неправилен"
			AdvOption                = "Незадължителни функции"
			Ok_Go_To                 = "Ha разположение на"
			Ok_Go_To_Main            = "основна програма"
			Ok_Go_To_No              = "He отивам"
			OK_Go_To_Upgrade_package = "Създайте пакет за надграждане на машина за внедряване"
			Unpacking                = "Разархивиране"
			Running                  = "Бягане"
			SaveTo                   = "запази в"
			OK                       = "Разбира ce"
			Cancel                   = "Отказ"
			UserCancel               = "Потребителят e отменил операцията."
			AllSel                   = "Изберете всички"
			AllClear                 = "изчисти всичко"
			Prerequisites            = "Предпоставки"
			Check_PSVersion          = "Проверете PS версия 5.1 и по-нова"
			Check_OSVersion          = "Проверете версия на Windows > 10.0.16299.0"
			Check_Higher_elevated    = "Чекът трябва да бъде повишен до по-високи привилегии"
			Check_execution_strategy = "Проверете стратегията за изпълнение"
			Check_Pass               = "пас"
			Check_Did_not_pass       = "не успя"
			Check_Pass_Done          = "Поздравления, премина."
			How_solve                = "Как да решим"
			UpdatePSVersion          = "Моля, инсталирайте най-новата версия на PowerShell"
			UpdateOSVersion          = "1. Отидете на официалния уебсайт на Microsoft, за да изтеглите най-новата версия на операционната система`n   2. Инсталирайте най-новата версия на операционната система и опитайте отново"
			HigherTermail            = "1. Отворете ""Терминал"" или ""PowerShell ISE"" като администратор, `n      Задайте политика за изпълнение на PowerShell: Bypass, PS команден ред: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. След като бъде разрешено, изпълнете отново командата."
			HigherTermailAdmin       = "1. Отворете ""Терминал"" или ""PowerShell ISE"" като администратор. `n    2. След като бъде разрешено, изпълнете отново командата."
		}
	}
	@{
		Region   = "hr-HR"
		Name     = "Croatian (Croatia)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Nabavite ga online Automatski dodajte instalirane jezike u svoj Windows sustav"
			UpdateServerSelect       = "Automatski odabir poslužitelja ili prilagođeni odabir"
			UpdateServerNoSelect     = "Odaberite dostupni poslužitelj"
			UpdatePriority           = "Već je postavljeno kao prioritet"
			UpdateServerTestFailed   = "Neuspjeli test statusa poslužitelja"
			UpdateQueryingUpdate     = "Traženje ažuriranja..."
			UpdateQueryingTime       = "Provjeravam je li dostupna najnovija verzija, veza je trajala {0} milisekundi."
			UpdateConnectFailed      = "Nije moguće povezati se s udaljenim poslužiteljem, provjera ažuriranja je prekinuta."
			UpdateCheckServerStatus  = "Provjerite status poslužitelja ( dostupno {0} opcija )"
			UpdateServerAddress      = "Adresa poslužitelja"
			UpdateServeravailable    = "Status: Dostupan"
			UpdateServerUnavailable  = "Status: Nije dostupno"
			InstlTo                  = "Instaliraj na, novo ime"
			SelectFolder             = "Odaberite imenik"
			OpenFolder               = "Otvori imenik"
			Paste                    = "put kopiranja"
			FailedCreateFolder       = "Stvaranje imenika nije uspjelo"
			Failed                   = "uspjeti"
			IsOldFile                = "Molimo izbrišite stare datoteke i pokušajte ponovno"
			RestoreTo                = "Automatski odabrano prilikom vraćanja putanje instalacije"
			RestoreToDisk            = "Automatski odabir dostupnih diskova"
			RestoreToDesktop         = "radna površina"
			RestoreToDownload        = "preuzeti"
			RestoreToDocuments       = "dokument"
			FileName                 = "naziv datoteke"
			Done                     = "Završiti"
			Inoperable               = "Neoperabilan"
			FileFormatError          = "Format datoteke nije ispravan"
			AdvOption                = "Dodatne značajke"
			Ok_Go_To                 = "Na raspolaganju"
			Ok_Go_To_Main            = "glavni program"
			Ok_Go_To_No              = "Ne ide"
			OK_Go_To_Upgrade_package = "Stvorite paket za nadogradnju mehanizma za implementaciju"
			Unpacking                = "Otpakiranje"
			Running                  = "Trčanje"
			SaveTo                   = "spremiti u"
			OK                       = "Naravno"
			Cancel                   = "Otkazati"
			UserCancel               = "Korisnik je otkazao operaciju."
			AllSel                   = "Odaberite sve"
			AllClear                 = "jasno sve"
			Prerequisites            = "Preduvjeti"
			Check_PSVersion          = "Provjerite PS verziju 5.1 i novije"
			Check_OSVersion          = "Provjerite verziju sustava Windows > 10.0.16299.0"
			Check_Higher_elevated    = "Ček mora biti podignut na više privilegije"
			Check_execution_strategy = "Provjerite strategiju izvršenja"
			Check_Pass               = "proći"
			Check_Did_not_pass       = "nije uspio"
			Check_Pass_Done          = "Čestitam, prošao."
			How_solve                = "Kako riješiti"
			UpdatePSVersion          = "Instalirajte najnoviju verziju PowerShell-a"
			UpdateOSVersion          = "1. Idite na Microsoftovo službeno web mjesto kako biste preuzeli najnoviju verziju operativnog sustava`n   2. Instalirajte najnoviju verziju operativnog sustava i pokušajte ponovno"
			HigherTermail            = "1. Otvorite ""Terminal"" ili ""PowerShell ISE"" kao administrator, `n      Postavite politiku izvršavanja PowerShell-a: Zaobiđite, PS naredbeni redak: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Kada se riješi, ponovno pokrenite naredbu."
			HigherTermailAdmin       = "1. Otvorite ""Terminal"" ili ""PowerShell ISE"" kao administrator. `n    2. Kada se riješi, ponovno pokrenite naredbu."
		}
	}
	@{
		Region   = "cs-CZ"
		Name     = "Czech (Czech Republic)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Získejte online Automaticky přidejte nainstalované jazyky do systému Windows"
			UpdateServerSelect       = "Automatický výběr serveru nebo vlastní výběr"
			UpdateServerNoSelect     = "Vyberte dostupný server"
			UpdatePriority           = "Již nastaveno jako priorita"
			UpdateServerTestFailed   = "Neúspěšný test stavu serveru"
			UpdateQueryingUpdate     = "Dotaz na aktualizace..."
			UpdateQueryingTime       = "Kontrola, zda je k dispozici nejnovější verze, připojení trvalo {0} milisekund."
			UpdateConnectFailed      = "Nelze se připojit ke vzdálenému serveru, kontrola aktualizací byla přerušena."
			UpdateCheckServerStatus  = "Zkontrolujte stav serveru  (dostupné možnosti: {0} )"
			UpdateServerAddress      = "Adresa serveru"
			UpdateServeravailable    = "Stav: K dispozici"
			UpdateServerUnavailable  = "Stav: Není k dispozici"
			InstlTo                  = "Instalovat do, nový název"
			SelectFolder             = "Vyberte adresář"
			OpenFolder               = "Otevřete adresář"
			Paste                    = "kopírovat cestu"
			FailedCreateFolder       = "Vytvoření adresáře se nezdařilo"
			Failed                   = "selhat"
			IsOldFile                = "Odstraňte prosím staré soubory a zkuste to znovu"
			RestoreTo                = "Automaticky vybráno při obnově instalační cesty"
			RestoreToDisk            = "Automaticky vybrat dostupné disky"
			RestoreToDesktop         = "desktop"
			RestoreToDownload        = "stáhnout"
			RestoreToDocuments       = "dokument"
			FileName                 = "název souboru"
			Done                     = "Dokončit"
			Inoperable               = "Nefunkční"
			FileFormatError          = "Formát souboru je nesprávný"
			AdvOption                = "Volitelné funkce"
			Ok_Go_To                 = "K dispozici pro"
			Ok_Go_To_Main            = "hlavní program"
			Ok_Go_To_No              = "Nechodím"
			OK_Go_To_Upgrade_package = "Vytvořte balíček upgradu modulu nasazení"
			Unpacking                = "Rozepínání"
			Running                  = "Běh"
			SaveTo                   = "uložit do"
			OK                       = "Jasně"
			Cancel                   = "Zrušit"
			UserCancel               = "Uživatel operaci zrušil."
			AllSel                   = "Vyberte vše"
			AllClear                 = "vymazat vše"
			Prerequisites            = "Předpoklady"
			Check_PSVersion          = "Zkontrolujte verzi PS 5.1 a vyšší"
			Check_OSVersion          = "Zkontrolujte verzi Windows > 10.0.16299.0"
			Check_Higher_elevated    = "Kontrola musí být povýšena na vyšší oprávnění"
			Check_execution_strategy = "Zkontrolujte strategii provádění"
			Check_Pass               = "přihrávka"
			Check_Did_not_pass       = "nepodařilo"
			Check_Pass_Done          = "Gratuluji, prospělo."
			How_solve                = "Jak řešit"
			UpdatePSVersion          = "Nainstalujte si prosím nejnovější verzi PowerShellu"
			UpdateOSVersion          = "1. Přejděte na oficiální web společnosti Microsoft a stáhněte si nejnovější verzi operačního systému`n   2. Nainstalujte nejnovější verzi operačního systému a zkuste to znovu"
			HigherTermail            = "1. Otevřete ""Terminál"" nebo ""PowerShell ISE"" jako správce, `n      Nastavit zásady provádění PowerShellu: Obejít, příkazový řádek PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Po vyřešení spusťte příkaz znovu."
			HigherTermailAdmin       = "1. Otevřete ""Terminál"" nebo ""PowerShell ISE"" jako správce. `n    2. Po vyřešení spusťte příkaz znovu."
		}
	}
	@{
		Region   = "da-DK"
		Name     = "Danish (Denmark)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Få det online Tilføj automatisk installerede sprog til dit Windows-system"
			UpdateServerSelect       = "Automatisk servervalg eller brugerdefineret valg"
			UpdateServerNoSelect     = "Vælg venligst en tilgængelig server"
			UpdatePriority           = "Allerede sat som prioritet"
			UpdateServerTestFailed   = "Mislykket serverstatustest"
			UpdateQueryingUpdate     = "Forespørger efter opdateringer..."
			UpdateQueryingTime       = "Ved at tjekke, om den nyeste version er tilgængelig, tog forbindelsen {0} millisekunder."
			UpdateConnectFailed      = "Kan ikke oprette forbindelse til fjernserveren, søger efter opdateringer afbrudt."
			UpdateCheckServerStatus  = "Tjek serverstatus ( {0} tilgængelige muligheder )"
			UpdateServerAddress      = "Serveradresse"
			UpdateServeravailable    = "Status: Tilgængelig"
			UpdateServerUnavailable  = "Status: Ikke tilgængelig"
			InstlTo                  = "Installer til, nyt navn"
			SelectFolder             = "Vælg bibliotek"
			OpenFolder               = "Åbn mappe"
			Paste                    = "kopisti"
			FailedCreateFolder       = "Det lykkedes ikke at oprette mappe"
			Failed                   = "svigte"
			IsOldFile                = "Slet venligst de gamle filer og prøv igen"
			RestoreTo                = "Automatisk valgt ved gendannelse af installationsstien"
			RestoreToDisk            = "Vælg automatisk tilgængelige diske"
			RestoreToDesktop         = "skrivebord"
			RestoreToDownload        = "download"
			RestoreToDocuments       = "dokument"
			FileName                 = "filnavn"
			Done                     = "Slutte"
			Inoperable               = "Ubrugelig"
			FileFormatError          = "Filformatet er forkert"
			AdvOption                = "Valgfrie funktioner"
			Ok_Go_To                 = "Tilgængelig til"
			Ok_Go_To_Main            = "hovedprogram"
			Ok_Go_To_No              = "Går ikke"
			OK_Go_To_Upgrade_package = "Opret en opgraderingspakke til implementeringsmotor"
			Unpacking                = "Udpakker"
			Running                  = "Løb"
			SaveTo                   = "gemme til"
			OK                       = "Sikker"
			Cancel                   = "Ophæve"
			UserCancel               = "Brugeren har annulleret handlingen."
			AllSel                   = "Vælg alle"
			AllClear                 = "ryd alt"
			Prerequisites            = "Forudsætninger"
			Check_PSVersion          = "Tjek PS version 5.1 og nyere"
			Check_OSVersion          = "Tjek Windows-version > 10.0.16299.0"
			Check_Higher_elevated    = "Check skal hæves til højere privilegier"
			Check_execution_strategy = "Tjek udførelsesstrategi"
			Check_Pass               = "passere"
			Check_Did_not_pass       = "mislykkedes"
			Check_Pass_Done          = "Tillykke, bestået."
			How_solve                = "Sådan løses"
			UpdatePSVersion          = "Installer venligst den seneste PowerShell-version"
			UpdateOSVersion          = "1. Gå til Microsofts officielle hjemmeside for at downloade den seneste version af operativsystemet`n   2. Installer den seneste version af operativsystemet, og prøv igen"
			HigherTermail            = "1. Åbn ""Terminal"" eller ""PowerShell ISE"" som administrator, `n      Indstil PowerShell-udførelsespolitik: Bypass, PS-kommandolinje: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Kør kommandoen igen, når den er løst."
			HigherTermailAdmin       = "1. Åbn ""Terminal"" eller ""PowerShell ISE"" som administrator. `n    2. Kør kommandoen igen, når den er løst."
		}
	}
	@{
		Region   = "nl-NL"
		Name     = "Dutch (Netherlands)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Haal het online Voeg automatisch geïnstalleerde talen toe aan uw Windows-systeem"
			UpdateServerSelect       = "Automatische serverselectie of aangepaste selectie"
			UpdateServerNoSelect     = "Selecteer een beschikbare server"
			UpdatePriority           = "Al ingesteld als prioriteit"
			UpdateServerTestFailed   = "Mislukte serverstatustest"
			UpdateQueryingUpdate     = "Vragen om updates..."
			UpdateQueryingTime       = "Bij het controleren of de nieuwste versie beschikbaar is, duurde de verbinding {0} milliseconden."
			UpdateConnectFailed      = "Kan geen verbinding maken met de externe server. Controleren op updates is afgebroken."
			UpdateCheckServerStatus  = "Controleer de serverstatus ( {0} opties beschikbaar )"
			UpdateServerAddress      = "Serveradres"
			UpdateServeravailable    = "Status: Beschikbaar"
			UpdateServerUnavailable  = "Status: Niet beschikbaar"
			InstlTo                  = "Installeren naar, nieuwe naam"
			SelectFolder             = "Selecteer map"
			OpenFolder               = "Map openen"
			Paste                    = "kopieer pad"
			FailedCreateFolder       = "Kan map niet maken"
			Failed                   = "mislukking"
			IsOldFile                = "Verwijder de oude bestanden en probeer het opnieuw"
			RestoreTo                = "Automatisch geselecteerd bij het herstellen van het installatiepad"
			RestoreToDisk            = "Selecteer automatisch beschikbare schijven"
			RestoreToDesktop         = "bureaublad"
			RestoreToDownload        = "downloaden"
			RestoreToDocuments       = "document"
			FileName                 = "bestandsnaam"
			Done                     = "Finish"
			Inoperable               = "Onbruikbaar"
			FileFormatError          = "Bestandsformaat is onjuist"
			AdvOption                = "Optionele functies"
			Ok_Go_To                 = "Beschikbaar voor"
			Ok_Go_To_Main            = "hoofdprogramma"
			Ok_Go_To_No              = "Niet gaan"
			OK_Go_To_Upgrade_package = "Maak een upgradepakket voor de implementatie-engine"
			Unpacking                = "Uitpakken"
			Running                  = "Rennen"
			SaveTo                   = "opslaan naar"
			OK                       = "Zeker"
			Cancel                   = "Annuleren"
			UserCancel               = "De gebruiker heeft de bewerking geannuleerd."
			AllSel                   = "Selecteer alles"
			AllClear                 = "alles wissen"
			Prerequisites            = "Vereisten"
			Check_PSVersion          = "Controleer PS-versie 5.1 en hoger"
			Check_OSVersion          = "Controleer Windows-versie > 10.0.16299.0"
			Check_Higher_elevated    = "Controle moet worden verhoogd naar hogere rechten"
			Check_execution_strategy = "Controleer de uitvoeringsstrategie"
			Check_Pass               = "doorgang"
			Check_Did_not_pass       = "mislukt"
			Check_Pass_Done          = "Gefeliciteerd, geslaagd."
			How_solve                = "Hoe op te lossen"
			UpdatePSVersion          = "Installeer de nieuwste PowerShell-versie"
			UpdateOSVersion          = "1. Ga naar de officiële website van Microsoft om de nieuwste versie van het besturingssysteem te downloaden`n   2. Installeer de nieuwste versie van het besturingssysteem en probeer het opnieuw"
			HigherTermail            = "1. Open ""Terminal"" of ""PowerShell ISE"" als beheerder, `n      PowerShell-uitvoeringsbeleid instellen: Bypass, PS-opdrachtregel: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Nadat het probleem is opgelost, voert u de opdracht opnieuw uit."
			HigherTermailAdmin       = "1. Open ""Terminal"" of ""PowerShell ISE"" als beheerder. `n    2. Nadat het probleem is opgelost, voert u de opdracht opnieuw uit."
		}
	}
	@{
		Region   = "et-EE"
		Name     = "Estonian (Estonia)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Hankige see võrgus Lisage installitud keeled automaatselt oma Windowsi süsteemi"
			UpdateServerSelect       = "Automaatne serveri valik või kohandatud valik"
			UpdateServerNoSelect     = "Valige saadaolev server"
			UpdatePriority           = "Juba seatud prioriteediks"
			UpdateServerTestFailed   = "Serveri oleku test ebaõnnestus"
			UpdateQueryingUpdate     = "Värskenduste päring..."
			UpdateQueryingTime       = "Kontrollimaks, kas uusim versioon on saadaval, võttis ühendus aega {0} millisekundit."
			UpdateConnectFailed      = "Kaugserveriga ei saa ühendust luua, värskenduste otsimine katkestati."
			UpdateCheckServerStatus  = "Kontrolli serveri olekut ( saadaval on {0} valikut )"
			UpdateServerAddress      = "Serveri aadress"
			UpdateServeravailable    = "Olek: saadaval"
			UpdateServerUnavailable  = "Olek: Pole saadaval"
			InstlTo                  = "Install to, uus nimi"
			SelectFolder             = "Valige kataloog"
			OpenFolder               = "Ava kataloog"
			Paste                    = "kopeeri tee"
			FailedCreateFolder       = "Kataloogi loomine ebaõnnestus"
			Failed                   = "ebaõnnestuda"
			IsOldFile                = "Kustutage vanad failid ja proovige uuesti"
			RestoreTo                = "Valitakse automaatselt installitee taastamisel"
			RestoreToDisk            = "Valige saadaolevad kettad automaatselt"
			RestoreToDesktop         = "töölaud"
			RestoreToDownload        = "alla laadida"
			RestoreToDocuments       = "dokument"
			FileName                 = "faili nimi"
			Done                     = "Lõpeta"
			Inoperable               = "Kasutuskõlbmatu"
			FileFormatError          = "Failivorming on vale"
			AdvOption                = "Valikulised funktsioonid"
			Ok_Go_To                 = "Saadaval kuni"
			Ok_Go_To_Main            = "põhiprogramm"
			Ok_Go_To_No              = "Ei lähe"
			OK_Go_To_Upgrade_package = "Looge juurutusmootori täienduspakett"
			Unpacking                = "Lahtipakkimine"
			Running                  = "Jooksmine"
			SaveTo                   = "salvestada"
			OK                       = "Muidugi"
			Cancel                   = "Tühista"
			UserCancel               = "Kasutaja on toimingu tühistanud."
			AllSel                   = "Valige kõik"
			AllClear                 = "tühjenda kõik"
			Prerequisites            = "Eeldused"
			Check_PSVersion          = "Kontrollige PS versiooni 5.1 ja uuemat"
			Check_OSVersion          = "Kontrollige Windowsi versiooni > 10.0.16299.0"
			Check_Higher_elevated    = "Tšekk peab olema tõstetud kõrgematele õigustele"
			Check_execution_strategy = "Kontrollige täitmisstrateegiat"
			Check_Pass               = "läbida"
			Check_Did_not_pass       = "ebaõnnestunud"
			Check_Pass_Done          = "Õnnitleme, läbitud."
			How_solve                = "Kuidas lahendada"
			UpdatePSVersion          = "Installige uusim PowerShelli versioon"
			UpdateOSVersion          = "1. Operatsioonisüsteemi uusima versiooni allalaadimiseks minge Microsofti ametlikule veebisaidile`n   2. Installige operatsioonisüsteemi uusim versioon ja proovige uuesti"
			HigherTermail            = "1. Avage administraatorina ""Terminal"" või ""PowerShell ISE"", `n      Seadke PowerShelli täitmispoliitika: ümbersõit, PS-i käsurida: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Kui see on lahendatud, käivitage käsk uuesti."
			HigherTermailAdmin       = "1. Avage administraatorina ""Terminal"" või ""PowerShell ISE"". `n    2. Kui see on lahendatud, käivitage käsk uuesti."
		}
	}
	@{
		Region   = "fi-FI"
		Name     = "Finnish (Finland)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Hanki se verkossa Lisää asennetut kielet automaattisesti Windows-järjestelmääsi"
			UpdateServerSelect       = "Automaattinen palvelimen valinta tai mukautettu valinta"
			UpdateServerNoSelect     = "Valitse käytettävissä oleva palvelin"
			UpdatePriority           = "Jo asetettu prioriteetiksi"
			UpdateServerTestFailed   = "Palvelimen tilatesti epäonnistui"
			UpdateQueryingUpdate     = "Haetaan päivityksiä..."
			UpdateQueryingTime       = "Tarkistaminen, onko uusin versio saatavilla, yhteys kesti {0} millisekuntia."
			UpdateConnectFailed      = "Yhteyden muodostaminen etäpalvelimeen ei onnistu, päivitysten tarkistus keskeytettiin."
			UpdateCheckServerStatus  = "Tarkista palvelimen tila ( {0} vaihtoehtoa käytettävissä )"
			UpdateServerAddress      = "Palvelimen osoite"
			UpdateServeravailable    = "Tila: Saatavilla"
			UpdateServerUnavailable  = "Tila: Ei saatavilla"
			InstlTo                  = "Asenna, uusi nimi"
			SelectFolder             = "Valitse hakemisto"
			OpenFolder               = "Avaa hakemisto"
			Paste                    = "kopioi polku"
			FailedCreateFolder       = "Hakemiston luominen epäonnistui"
			Failed                   = "epäonnistua"
			IsOldFile                = "Poista vanhat tiedostot ja yritä uudelleen"
			RestoreTo                = "Valitaan automaattisesti, kun asennuspolkua palautetaan"
			RestoreToDisk            = "Valitse käytettävissä olevat levyt automaattisesti"
			RestoreToDesktop         = "työpöytä"
			RestoreToDownload        = "lataa"
			RestoreToDocuments       = "asiakirja"
			FileName                 = "tiedoston nimi"
			Done                     = "Valmis"
			Inoperable               = "Käyttökelvoton"
			FileFormatError          = "Tiedostomuoto on väärä"
			AdvOption                = "Valinnaiset ominaisuudet"
			Ok_Go_To                 = "Saatavilla"
			Ok_Go_To_Main            = "pääohjelma"
			Ok_Go_To_No              = "Ei mene"
			OK_Go_To_Upgrade_package = "Luo käyttöönottomoottorin päivityspaketti"
			Unpacking                = "Purkaminen"
			Running                  = "Juoksemassa"
			SaveTo                   = "tallenna kohteeseen"
			OK                       = "Varma"
			Cancel                   = "Peruuttaa"
			UserCancel               = "Käyttäjä on peruuttanut toiminnon."
			AllSel                   = "Valitse kaikki"
			AllClear                 = "tyhjentää kaikki"
			Prerequisites            = "Edellytykset"
			Check_PSVersion          = "Tarkista PS-versio 5.1 ja uudemmat"
			Check_OSVersion          = "Tarkista Windows-versio > 10.0.16299.0"
			Check_Higher_elevated    = "Sekki on korotettava korkeampiin oikeuksiin"
			Check_execution_strategy = "Tarkista toteutusstrategia"
			Check_Pass               = "syöttö"
			Check_Did_not_pass       = "epäonnistunut"
			Check_Pass_Done          = "Onnittelut, ohitettu."
			How_solve                = "Miten ratkaista"
			UpdatePSVersion          = "Asenna uusin PowerShell-versio"
			UpdateOSVersion          = "1. Lataa käyttöjärjestelmän uusin versio Microsoftin viralliselta verkkosivustolta`n   2. Asenna käyttöjärjestelmän uusin versio ja yritä uudelleen"
			HigherTermail            = "1. Avaa ""Terminal"" tai ""PowerShell ISE"" järjestelmänvalvojana, `n      Aseta PowerShell-suorituskäytäntö: Ohitus, PS-komentorivi: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Kun se on ratkaistu, suorita komento uudelleen."
			HigherTermailAdmin       = "1. Avaa ""Terminal"" tai ""PowerShell ISE"" järjestelmänvalvojana. `n    2. Kun se on ratkaistu, suorita komento uudelleen."
		}
	}
	@{
		Region   = "fr-CA"
		Name     = "French (Canada)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Obtenez-le en ligne Ajoutez automatiquement les langues installées à votre système Windows"
			UpdateServerSelect       = "Sélection automatique du serveur ou sélection personnalisée"
			UpdateServerNoSelect     = "Veuillez choisir un serveur disponible"
			UpdatePriority           = "Déjà défini comme priorité"
			UpdateServerTestFailed   = "Échec du test d'état du serveur"
			UpdateQueryingUpdate     = "Recherche de mises à jour..."
			UpdateQueryingTime       = "En vérifiant si la dernière version est disponible, la connexion a pris {0} millisecondes."
			UpdateConnectFailed      = "Impossible de se connecter au serveur distant, vérification des mises à jour interrompue."
			UpdateCheckServerStatus  = "Vérifier l'état du serveur ( {0} options disponibles )"
			UpdateServerAddress      = "Adresse du serveur"
			UpdateServeravailable    = "Statut: Disponible"
			UpdateServerUnavailable  = "Statut: Non disponible"
			InstlTo                  = "Installer sur, nouveau nom"
			SelectFolder             = "Sélectionnez le répertoire"
			OpenFolder               = "Ouvrir le répertoire"
			Paste                    = "copier le chemin"
			FailedCreateFolder       = "Échec de la création du répertoire"
			Failed                   = "échouer"
			IsOldFile                = "Veuillez supprimer les anciens fichiers et réessayer"
			RestoreTo                = "Sélectionné automatiquement lors de la restauration du chemin d'installation"
			RestoreToDisk            = "Sélectionnez automatiquement les disques disponibles"
			RestoreToDesktop         = "ordinateur de bureau"
			RestoreToDownload        = "télécharger"
			RestoreToDocuments       = "document"
			FileName                 = "nom du fichier"
			Done                     = "Finition"
			Inoperable               = "Inopérable"
			FileFormatError          = "Le format de fichier est incorrect"
			AdvOption                = "Fonctionnalités optionnelles"
			Ok_Go_To                 = "Disponible pour"
			Ok_Go_To_Main            = "programme principal"
			Ok_Go_To_No              = "J'y vais pas"
			OK_Go_To_Upgrade_package = "Créer un paquet de mise à niveau du moteur de déploiement"
			Unpacking                = "Décompression"
			Running                  = "En cours d'exécution"
			SaveTo                   = "enregistrer dans"
			OK                       = "Bien sûr"
			Cancel                   = "Annuler"
			UserCancel               = "L'utilisateur a annulé l'opération."
			AllSel                   = "Sélectionner tout"
			AllClear                 = "effacer tout"
			Prerequisites            = "Conditions préalables"
			Check_PSVersion          = "Vérifiez la version PS 5.1 et version supérieure"
			Check_OSVersion          = "Vérifiez la version de Windows > 10.0.16299.0"
			Check_Higher_elevated    = "Le chèque doit être élevé à des privilèges plus élevés"
			Check_execution_strategy = "Vérifier la stratégie d'exécution"
			Check_Pass               = "passer"
			Check_Did_not_pass       = "échoué"
			Check_Pass_Done          = "Félicitations, c'est réussi."
			How_solve                = "Comment résoudre"
			UpdatePSVersion          = "Veuillez installer la dernière version de PowerShell"
			UpdateOSVersion          = "1. Rendez-vous sur le site officiel de Microsoft pour télécharger la dernière version du système d'exploitation`n   2. Installez la dernière version du système d'exploitation et réessayez"
			HigherTermail            = "1. Ouvrez ""Terminal"" ou ""PowerShell ISE"" en tant qu'administrateur, `n      Définir la politique d'exécution PowerShell: contourner, ligne de commande PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Une fois résolu, relancez la commande."
			HigherTermailAdmin       = "1. Ouvrez ""Terminal"" ou ""PowerShell ISE"" en tant qu'administrateur. `n    2. Une fois résolu, relancez la commande."
		}
	}
	@{
		Region   = "el-GR"
		Name     = "Greek (Greece)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Αποκτήστε το online Προσθέστε αυτόματα εγκατεστημένες γλώσσες στο σύστημά σας Windows"
			UpdateServerSelect       = "Αυτόματη επιλογή διακομιστή ή προσαρμοσμένη επιλογή"
			UpdateServerNoSelect     = "Επιλέξτε έναν διαθέσιμο διακομιστή"
			UpdatePriority           = "Έχει ήδη οριστεί ως προτεραιότητα"
			UpdateServerTestFailed   = "Αποτυχία δοκιμής κατάστασης διακομιστή"
			UpdateQueryingUpdate     = "Ερώτημα για ενημερώσεις..."
			UpdateQueryingTime       = "Έλεγχος για να δούμε αν η πιο πρόσφατη έκδοση είναι διαθέσιμη, η σύνδεση διήρκεσε {0} χιλιοστά του δευτερολέπτου."
			UpdateConnectFailed      = "Δεν είναι δυνατή η σύνδεση σε απομακρυσμένο διακομιστή, ο έλεγχος για ενημερώσεις ματαιώθηκε."
			UpdateCheckServerStatus  = "Ελέγξτε την κατάσταση του διακομιστή ( {0} διαθέσιμες επιλογές )"
			UpdateServerAddress      = "Διεύθυνση διακομιστή"
			UpdateServeravailable    = "Κατάσταση: Διαθέσιμο"
			UpdateServerUnavailable  = "Κατάσταση: Μη διαθέσιμο"
			InstlTo                  = "Εγκατάσταση σε, νέο όνομα"
			SelectFolder             = "Επιλέξτε κατάλογο"
			OpenFolder               = "Άνοιγμα καταλόγου"
			Paste                    = "διαδρομή αντιγραφής"
			FailedCreateFolder       = "Αποτυχία δημιουργίας καταλόγου"
			Failed                   = "αποτυγχάνω"
			IsOldFile                = "Διαγράψτε τα παλιά αρχεία και δοκιμάστε ξανά"
			RestoreTo                = "Επιλέγεται αυτόματα κατά την επαναφορά της διαδρομής εγκατάστασης"
			RestoreToDisk            = "Αυτόματη επιλογή διαθέσιμων δίσκων"
			RestoreToDesktop         = "επιφάνεια εργασίας"
			RestoreToDownload        = "λήψη"
			RestoreToDocuments       = "έγγραφο"
			FileName                 = "όνομα αρχείου"
			Done                     = "Φινίρισμα"
			Inoperable               = "Μη χειρουργήσιμος"
			FileFormatError          = "Η μορφή αρχείου είναι εσφαλμένη"
			AdvOption                = "Προαιρετικά χαρακτηριστικά"
			Ok_Go_To                 = "Διαθέσιμο σε"
			Ok_Go_To_Main            = "κύριο πρόγραμμα"
			Ok_Go_To_No              = "Δεν πηγαίνει"
			OK_Go_To_Upgrade_package = "Δημιουργήστε ένα πακέτο αναβάθμισης κινητήρα ανάπτυξης"
			Unpacking                = "Αποσυμπίεση"
			Running                  = "Τρέξιμο"
			SaveTo                   = "αποθήκευση σε"
			OK                       = "Σίγουρος"
			Cancel                   = "Ματαίωση"
			UserCancel               = "Ο χρήστης ακύρωσε τη λειτουργία."
			AllSel                   = "Επιλέξτε όλα"
			AllClear                 = "καθαρίστε όλα"
			Prerequisites            = "Προαπαιτούμενα"
			Check_PSVersion          = "Ελέγξτε την έκδοση PS 5.1 και νεότερη"
			Check_OSVersion          = "Ελέγξτε την έκδοση των Windows > 10.0.16299.0"
			Check_Higher_elevated    = "Η επιταγή πρέπει να ανυψωθεί σε υψηλότερα προνόμια"
			Check_execution_strategy = "Ελέγξτε τη στρατηγική εκτέλεσης"
			Check_Pass               = "πέρασμα"
			Check_Did_not_pass       = "αποτυχημένος"
			Check_Pass_Done          = "Συγχαρητήρια, πέρασε."
			How_solve                = "Πώς να λύσετε"
			UpdatePSVersion          = "Εγκαταστήστε την πιο πρόσφατη έκδοση PowerShell"
			UpdateOSVersion          = "1. Μεταβείτε στον επίσημο ιστότοπο της Microsoft για λήψη της πιο πρόσφατης έκδοσης του λειτουργικού συστήματος`n   2. Εγκαταστήστε την πιο πρόσφατη έκδοση του λειτουργικού συστήματος και δοκιμάστε ξανά"
			HigherTermail            = "1. Ανοίξτε το ""Terminal"" ή το ""PowerShell ISE"" ως διαχειριστής, `n      Ορισμός πολιτικής εκτέλεσης PowerShell: Παράκαμψη, γραμμή εντολών PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Μόλις επιλυθεί, εκτελέστε ξανά την εντολή."
			HigherTermailAdmin       = "1. Ανοίξτε το ""Terminal"" ή το ""PowerShell ISE"" ως διαχειριστής. `n    2. Μόλις επιλυθεί, εκτελέστε ξανά την εντολή."
		}
	}
	@{
		Region   = "he-IL"
		Name     = "Hebrew (Israel)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "קבל אותו באינטרנט הוסף אוטומטית שפות מותקנות למערכת Windows שלך"
			UpdateServerSelect       = "בחירת שרת אוטומטית או בחירה מותאמת אישית"
			UpdateServerNoSelect     = "אנא בחר שרת זמין"
			UpdatePriority           = "כבר מוגדר כעדיפות"
			UpdateServerTestFailed   = "בדיקת מצב השרת נכשלה"
			UpdateQueryingUpdate     = "מבקש עדכונים..."
			UpdateQueryingTime       = "בודקים אם הגרסה העדכנית ביותר זמינה, החיבור ארך {0} אלפיות שניות."
			UpdateConnectFailed      = "לא ניתן להתחבר לשרת מרוחק, בודקים אם עדכונים בוטלו."
			UpdateCheckServerStatus  = "בדוק את סטטוס השרת ( {0} אפשרויות זמינות )"
			UpdateServerAddress      = "כתובת השרת"
			UpdateServeravailable    = "סטטוס: זמין"
			UpdateServerUnavailable  = "סטטוס: לא זמין"
			InstlTo                  = "התקן ל, שם חדש"
			SelectFolder             = "בחר ספרייה"
			OpenFolder               = "פתח את הספרייה"
			Paste                    = "העתק נתיב"
			FailedCreateFolder       = "יצירת הספרייה נכשלה"
			Failed                   = "לְהִכָּשֵׁל"
			IsOldFile                = "נא למחוק את הקבצים הישנים ולנסות שוב"
			RestoreTo                = "נבחר באופן אוטומטי בעת שחזור נתיב ההתקנה"
			RestoreToDisk            = "בחר אוטומטית דיסקים זמינים"
			RestoreToDesktop         = "שולחן העבודה"
			RestoreToDownload        = "להוריד"
			RestoreToDocuments       = "מִסְמָך"
			FileName                 = "שם הקובץ"
			Done                     = "סִיוּם"
			Inoperable               = "בלתי ניתן להפעלה"
			FileFormatError          = "פורמט הקובץ שגוי"
			AdvOption                = "תכונות אופציונליות"
			Ok_Go_To                 = "זמין ל"
			Ok_Go_To_Main            = "תוכנית ראשית"
			Ok_Go_To_No              = "לא הולך"
			OK_Go_To_Upgrade_package = "צור חבילת שדרוג מנוע פריסה"
			Unpacking                = "פותח רוכסן"
			Running                  = "רִיצָה"
			SaveTo                   = "לשמור ל"
			OK                       = "בַּטוּחַ"
			Cancel                   = "לְבַטֵל"
			UserCancel               = "המשתמש ביטל את הפעולה."
			AllSel                   = "בחר הכל"
			AllClear                 = "לנקות הכל"
			Prerequisites            = "דרישות מוקדמות"
			Check_PSVersion          = "בדוק PS גרסה 5.1 ומעלה"
			Check_OSVersion          = "בדוק את גרסת Windows > 10.0.16299.0"
			Check_Higher_elevated    = "יש להעלות את ההמחאה להרשאות גבוהות יותר"
			Check_execution_strategy = "בדוק אסטרטגיית ביצוע"
			Check_Pass               = "לַעֲבוֹר"
			Check_Did_not_pass       = "נִכשָׁל"
			Check_Pass_Done          = "מזל טוב, עבר."
			How_solve                = "איך לפתור"
			UpdatePSVersion          = "אנא התקן את גרסת PowerShell העדכנית ביותר"
			UpdateOSVersion          = "1. עבור לאתר הרשמי של מיקרוסופט כדי להוריד את הגרסה העדכנית ביותר של מערכת ההפעלה`n   2. התקן את הגרסה העדכנית ביותר של מערכת ההפעלה ונסה שוב"
			HigherTermail            = "1. פתח את ""Terminal"" או ""PowerShell ISE"" כמנהל מערכת, `n      הגדר מדיניות ביצוע של PowerShell: עוקף, שורת פקודה PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. לאחר פתרון, הפעל מחדש את הפקודה."
			HigherTermailAdmin       = "1. פתח את ""Terminal"" או ""PowerShell ISE"" כמנהל מערכת. `n    2. לאחר פתרון, הפעל מחדש את הפקודה."
		}
	}
	@{
		Region   = "hu-HU"
		Name     = "Hungarian (Hungary)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Töltse le az interneten Automatikusan adja hozzá a telepített nyelveket a Windows rendszeréhez"
			UpdateServerSelect       = "Automatikus szerverválasztás vagy egyéni kiválasztás"
			UpdateServerNoSelect     = "Kérjük, válasszon elérhető szervert"
			UpdatePriority           = "Már prioritásként beállítva"
			UpdateServerTestFailed   = "Sikertelen szerverállapot-teszt"
			UpdateQueryingUpdate     = "Frissítések lekérdezése..."
			UpdateQueryingTime       = "Annak ellenőrzése, hogy elérhető-e a legújabb verzió, a csatlakozás {0} ezredmásodpercig tartott."
			UpdateConnectFailed      = "Nem lehet csatlakozni a távoli szerverhez, a frissítések keresése megszakadt."
			UpdateCheckServerStatus  = "Szerver állapotának ellenőrzése ( {0} lehetőség áll rendelkezésre )"
			UpdateServerAddress      = "Szerver címe"
			UpdateServeravailable    = "Állapot: Elérhető"
			UpdateServerUnavailable  = "Állapot: Nem elérhető"
			InstlTo                  = "Telepítés ide, új név"
			SelectFolder             = "Válassza ki a könyvtárat"
			OpenFolder               = "Nyissa meg a könyvtárat"
			Paste                    = "útvonal másolása"
			FailedCreateFolder       = "Nem sikerült létrehozni a könyvtárat"
			Failed                   = "nem sikerül"
			IsOldFile                = "Kérjük, törölje a régi fájlokat, és próbálja újra"
			RestoreTo                = "Automatikusan kiválasztva a telepítési útvonal visszaállításakor"
			RestoreToDisk            = "Az elérhető lemezek automatikus kiválasztása"
			RestoreToDesktop         = "asztali"
			RestoreToDownload        = "letöltés"
			RestoreToDocuments       = "dokumentum"
			FileName                 = "fájlnév"
			Done                     = "Befejezés"
			Inoperable               = "Működésképtelen"
			FileFormatError          = "A fájl formátuma nem megfelelő"
			AdvOption                = "Választható funkciók"
			Ok_Go_To                 = "Elérhető"
			Ok_Go_To_Main            = "fő program"
			Ok_Go_To_No              = "Nem megy"
			OK_Go_To_Upgrade_package = "Hozzon létre egy telepítési motor-frissítési csomagot"
			Unpacking                = "Kicsomagolás"
			Running                  = "Futás"
			SaveTo                   = "mentse ide"
			OK                       = "Persze"
			Cancel                   = "Mégsem"
			UserCancel               = "A felhasználó megszakította a műveletet."
			AllSel                   = "Válassza ki az összeset"
			AllClear                 = "mindent törölni"
			Prerequisites            = "Előfeltételek"
			Check_PSVersion          = "Ellenőrizze a PS 5.1 es és újabb verzióit"
			Check_OSVersion          = "Ellenőrizze a Windows verzióját > 10.0.16299.0"
			Check_Higher_elevated    = "A csekket magasabb jogosultságokra kell emelni"
			Check_execution_strategy = "Ellenőrizze a végrehajtási stratégiát"
			Check_Pass               = "pass"
			Check_Did_not_pass       = "sikertelen"
			Check_Pass_Done          = "Gratulálok, átment."
			How_solve                = "Hogyan kell megoldani"
			UpdatePSVersion          = "Kérjük, telepítse a legújabb PowerShell-verziót"
			UpdateOSVersion          = "1. Keresse fel a Microsoft hivatalos webhelyét az operációs rendszer legújabb verziójának letöltéséhez`n   2. Telepítse az operációs rendszer legújabb verzióját, és próbálja újra"
			HigherTermail            = "1. Nyissa meg a ""Terminal"" vagy a ""PowerShell ISE"" programot rendszergazdaként, `n      Állítsa be a PowerShell végrehajtási házirendjét: Bypass, PS parancssor: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Ha megoldódott, futtassa újra a parancsot."
			HigherTermailAdmin       = "1. Nyissa meg a ""Terminal"" vagy a ""PowerShell ISE"" programot rendszergazdaként, `n    2. Ha megoldódott, futtassa újra a parancsot."
		}
	}
	@{
		Region   = "it-IT"
		Name     = "Italian (Italy)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Ottienilo online Aggiungi automaticamente le lingue installate al tuo sistema Windows"
			UpdateServerSelect       = "Selezione automatica del server o selezione personalizzata"
			UpdateServerNoSelect     = "Seleziona un server disponibile"
			UpdatePriority           = "Già impostato come priorità"
			UpdateServerTestFailed   = "Test dello stato del server non riuscito"
			UpdateQueryingUpdate     = "Richiesta aggiornamenti..."
			UpdateQueryingTime       = "Verificando se è disponibile la versione più recente, la connessione ha richiesto {0} millisecondi."
			UpdateConnectFailed      = "Impossibile connettersi al server remoto, controllo degli aggiornamenti interrotto."
			UpdateCheckServerStatus  = "Controlla lo stato del server ( {0} opzioni disponibili )"
			UpdateServerAddress      = "Indirizzo del server"
			UpdateServeravailable    = "Stato: disponibile"
			UpdateServerUnavailable  = "Stato: non disponibile"
			InstlTo                  = "Installa in, nuovo nome"
			SelectFolder             = "Seleziona la directory"
			OpenFolder               = "Apri la rubrica"
			Paste                    = "percorso di copia"
			FailedCreateFolder       = "Impossibile creare la directory"
			Failed                   = "fallire"
			IsOldFile                = "Elimina i vecchi file e riprova"
			RestoreTo                = "Selezionato automaticamente durante il ripristino del percorso di installazione"
			RestoreToDisk            = "Seleziona automaticamente i dischi disponibili"
			RestoreToDesktop         = "scrivania"
			RestoreToDownload        = "scaricamento"
			RestoreToDocuments       = "documento"
			FileName                 = "nome del file"
			Done                     = "Fine"
			Inoperable               = "Inoperabile"
			FileFormatError          = "Il formato del file non è corretto"
			AdvOption                = "Funzionalità opzionali"
			Ok_Go_To                 = "Disponibile a"
			Ok_Go_To_Main            = "programma principale"
			Ok_Go_To_No              = "Non andrò"
			OK_Go_To_Upgrade_package = "Creare un pacchetto di aggiornamento del motore di distribuzione"
			Unpacking                = "Decompressione"
			Running                  = "Corsa"
			SaveTo                   = "salva in"
			OK                       = "Sicuro"
			Cancel                   = "Cancellare"
			UserCancel               = "L'utente ha annullato l'operazione."
			AllSel                   = "Seleziona tutto"
			AllClear                 = "cancella tutto"
			Prerequisites            = "Prerequisiti"
			Check_PSVersion          = "Controlla la versione PS 5.1 e successive"
			Check_OSVersion          = "Controlla la versione di Windows > 10.0.16299.0"
			Check_Higher_elevated    = "Il controllo deve essere elevato a privilegi più elevati"
			Check_execution_strategy = "Controllare la strategia di esecuzione"
			Check_Pass               = "passaggio"
			Check_Did_not_pass       = "fallito"
			Check_Pass_Done          = "Congratulazioni, superato."
			How_solve                = "Come risolvere"
			UpdatePSVersion          = "Installa la versione più recente di PowerShell"
			UpdateOSVersion          = "1. Vai al sito Web ufficiale di Microsoft per scaricare l'ultima versione del sistema operativo`n   2. Installa la versione più recente del sistema operativo e riprova"
			HigherTermail            = "1. Apri ""Terminale"" o ""PowerShell ISE"" come amministratore, `n      Imposta i criteri di esecuzione di PowerShell: Bypass, riga di comando PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Una volta risolto, eseguire nuovamente il comando."
			HigherTermailAdmin       = "1. Apri ""Terminale"" o ""PowerShell ISE"" come amministratore. `n    2. Una volta risolto, eseguire nuovamente il comando."
		}
	}
	@{
		Region   = "lv-LV"
		Name     = "Latvian (Latvia)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Iegūstiet to tiešsaistē Automātiski pievienojiet instalētās valodas savai Windows sistēmai"
			UpdateServerSelect       = "Automātiska servera izvēle vai pielāgota izvēle"
			UpdateServerNoSelect     = "Lūdzu, atlasiet pieejamu serveri"
			UpdatePriority           = "Jau iestatīta kā prioritāte"
			UpdateServerTestFailed   = "Servera statusa pārbaude neizdevās"
			UpdateQueryingUpdate     = "Notiek atjauninājumu vaicājums..."
			UpdateQueryingTime       = "Pārbaudot, vai ir pieejama jaunākā versija, savienojums aizņēma {0} milisekundes."
			UpdateConnectFailed      = "Nevar izveidot savienojumu ar attālo serveri, atjauninājumu pārbaude tika pārtraukta."
			UpdateCheckServerStatus  = "Pārbaudiet servera statusu (pieejamas {0} opcijas)"
			UpdateServerAddress      = "Servera adrese"
			UpdateServeravailable    = "Statuss: pieejams"
			UpdateServerUnavailable  = "Statuss: Nav pieejams"
			InstlTo                  = "Instalēt uz, jauns nosaukums"
			SelectFolder             = "Izvēlieties direktoriju"
			OpenFolder               = "Atvērt direktoriju"
			Paste                    = "kopēt ceļu"
			FailedCreateFolder       = "Neizdevās izveidot direktoriju"
			Failed                   = "neizdoties"
			IsOldFile                = "Lūdzu, izdzēsiet vecos failus un mēģiniet vēlreiz"
			RestoreTo                = "Automātiski atlasīts, atjaunojot instalācijas ceļu"
			RestoreToDisk            = "Automātiski atlasīt pieejamos diskus"
			RestoreToDesktop         = "darbvirsma"
			RestoreToDownload        = "lejupielādēt"
			RestoreToDocuments       = "dokumentu"
			FileName                 = "faila nosaukums"
			Done                     = "Pabeigt"
			Inoperable               = "Nederīgs"
			FileFormatError          = "Faila formāts nav pareizs"
			AdvOption                = "Izvēles funkcijas"
			Ok_Go_To                 = "Pieejams līdz"
			Ok_Go_To_Main            = "galvenā programma"
			Ok_Go_To_No              = "Neiet"
			OK_Go_To_Upgrade_package = "Izveidojiet izvietošanas programmas jaunināšanas pakotni"
			Unpacking                = "Izsaiņošana"
			Running                  = "Skriešana"
			SaveTo                   = "saglabāt uz"
			OK                       = "Protams"
			Cancel                   = "Atcelt"
			UserCancel               = "Lietotājs ir atcēlis darbību."
			AllSel                   = "Atlasiet visu"
			AllClear                 = "notīrīt visu"
			Prerequisites            = "Priekšnoteikumi"
			Check_PSVersion          = "Pārbaudiet PS versiju 5.1 un jaunāku versiju"
			Check_OSVersion          = "Pārbaudiet Windows versiju > 10.0.16299.0"
			Check_Higher_elevated    = "Čekam jābūt paaugstinātam, lai iegūtu augstākas privilēģijas"
			Check_execution_strategy = "Pārbaudiet izpildes stratēģiju"
			Check_Pass               = "caurlaide"
			Check_Did_not_pass       = "neizdevās"
			Check_Pass_Done          = "Apsveicu, pagājis."
			How_solve                = "Kā atrisināt"
			UpdatePSVersion          = "Lūdzu, instalējiet jaunāko PowerShell versiju"
			UpdateOSVersion          = "1. Dodieties uz Microsoft oficiālo vietni, lai lejupielādētu jaunāko operētājsistēmas versiju`n   2. Instalējiet jaunāko operētājsistēmas versiju un mēģiniet vēlreiz"
			HigherTermail            = "1. Atveriet ""Terminal"" vai ""PowerShell ISE"" kā administrators, `n      Iestatīt PowerShell izpildes politiku: apiet, PS komandrinda: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Kad tas ir atrisināts, palaidiet komandu vēlreiz."
			HigherTermailAdmin       = "1. Atveriet ""Terminal"" vai ""PowerShell ISE"" kā administrators. `n    2. Kad tas ir atrisināts, palaidiet komandu vēlreiz."
		}
	}
	@{
		Region   = "lt-LT"
		Name     = "Lithuanian (Lithuania)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Gaukite jį internete Automatiškai pridėkite įdiegtas kalbas į savo Windows sistemą"
			UpdateServerSelect       = "Automatinis serverio pasirinkimas arba pasirinktinis pasirinkimas"
			UpdateServerNoSelect     = "Pasirinkite pasiekiamą serverį"
			UpdatePriority           = "Jau nustatytas kaip prioritetas"
			UpdateServerTestFailed   = "Nepavyko patikrinti serverio būsenos"
			UpdateQueryingUpdate     = "Užklausa dėl atnaujinimų..."
			UpdateQueryingTime       = "Tikrinama, ar yra naujausia versija, prisijungimas užtruko {0} milisekundžių."
			UpdateConnectFailed      = "Nepavyko prisijungti prie nuotolinio serverio, atnaujinimų tikrinimas nutrauktas."
			UpdateCheckServerStatus  = "Patikrinkite serverio būseną ( galimos {0} parinktys )"
			UpdateServerAddress      = "Serverio adresas"
			UpdateServeravailable    = "Būsena: Yra"
			UpdateServerUnavailable  = "Būsena: nėra"
			InstlTo                  = "Įdiegti į, naujas pavadinimas"
			SelectFolder             = "Pasirinkite katalogą"
			OpenFolder               = "Atidaryti katalogą"
			Paste                    = "kopijuoti kelią"
			FailedCreateFolder       = "Nepavyko sukurti katalogo"
			Failed                   = "nepavyks"
			IsOldFile                = "Ištrinkite senus failus ir bandykite dar kartą"
			RestoreTo                = "Automatiškai pasirenkama atkuriant diegimo kelią"
			RestoreToDisk            = "Automatiškai pasirinkite turimus diskus"
			RestoreToDesktop         = "darbalaukis"
			RestoreToDownload        = "parsisiųsti"
			RestoreToDocuments       = "dokumentas"
			FileName                 = "failo pavadinimas"
			Done                     = "Baigti"
			Inoperable               = "Neveikiantis"
			FileFormatError          = "Failo formatas neteisingas"
			AdvOption                = "Pasirenkamos funkcijos"
			Ok_Go_To                 = "Galima"
			Ok_Go_To_Main            = "pagrindinė programa"
			Ok_Go_To_No              = "Nevažiuoja"
			OK_Go_To_Upgrade_package = "Sukurkite diegimo variklio naujinimo paketą"
			Unpacking                = "Išpakavimas"
			Running                  = "Bėgimas"
			SaveTo                   = "išsaugoti į"
			OK                       = "Žinoma"
			Cancel                   = "Atšaukti"
			UserCancel               = "Vartotojas atšaukė operaciją."
			AllSel                   = "Pasirinkite viską"
			AllClear                 = "išvalyti viską"
			Prerequisites            = "Būtinos sąlygos"
			Check_PSVersion          = "Patikrinkite PS 5.1 ir naujesnę versiją"
			Check_OSVersion          = "Patikrinkite Windows versiją > 10.0.16299.0"
			Check_Higher_elevated    = "Čekis turi būti padidintas iki aukštesnių privilegijų"
			Check_execution_strategy = "Patikrinkite vykdymo strategiją"
			Check_Pass               = "praeiti"
			Check_Did_not_pass       = "nepavyko"
			Check_Pass_Done          = "Sveikinu, praėjo."
			How_solve                = "Kaip išspręsti"
			UpdatePSVersion          = "Įdiekite naujausią PowerShell versiją"
			UpdateOSVersion          = "1. Eikite į oficialią Microsoft svetainę ir atsisiųskite naujausią operacinės sistemos versiją`n   2. Įdiekite naujausią operacinės sistemos versiją ir bandykite dar kartą"
			HigherTermail            = "1. Atidarykite ""Terminal"" arba ""PowerShell ISE"" kaip administratorius, `n      Nustatykite PowerShell vykdymo strategiją: apeiti, PS komandų eilutė: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Išspręsę komandą paleiskite iš naujo."
			HigherTermailAdmin       = "1. Atidarykite ""Terminal"" arba ""PowerShell ISE"" kaip administratorius. `n    2. Išspręsę komandą paleiskite iš naujo."
		}
	}
	@{
		Region   = "nb-NO"
		Name     = "Norwegian, Bokmål (Norway)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Få det på nettet Legg automatisk til installerte språk til Windows-systemet ditt"
			UpdateServerSelect       = "Automatisk servervalg eller tilpasset valg"
			UpdateServerNoSelect     = "Velg en tilgjengelig server"
			UpdatePriority           = "Allerede satt som prioritet"
			UpdateServerTestFailed   = "Mislykket serverstatustest"
			UpdateQueryingUpdate     = "Spør etter oppdateringer..."
			UpdateQueryingTime       = "For å se om den nyeste versjonen er tilgjengelig, tok tilkoblingen {0} millisekunder."
			UpdateConnectFailed      = "Kan ikke koble til ekstern server, ser etter oppdateringer avbrutt."
			UpdateCheckServerStatus  = "Sjekk serverstatus ( {0} tilgjengelige alternativer) "
			UpdateServerAddress      = "Serveradresse"
			UpdateServeravailable    = "Status: Tilgjengelig"
			UpdateServerUnavailable  = "Status: Ikke tilgjengelig"
			InstlTo                  = "Installer til, nytt navn"
			SelectFolder             = "Velg katalog"
			OpenFolder               = "Åpne katalogen"
			Paste                    = "kopibane"
			FailedCreateFolder       = "Kunne ikke opprette katalog"
			Failed                   = "mislykkes"
			IsOldFile                = "Slett de gamle filene og prøv igjen"
			RestoreTo                = "Automatisk valgt når installasjonsbanen gjenopprettes"
			RestoreToDisk            = "Velg tilgjengelige disker automatisk"
			RestoreToDesktop         = "skrivebord"
			RestoreToDownload        = "laste ned"
			RestoreToDocuments       = "dokument"
			FileName                 = "filnavn"
			Done                     = "Fullfør"
			Inoperable               = "Ubrukelig"
			FileFormatError          = "Filformatet er feil"
			AdvOption                = "Valgfrie funksjoner"
			Ok_Go_To                 = "Tilgjengelig for"
			Ok_Go_To_Main            = "hovedprogram"
			Ok_Go_To_No              = "Går ikke"
			OK_Go_To_Upgrade_package = "Opprett en oppgraderingspakke for distribusjonsmotoren"
			Unpacking                = "Pakning ut"
			Running                  = "Løper"
			SaveTo                   = "lagre til"
			OK                       = "Sikker"
			Cancel                   = "Kansellere"
			UserCancel               = "Brukeren har avbrutt operasjonen."
			AllSel                   = "Velg alle"
			AllClear                 = "fjern alt"
			Prerequisites            = "Forutsetninger"
			Check_PSVersion          = "Sjekk PS versjon 5.1 og nyere"
			Check_OSVersion          = "Sjekk Windows-versjon > 10.0.16299.0"
			Check_Higher_elevated    = "Sjekk må heves til høyere privilegier"
			Check_execution_strategy = "Sjekk utførelsesstrategi"
			Check_Pass               = "pass"
			Check_Did_not_pass       = "mislyktes"
			Check_Pass_Done          = "Gratulerer, bestått."
			How_solve                = "Hvordan løse"
			UpdatePSVersion          = "Installer den nyeste PowerShell-versjonen"
			UpdateOSVersion          = "1. Gå til Microsofts offisielle nettsted for å laste ned den nyeste versjonen av operativsystemet`n   2. Installer den nyeste versjonen av operativsystemet og prøv på nytt"
			HigherTermail            = "1. Åpne ""Terminal"" eller ""PowerShell ISE"" som administrator, `n      Angi PowerShell-utførelsespolicy: Bypass, PS-kommandolinje: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Når det er løst, kjør kommandoen på nytt."
			HigherTermailAdmin       = "1. Åpne ""Terminal"" eller ""PowerShell ISE"" som administrator. `n    2. Når det er løst, kjør kommandoen på nytt."
		}
	}
	@{
		Region   = "pl-PL"
		Name     = "Polish (Poland)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Pobierz online Automatycznie dodawaj zainstalowane języki do swojego systemu Windows"
			UpdateServerSelect       = "Automatyczny wybór serwera lub wybór niestandardowy"
			UpdateServerNoSelect     = "Wybierz dostępny serwer"
			UpdatePriority           = "Już ustawiony jako priorytet"
			UpdateServerTestFailed   = "Nieudany test stanu serwera"
			UpdateQueryingUpdate     = "Zapytanie o aktualizacje..."
			UpdateQueryingTime       = "Sprawdzam, czy dostępna jest najnowsza wersja, połączenie trwało {0} milisekund."
			UpdateConnectFailed      = "Nie można połączyć się ze zdalnym serwerem. Sprawdzanie dostępności aktualizacji zostało przerwane."
			UpdateCheckServerStatus  = "Sprawdź stan serwera ( dostępne opcje: {0} )"
			UpdateServerAddress      = "Adres serwera"
			UpdateServeravailable    = "Stan: dostępny"
			UpdateServerUnavailable  = "Stan: Niedostępne"
			InstlTo                  = "Zainstaluj pod nową nazwą"
			SelectFolder             = "Wybierz katalog"
			OpenFolder               = "Otwórz katalog"
			Paste                    = "skopiuj ścieżkę"
			FailedCreateFolder       = "Nie udało się utworzyć katalogu"
			Failed                   = "ponieść porażkę"
			IsOldFile                = "Usuń stare pliki i spróbuj ponownie"
			RestoreTo                = "Wybierany automatycznie podczas przywracania ścieżki instalacji"
			RestoreToDisk            = "Automatycznie wybierz dostępne dyski"
			RestoreToDesktop         = "pulpit"
			RestoreToDownload        = "pobierać"
			RestoreToDocuments       = "dokument"
			FileName                 = "nazwa pliku"
			Done                     = "Skończyć"
			Inoperable               = "Nieoperacyjny"
			FileFormatError          = "Format pliku jest nieprawidłowy"
			AdvOption                = "Opcjonalne funkcje"
			Ok_Go_To                 = "Dostępne dla"
			Ok_Go_To_Main            = "główny program"
			Ok_Go_To_No              = "Nie idę"
			OK_Go_To_Upgrade_package = "Utwórz pakiet aktualizacji mechanizmu wdrażania"
			Unpacking                = "Rozpakowanie"
			Running                  = "Działanie"
			SaveTo                   = "zapisz w"
			OK                       = "Jasne"
			Cancel                   = "Anulować"
			UserCancel               = "Użytkownik anulował operację."
			AllSel                   = "Zaznacz wszystko"
			AllClear                 = "wyczyść wszystko"
			Prerequisites            = "Warunki wstępne"
			Check_PSVersion          = "Sprawdź wersję PS 5.1 i nowszą"
			Check_OSVersion          = "Sprawdź wersję systemu Windows > 10.0.16299.0"
			Check_Higher_elevated    = "Czek musi zostać podniesiony do wyższych uprawnień"
			Check_execution_strategy = "Sprawdź strategię wykonania"
			Check_Pass               = "przechodzić"
			Check_Did_not_pass       = "przegrany"
			Check_Pass_Done          = "Gratulacje, przeszło."
			How_solve                = "Jak rozwiązać"
			UpdatePSVersion          = "Zainstaluj najnowszą wersję PowerShell"
			UpdateOSVersion          = "1. Przejdź do oficjalnej strony Microsoftu, aby pobrać najnowszą wersję systemu operacyjnego`n   2. Zainstaluj najnowszą wersję systemu operacyjnego i spróbuj ponownie"
			HigherTermail            = "1. Otwórz ""Terminal"" lub ""PowerShell ISE"" jako administrator, `n      Ustaw zasady wykonywania PowerShell: Pomiń, wiersz poleceń PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Po rozwiązaniu problemu uruchom ponownie polecenie."
			HigherTermailAdmin       = "1. Otwórz ""Terminal"" lub ""PowerShell ISE"" jako administrator. `n    2. Po rozwiązaniu problemu uruchom ponownie polecenie."
		}
	}
	@{
		Region   = "pt-BR"
		Name     = "Portuguese (Brazil)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Obtenha on-line Adicione automaticamente os idiomas instalados ao seu sistema Windows"
			UpdateServerSelect       = "Seleção automática de servidor ou seleção personalizada"
			UpdateServerNoSelect     = "Selecione um servidor disponível"
			UpdatePriority           = "Já definido como prioridade"
			UpdateServerTestFailed   = "Falha no teste de status do servidor"
			UpdateQueryingUpdate     = "Consultando atualizações..."
			UpdateQueryingTime       = "Verificando se a versão mais recente está disponível, a conexão demorou {0} milissegundos."
			UpdateConnectFailed      = "Não foi possível conectar-se ao servidor remoto. A verificação de atualizações foi cancelada."
			UpdateCheckServerStatus  = "Verifique o status do servidor ( {0} opções disponíveis )"
			UpdateServerAddress      = "Endereço do servidor"
			UpdateServeravailable    = "Estado: Disponível"
			UpdateServerUnavailable  = "Situação: Não disponível"
			InstlTo                  = "Instalar em, novo nome"
			SelectFolder             = "Selecione o diretório"
			OpenFolder               = "Abrir diretório"
			Paste                    = "copiar caminho"
			FailedCreateFolder       = "Falha ao criar diretório"
			Failed                   = "falhar"
			IsOldFile                = "Exclua os arquivos antigos e tente novamente"
			RestoreTo                = "Selecionado automaticamente ao restaurar o caminho de instalação"
			RestoreToDisk            = "Selecione automaticamente os discos disponíveis"
			RestoreToDesktop         = "área de trabalho"
			RestoreToDownload        = "download"
			RestoreToDocuments       = "documento"
			FileName                 = "nome do arquivo"
			Done                     = "Terminar"
			Inoperable               = "Inoperável"
			FileFormatError          = "O formato do arquivo está incorreto"
			AdvOption                = "Recursos opcionais"
			Ok_Go_To                 = "Disponível para"
			Ok_Go_To_Main            = "programa principal"
			Ok_Go_To_No              = "Não vou"
			OK_Go_To_Upgrade_package = "Crie um pacote de atualização do mecanismo de implementação"
			Unpacking                = "Descompactando"
			Running                  = "Correndo"
			SaveTo                   = "salvar em"
			OK                       = "Claro"
			Cancel                   = "Cancelar"
			UserCancel               = "O usuário cancelou a operação."
			AllSel                   = "Selecionar tudo"
			AllClear                 = "limpar tudo"
			Prerequisites            = "Pré-requisitos"
			Check_PSVersion          = "Verifique a versão PS 5.1 e superior"
			Check_OSVersion          = "Verifique a versão do Windows> 10.0.16299.0"
			Check_Higher_elevated    = "A verificação deve ser elevada para privilégios mais altos"
			Check_execution_strategy = "Verifique a estratégia de execução"
			Check_Pass               = "passar"
			Check_Did_not_pass       = "fracassado"
			Check_Pass_Done          = "Parabéns, aprovado."
			How_solve                = "Como resolver"
			UpdatePSVersion          = "Instale a versão mais recente do PowerShell"
			UpdateOSVersion          = "1. Acesse o site oficial da Microsoft para baixar a versão mais recente do sistema operacional`n   2. Instale a versão mais recente do sistema operacional e tente novamente"
			HigherTermail            = "1. Abra ""Terminal"" ou ""PowerShell ISE"" como administrador, `n      Definir política de execução do PowerShell: Ignorar, linha de comando PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Depois de resolvido, execute novamente o comando."
			HigherTermailAdmin       = "1. Abra ""Terminal"" ou ""PowerShell ISE"" como administrador. `n    2. Depois de resolvido, execute novamente o comando."
		}
	}
	@{
		Region   = "ro-RO"
		Name     = "Romanian (Romania)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Obțineți-l online Adăugați automat limbi instalate în sistemul dvs. Windows"
			UpdateServerSelect       = "Selectare automată a serverului sau selecție personalizată"
			UpdateServerNoSelect     = "Vă rugăm să selectați un server disponibil"
			UpdatePriority           = "Deja setat ca prioritate"
			UpdateServerTestFailed   = "Testul de stare a serverului a eșuat"
			UpdateQueryingUpdate     = "Se solicită actualizări..."
			UpdateQueryingTime       = "Pentru a vedea dacă cea mai recentă versiune este disponibilă, conexiunea a durat {0} milisecunde."
			UpdateConnectFailed      = "Nu se poate conecta la serverul de la distanță, verificarea actualizărilor a fost întreruptă."
			UpdateCheckServerStatus  = "Verificați starea serverului ( {0} opțiuni disponibile )"
			UpdateServerAddress      = "Adresa serverului"
			UpdateServeravailable    = "Stare: Disponibil"
			UpdateServerUnavailable  = "Stare: Indisponibil"
			InstlTo                  = "Instalați la, nume nou"
			SelectFolder             = "Selectați directorul"
			OpenFolder               = "Deschide directorul"
			Paste                    = "copiați calea"
			FailedCreateFolder       = "Nu s-a putut crea directorul"
			Failed                   = "eșuează"
			IsOldFile                = "Vă rugăm să ștergeți fișierele vechi și să încercați din nou"
			RestoreTo                = "Selectat automat la restaurarea căii de instalare"
			RestoreToDisk            = "Selectați automat discurile disponibile"
			RestoreToDesktop         = "desktop"
			RestoreToDownload        = "descărcare"
			RestoreToDocuments       = "document"
			FileName                 = "nume de fișier"
			Done                     = "Termina"
			Inoperable               = "Inoperabil"
			FileFormatError          = "Formatul fișierului este incorect"
			AdvOption                = "Caracteristici opționale"
			Ok_Go_To                 = "Disponibil pentru"
			Ok_Go_To_Main            = "programul principal"
			Ok_Go_To_No              = "Nu merg"
			OK_Go_To_Upgrade_package = "Creați un pachet de actualizare a motorului de implementare"
			Unpacking                = "Dezarhivare"
			Running                  = "Funcţionare"
			SaveTo                   = "salva la"
			OK                       = "Sigur"
			Cancel                   = "Anula"
			UserCancel               = "Utilizatorul a anulat operația."
			AllSel                   = "Selectați toate"
			AllClear                 = "șterge totul"
			Prerequisites            = "Cerințe preliminare"
			Check_PSVersion          = "Verificați versiunea PS 5.1 și mai sus"
			Check_OSVersion          = "Verificați versiunea Windows > 10.0.16299.0"
			Check_Higher_elevated    = "Cecul trebuie ridicat la privilegii mai mari"
			Check_execution_strategy = "Verificați strategia de execuție"
			Check_Pass               = "pasa"
			Check_Did_not_pass       = "a eșuat"
			Check_Pass_Done          = "Felicitări, a trecut."
			How_solve                = "Cum se rezolvă"
			UpdatePSVersion          = "Instalați cea mai recentă versiune PowerShell"
			UpdateOSVersion          = "1. Accesați site-ul web oficial Microsoft pentru a descărca cea mai recentă versiune a sistemului de operare`n   2. Instalați cea mai recentă versiune a sistemului de operare și încercați din nou"
			HigherTermail            = "1. Deschideți ""Terminal"" sau ""PowerShell ISE"" ca administrator, `n      Setați politica de execuție PowerShell: Bypass, linia de comandă PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Odată rezolvată, executați din nou comanda."
			HigherTermailAdmin       = "1. Deschideți ""Terminal"" sau ""PowerShell ISE"" ca administrator. `n    2. Odată rezolvată, executați din nou comanda."
		}
	}
	@{
		Region   = "sk-SK"
		Name     = "Slovak (Slovakia)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Získajte online Automaticky pridajte nainštalované jazyky do systému Windows"
			UpdateServerSelect       = "Automatický výber servera alebo vlastný výber"
			UpdateServerNoSelect     = "Vyberte dostupný server"
			UpdatePriority           = "Už nastavené ako priorita"
			UpdateServerTestFailed   = "Neúspešný test stavu servera"
			UpdateQueryingUpdate     = "Dotaz na aktualizácie..."
			UpdateQueryingTime       = "Kontrola, či je k dispozícii najnovšia verzia, pripojenie trvalo {0} milisekúnd."
			UpdateConnectFailed      = "Nedá sa pripojiť k vzdialenému serveru, kontrola aktualizácií bola prerušená."
			UpdateCheckServerStatus  = "Skontrolujte stav servera ( dostupné možnosti: {0} )"
			UpdateServerAddress      = "Adresa servera"
			UpdateServeravailable    = "Stav: K dispozícii"
			UpdateServerUnavailable  = "Stav: Nie je k dispozícii"
			InstlTo                  = "Inštalovať do, nový názov"
			SelectFolder             = "Vyberte adresár"
			OpenFolder               = "Otvorte adresár"
			Paste                    = "kopírovať cestu"
			FailedCreateFolder       = "Nepodarilo sa vytvoriť adresár"
			Failed                   = "zlyhať"
			IsOldFile                = "Odstráňte staré súbory a skúste to znova"
			RestoreTo                = "Automaticky vybrané pri obnove inštalačnej cesty"
			RestoreToDisk            = "Automaticky vybrať dostupné disky"
			RestoreToDesktop         = "pracovnej plochy"
			RestoreToDownload        = "stiahnuť"
			RestoreToDocuments       = "dokument"
			FileName                 = "názov súboru"
			Done                     = "Dokončiť"
			Inoperable               = "Nefunkčné"
			FileFormatError          = "Formát súboru je nesprávny"
			AdvOption                = "Voliteľné funkcie"
			Ok_Go_To                 = "K dispozícii pre"
			Ok_Go_To_Main            = "hlavný program"
			Ok_Go_To_No              = "Nechodím"
			OK_Go_To_Upgrade_package = "Vytvorte balík inovácie nástroja nasadenia"
			Unpacking                = "Rozopínanie"
			Running                  = "Beh"
			SaveTo                   = "uložiť do"
			OK                       = "Jasné"
			Cancel                   = "Zrušiť"
			UserCancel               = "Používateľ zrušil operáciu."
			AllSel                   = "Vybrať všetko"
			AllClear                 = "vymazať všetko"
			Prerequisites            = "Predpoklady"
			Check_PSVersion          = "Skontrolujte verziu PS 5.1 a vyššiu"
			Check_OSVersion          = "Skontrolujte verziu systému Windows > 10.0.16299.0"
			Check_Higher_elevated    = "Kontrola musí byť povýšená na vyššie oprávnenia"
			Check_execution_strategy = "Skontrolujte stratégiu vykonávania"
			Check_Pass               = "prejsť"
			Check_Did_not_pass       = "nepodarilo"
			Check_Pass_Done          = "Gratulujem, prešiel."
			How_solve                = "Ako vyriešiť"
			UpdatePSVersion          = "Nainštalujte si najnovšiu verziu prostredia PowerShell"
			UpdateOSVersion          = "1. Prejdite na oficiálnu webovú stránku spoločnosti Microsoft a stiahnite si najnovšiu verziu operačného systému`n   2. Nainštalujte najnovšiu verziu operačného systému a skúste to znova"
			HigherTermail            = "1. Otvorte ""Terminál"" alebo ""PowerShell ISE"" ako správca, `n      Nastaviť politiku vykonávania prostredia PowerShell: Obísť, príkazový riadok PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Po vyriešení príkaz znova spustite."
			HigherTermailAdmin       = "1. Otvorte ""Terminál"" alebo ""PowerShell ISE"" ako správca. `n    2. Po vyriešení príkaz znova spustite."
		}
	}
	@{
		Region   = "sl-SI"
		Name     = "Slovenian (Slovenia)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Prenesite ga v splet Samodejno dodajte nameščene jezike v sistem Windows"
			UpdateServerSelect       = "Samodejna izbira strežnika ali izbira po meri"
			UpdateServerNoSelect     = "Izberite razpoložljiv strežnik"
			UpdatePriority           = "Že nastavljen kot prednostni"
			UpdateServerTestFailed   = "Neuspešen preizkus stanja strežnika"
			UpdateQueryingUpdate     = "Poizvedovanje za posodobitve ..."
			UpdateQueryingTime       = "Preverjanje, ali je na voljo najnovejša različica, povezava je trajala {0} milisekund."
			UpdateConnectFailed      = "Ni mogoče vzpostaviti povezave z oddaljenim strežnikom, preverjanje posodobitev je prekinjeno."
			UpdateCheckServerStatus  = "Preverite stanje strežnika ( na voljo je {0} možnosti )"
			UpdateServerAddress      = "Naslov strežnika"
			UpdateServeravailable    = "Status: Na voljo"
			UpdateServerUnavailable  = "Status: Ni na voljo"
			InstlTo                  = "Namesti v, novo ime"
			SelectFolder             = "Izberite imenik"
			OpenFolder               = "Odpri imenik"
			Paste                    = "kopirajte pot"
			FailedCreateFolder       = "Imenika ni bilo mogoče ustvariti"
			Failed                   = "spodleteti"
			IsOldFile                = "Izbrišite stare datoteke in poskusite znova"
			RestoreTo                = "Samodejno izbrano pri obnavljanju namestitvene poti"
			RestoreToDisk            = "Samodejno izberi razpoložljive diske"
			RestoreToDesktop         = "namizje"
			RestoreToDownload        = "prenos"
			RestoreToDocuments       = "dokument"
			FileName                 = "ime datoteke"
			Done                     = "Končaj"
			Inoperable               = "Neoperabilen"
			FileFormatError          = "Format datoteke ni pravilen"
			AdvOption                = "Izbirne funkcije"
			Ok_Go_To                 = "Na voljo za"
			Ok_Go_To_Main            = "glavni program"
			Ok_Go_To_No              = "Ne grem"
			OK_Go_To_Upgrade_package = "Ustvarite paket nadgradnje motorja za uvajanje"
			Unpacking                = "Razpakiranje"
			Running                  = "tek"
			SaveTo                   = "shrani v"
			OK                       = "seveda"
			Cancel                   = "Prekliči"
			UserCancel               = "Uporabnik je preklical operacijo."
			AllSel                   = "Izberite vse"
			AllClear                 = "počisti vse"
			Prerequisites            = "Predpogoji"
			Check_PSVersion          = "Preverite različico PS 5.1 in novejše"
			Check_OSVersion          = "Preverite različico sistema Windows > 10.0.16299.0"
			Check_Higher_elevated    = "Ček mora biti povišan na višje privilegije"
			Check_execution_strategy = "Preverite strategijo izvajanja"
			Check_Pass               = "mimo"
			Check_Did_not_pass       = "ni uspelo"
			Check_Pass_Done          = "Čestitam, uspešno."
			How_solve                = "Kako rešiti"
			UpdatePSVersion          = "Namestite najnovejšo različico PowerShell"
			UpdateOSVersion          = "1. Pojdite na Microsoftovo uradno spletno mesto in prenesite najnovejšo različico operacijskega sistema`n   2. Namestite najnovejšo različico operacijskega sistema in poskusite znova"
			HigherTermail            = "1. Odprite ""Terminal"" ali ""PowerShell ISE"" kot skrbnik, `n      Nastavite pravilnik izvajanja PowerShell: Bypass, ukazna vrstica PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Ko je težava rešena, znova zaženite ukaz."
			HigherTermailAdmin       = "1. Odprite ""Terminal"" ali ""PowerShell ISE"" kot skrbnik. `n    2. Ko je težava rešena, znova zaženite ukaz."
		}
	}
	@{
		Region   = "es-MX"
		Name     = "Spanish (Mexico)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Consíguelo en línea Agrega automáticamente los idiomas instalados a tu sistema Windows"
			UpdateServerSelect       = "Selección automática de servidor o selección personalizada"
			UpdateServerNoSelect     = "Por favor seleccione un servidor disponible"
			UpdatePriority           = "Ya establecido como prioridad"
			UpdateServerTestFailed   = "Prueba de estado del servidor fallida"
			UpdateQueryingUpdate     = "Consultando actualizaciones..."
			UpdateQueryingTime       = "Al comprobar si la última versión está disponible, la conexión tardó {0} milisegundos."
			UpdateConnectFailed      = "No se puede conectar al servidor remoto, se canceló la búsqueda de actualizaciones."
			UpdateCheckServerStatus  = "Verificar el estado del servidor ( {0} opciones disponibles )"
			UpdateServerAddress      = "Dirección del servidor"
			UpdateServeravailable    = "Estado: Disponible"
			UpdateServerUnavailable  = "Estado: No disponible"
			InstlTo                  = "Instalar en, nuevo nombre"
			SelectFolder             = "Seleccionar directorio"
			OpenFolder               = "directorio abierto"
			Paste                    = "copiar ruta"
			FailedCreateFolder       = "No se pudo crear el directorio"
			Failed                   = "fallar"
			IsOldFile                = "Elimina los archivos antiguos e inténtalo de nuevo."
			RestoreTo                = "Seleccionado automáticamente al restaurar la ruta de instalación"
			RestoreToDisk            = "Seleccionar automáticamente los discos disponibles"
			RestoreToDesktop         = "de oficina"
			RestoreToDownload        = "descargar"
			RestoreToDocuments       = "documento"
			FileName                 = "Nombre del archivo"
			Done                     = "Finalizar"
			Inoperable               = "Inoperable"
			FileFormatError          = "El formato del archivo es incorrecto"
			AdvOption                = "Características opcionales"
			Ok_Go_To                 = "Disponible para"
			Ok_Go_To_Main            = "programa principal"
			Ok_Go_To_No              = "no ir"
			OK_Go_To_Upgrade_package = "Crear un paquete de actualización del motor de implementación"
			Unpacking                = "Descomprimiendo"
			Running                  = "Correr"
			SaveTo                   = "guardar en"
			OK                       = "Seguro"
			Cancel                   = "Cancelar"
			UserCancel               = "El usuario ha cancelado la operación."
			AllSel                   = "Seleccionar todo"
			AllClear                 = "borrar todo"
			Prerequisites            = "Requisitos previos"
			Check_PSVersion          = "Verifique la versión de PS 5.1 y superior"
			Check_OSVersion          = "Verifique la versión de Windows > 10.0.16299.0"
			Check_Higher_elevated    = "El cheque debe estar elevado a privilegios más altos"
			Check_execution_strategy = "Verificar estrategia de ejecución"
			Check_Pass               = "aprobar"
			Check_Did_not_pass       = "fallido"
			Check_Pass_Done          = "Felicitaciones, pasó."
			How_solve                = "como resolver"
			UpdatePSVersion          = "Instale la última versión de PowerShell"
			UpdateOSVersion          = "1. Vaya al sitio web oficial de Microsoft para descargar la última versión del sistema operativo.`n   2. Instale la última versión del sistema operativo y vuelva a intentarlo."
			HigherTermail            = "1. Abra ""Terminal"" o ""PowerShell ISE"" como administrador, `n      Establecer política de ejecución de PowerShell: omitir, línea de comando PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Una vez resuelto, vuelva a ejecutar el comando."
			HigherTermailAdmin       = "1. Abra ""Terminal"" o ""PowerShell ISE"" como administrador. `n    2. Una vez resuelto, vuelva a ejecutar el comando."
		}
	}
	@{
		Region   = "th-TH"
		Name     = "Thai (Thailand)"
		Language = @{
			FontsUI                  = "Leelawadee UI"
			Get                      = "รับออนไลน์ เพิ่มภาษาที่ติดตั้งให้กับระบบ Windows ของคุณโดยอัตโนมัติ"
			UpdateServerSelect       = "การเลือกเซิร์ฟเวอร์อัตโนมัติหรือการเลือกแบบกำหนดเอง"
			UpdateServerNoSelect     = "โปรดเลือกเซิร์ฟเวอร์ที่มีอยู่"
			UpdatePriority           = "ตั้งเป็นลำดับความสำคัญแล้ว"
			UpdateServerTestFailed   = "การทดสอบสถานะเซิร์ฟเวอร์ล้มเหลว"
			UpdateQueryingUpdate     = "กำลังค้นหาการอัปเดต..."
			UpdateQueryingTime       = "กำลังตรวจสอบว่ามีเวอร์ชันล่าสุดหรือไม่ การเชื่อมต่อใช้เวลา {0} มิลลิวินาที"
			UpdateConnectFailed      = "ไม่สามารถเชื่อมต่อกับเซิร์ฟเวอร์ระยะไกลได้ การตรวจสอบการอัปเดตถูกยกเลิก"
			UpdateCheckServerStatus  = "ตรวจสอบสถานะเซิร์ฟเวอร์ ( มีตัวเลือก {0} รายการ )"
			UpdateServerAddress      = "ที่อยู่เซิร์ฟเวอร์"
			UpdateServeravailable    = "สถานะ: มีจำหน่าย"
			UpdateServerUnavailable  = "สถานะ: ไม่สามารถใช้ได้"
			InstlTo                  = "ติดตั้งเป็นชื่อใหม่"
			SelectFolder             = "เลือกไดเรกทอรี"
			OpenFolder               = "เปิดไดเรกทอรี"
			Paste                    = "คัดลอกเส้นทาง"
			FailedCreateFolder       = "ไม่สามารถสร้างไดเร็กทอรี"
			Failed                   = "ล้มเหลว"
			IsOldFile                = "โปรดลบไฟล์เก่าแล้วลองอีกครั้ง"
			RestoreTo                = "เลือกโดยอัตโนมัติเมื่อกู้คืนเส้นทางการติดตั้ง"
			RestoreToDisk            = "เลือกดิสก์ที่มีอยู่โดยอัตโนมัติ"
			RestoreToDesktop         = "เดสก์ท็อป"
			RestoreToDownload        = "ดาวน์โหลด"
			RestoreToDocuments       = "เอกสาร"
			FileName                 = "ชื่อไฟล์"
			Done                     = "เสร็จ"
			Inoperable               = "ใช้ไม่ได้"
			FileFormatError          = "รูปแบบไฟล์ไม่ถูกต้อง"
			AdvOption                = "คุณสมบัติเสริม"
			Ok_Go_To                 = "มีจำหน่ายที่"
			Ok_Go_To_Main            = "โปรแกรมหลัก"
			Ok_Go_To_No              = "ไม่ไป"
			OK_Go_To_Upgrade_package = "สร้างแพ็คเกจการอัพเกรดกลไกการปรับใช้งาน"
			Unpacking                = "กำลังคลายซิป"
			Running                  = "วิ่ง"
			SaveTo                   = "บันทึกไปที่"
			OK                       = "แน่นอน"
			Cancel                   = "ยกเลิก"
			UserCancel               = "ผู้ใช้ได้ยกเลิกการดำเนินการ"
			AllSel                   = "เลือกทั้งหมด"
			AllClear                 = "เคลียร์ทั้งหมด"
			Prerequisites            = "ข้อกำหนดเบื้องต้น"
			Check_PSVersion          = "ตรวจสอบ PS เวอร์ชัน 5.1 ขึ้นไป"
			Check_OSVersion          = "ตรวจสอบเวอร์ชัน Windows > 10.0.16299.0"
			Check_Higher_elevated    = "เช็คจะต้องยกระดับสิทธิ์ให้สูงขึ้น"
			Check_execution_strategy = "ตรวจสอบกลยุทธ์การดำเนินการ"
			Check_Pass               = "ผ่าน"
			Check_Did_not_pass       = "ล้มเหลว"
			Check_Pass_Done          = "ยินดีด้วย ผ่านไปแล้ว"
			How_solve                = "วิธีแก้ปัญหา"
			UpdatePSVersion          = "โปรดติดตั้ง PowerShell เวอร์ชันล่าสุด"
			UpdateOSVersion          = "1. ไปที่เว็บไซต์อย่างเป็นทางการของ Microsoft เพื่อดาวน์โหลดระบบปฏิบัติการเวอร์ชันล่าสุด`n   2. ติดตั้งระบบปฏิบัติการเวอร์ชันล่าสุดแล้วลองอีกครั้ง"
			HigherTermail            = "1. เปิด ""Terminal"" หรือ ""PowerShell ISE"" ในฐานะผู้ดูแลระบบ, `n      ตั้งค่านโยบายการดำเนินการ PowerShell: บายพาส, บรรทัดคำสั่ง PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. เมื่อแก้ไขแล้ว ให้รันคำสั่งอีกครั้ง"
			HigherTermailAdmin       = "1. เปิด ""Terminal"" หรือ ""PowerShell ISE"" ในฐานะผู้ดูแลระบบ. `n    2. เมื่อแก้ไขแล้ว ให้รันคำสั่งอีกครั้ง"
		}
	}
	@{
		Region   = "tr-TR"
		Name     = "Turkish (Turkey)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Çevrimiçi edinin Yüklü dilleri Windows sisteminize otomatik olarak ekleyin"
			UpdateServerSelect       = "Otomatik sunucu seçimi veya özel seçim"
			UpdateServerNoSelect     = "Lütfen kullanılabilir bir sunucu seçin"
			UpdatePriority           = "Zaten öncelikli olarak ayarlandı"
			UpdateServerTestFailed   = "Başarısız sunucu durumu testi"
			UpdateQueryingUpdate     = "Güncellemeler sorgulanıyor..."
			UpdateQueryingTime       = "En son sürümün mevcut olup olmadığı kontrol ediliyor, bağlantı {0} milisaniye sürdü."
			UpdateConnectFailed      = "Uzak sunucuya bağlanılamıyor, güncelleme kontrolü durduruldu."
			UpdateCheckServerStatus  = "Sunucu durumunu kontrol edin ( {0} seçenek mevcut )"
			UpdateServerAddress      = "Sunucu adresi"
			UpdateServeravailable    = "Durum: Mevcut"
			UpdateServerUnavailable  = "Durum: Mevcut değil"
			InstlTo                  = "Yükleme hedefi, yeni ad"
			SelectFolder             = "Dizin seçin"
			OpenFolder               = "Dizini aç"
			Paste                    = "yolu kopyala"
			FailedCreateFolder       = "Dizin oluşturulamadı"
			Failed                   = "hata"
			IsOldFile                = "Lütfen eski dosyaları silin ve tekrar deneyin"
			RestoreTo                = "Kurulum yolu geri yüklenirken otomatik olarak seçilir"
			RestoreToDisk            = "Kullanılabilir diskleri otomatik olarak seç"
			RestoreToDesktop         = "masaüstü"
			RestoreToDownload        = "indirmek"
			RestoreToDocuments       = "belge"
			FileName                 = "dosya adı"
			Done                     = "Sona ermek"
			Inoperable               = "Ameliyat edilemez"
			FileFormatError          = "Dosya formatı yanlış"
			AdvOption                = "İsteğe bağlı özellikler"
			Ok_Go_To                 = "Şunun için mevcut:"
			Ok_Go_To_Main            = "ana program"
			Ok_Go_To_No              = "gitmiyorum"
			OK_Go_To_Upgrade_package = "Dağıtım motoru yükseltme paketi oluşturma"
			Unpacking                = "Sıkıştırmayı açma"
			Running                  = "Koşma"
			SaveTo                   = "kaydet"
			OK                       = "Elbette"
			Cancel                   = "İptal etmek"
			UserCancel               = "Kullanıcı işlemi iptal etti."
			AllSel                   = "Tümünü seç"
			AllClear                 = "hepsini temizle"
			Prerequisites            = "Önkoşullar"
			Check_PSVersion          = "PS sürüm 5.1 ve üstünü kontrol edin"
			Check_OSVersion          = "Windows sürümünü kontrol edin > 10.0.16299.0"
			Check_Higher_elevated    = "Çekin daha yüksek ayrıcalıklara yükseltilmesi gerekiyor"
			Check_execution_strategy = "Yürütme stratejisini kontrol edin"
			Check_Pass               = "geçmek"
			Check_Did_not_pass       = "arızalı"
			Check_Pass_Done          = "Tebrikler, geçti."
			How_solve                = "Nasıl çözülür?"
			UpdatePSVersion          = "Lütfen en son PowerShell sürümünü yükleyin"
			UpdateOSVersion          = "1. 前往微软官方网站下载最新版本的操作系统`n   2. 安装最新版本的操作系统并重试"
			HigherTermail            = "1. ""Terminal"" veya ""PowerShell ISE"" yi yönetici olarak açın, `n      PowerShell yürütme politikasını ayarlayın: Baypas, PS komut satırı: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Çözüldükten sonra komutu yeniden çalıştırın."
			HigherTermailAdmin       = "1. ""Terminal"" veya ""PowerShell ISE"" yi yönetici olarak açın. `n    2. Çözüldükten sonra komutu yeniden çalıştırın."
		}
	}
	@{
		Region   = "uk-UA"
		Name     = "Ukrainian (Ukraine)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Отримайте це онлайн Автоматично додайте встановлені мови до вашої системи Windows"
			UpdateServerSelect       = "Автоматичний вибір сервера або індивідуальний вибір"
			UpdateServerNoSelect     = "Виберіть доступний сервер"
			UpdatePriority           = "Вже встановлено як пріоритет"
			UpdateServerTestFailed   = "Невдала перевірка стану сервера"
			UpdateQueryingUpdate     = "Запит на оновлення..."
			UpdateQueryingTime       = "Перевірка доступності останньої версії, підключення зайняло {0} мілісекунд."
			UpdateConnectFailed      = "Неможливо підключитися до віддаленого сервера, перевірку оновлень перервано."
			UpdateCheckServerStatus  = "Перевірити статус сервера ( доступно {0} варіантів )"
			UpdateServerAddress      = "Адреса сервера"
			UpdateServeravailable    = "Статус: Є"
			UpdateServerUnavailable  = "Статус: недоступний"
			InstlTo                  = "Установити на, нова назва"
			SelectFolder             = "Виберіть каталог"
			OpenFolder               = "Відкрити каталог"
			Paste                    = "копіювати шлях"
			FailedCreateFolder       = "Не вдалося створити каталог"
			Failed                   = "провал"
			IsOldFile                = "Видаліть старі файли та повторіть спробу"
			RestoreTo                = "Автоматично вибирається під час відновлення шляху встановлення"
			RestoreToDisk            = "Автоматичний вибір доступних дисків"
			RestoreToDesktop         = "робочий стіл"
			RestoreToDownload        = "завантажити"
			RestoreToDocuments       = "документ"
			FileName                 = "ім'я файлу"
			Done                     = "Закінчити"
			Inoperable               = "Неоперабельний"
			FileFormatError          = "Неправильний формат файлу"
			AdvOption                = "Додаткові функції"
			Ok_Go_To                 = "Доступний для"
			Ok_Go_To_Main            = "основна програма"
			Ok_Go_To_No              = "Не йде"
			OK_Go_To_Upgrade_package = "Створіть пакет оновлення механізму розгортання"
			Unpacking                = "Розпакування"
			Running                  = "Біг"
			SaveTo                   = "зберегти в"
			OK                       = "звичайно"
			Cancel                   = "Скасувати"
			UserCancel               = "Користувач скасував операцію."
			AllSel                   = "Вибрати все"
			AllClear                 = "очистити все"
			Prerequisites            = "передумови"
			Check_PSVersion          = "Перевірте PS версії 5.1 і вище"
			Check_OSVersion          = "Перевірте версію Windows > 10.0.16299.0"
			Check_Higher_elevated    = "Чек повинен бути підвищений до вищих привілеїв"
			Check_execution_strategy = "Перевірити стратегію виконання"
			Check_Pass               = "пропуск"
			Check_Did_not_pass       = "не вдалося"
			Check_Pass_Done          = "Вітаю, пройдено."
			How_solve                = "Як вирішити"
			UpdatePSVersion          = "Установіть останню версію PowerShell"
			UpdateOSVersion          = "1. Перейдіть на офіційний сайт Microsoft, щоб завантажити останню версію операційної системи`n   2. Установіть останню версію операційної системи та повторіть спробу"
			HigherTermail            = "1. Відкрийте ""Термінал"" або ""PowerShell ISE"" як адміністратор, `n      Налаштувати політику виконання PowerShell: обійти, командний рядок PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Після вирішення повторіть команду."
			HigherTermailAdmin       = "1. Відкрийте ""Термінал"" або ""PowerShell ISE"" як адміністратор. `n    2. Після вирішення повторіть команду."
		}
	}
	@{
		Region   = "eu-es"
		Name     = "Basque (Basque)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Eskuratu sarean Gehitu automatikoki instalatutako hizkuntzak zure Windows sisteman"
			UpdateServerSelect       = "Zerbitzariaren hautaketa automatikoa edo hautaketa pertsonalizatua"
			UpdateServerNoSelect     = "Mesedez, hautatu erabilgarri dagoen zerbitzari bat"
			UpdatePriority           = "Dagoeneko lehentasun gisa ezarrita"
			UpdateServerTestFailed   = "Huts egin du zerbitzariaren egoeraren proba"
			UpdateQueryingUpdate     = "Eguneratzeak bilatzen..."
			UpdateQueryingTime       = "Azken bertsioa erabilgarri dagoen egiaztatzen, konexioak {0} milisegundo behar izan ditu."
			UpdateConnectFailed      = "Ezin izan da urruneko zerbitzariarekin konektatu, eguneratzeen egiaztapena bertan behera utzi da."
			UpdateCheckServerStatus  = "Egiaztatu zerbitzariaren egoera ( {0} aukera eskuragarri )"
			UpdateServerAddress      = "Zerbitzariaren helbidea"
			UpdateServeravailable    = "Egoera: Eskuragarri"
			UpdateServerUnavailable  = "Egoera: Ez dago erabilgarri"
			InstlTo                  = "Instalatu hemen, izen berria"
			SelectFolder             = "Hautatu direktorioa"
			OpenFolder               = "Ireki direktorioa"
			Paste                    = "kopiatu bidea"
			FailedCreateFolder       = "Ezin izan da direktorioa sortu"
			Failed                   = "huts egin"
			IsOldFile                = "Ezabatu fitxategi zaharrak eta saiatu berriro"
			RestoreTo                = "Automatikoki hautatu da instalazio-bidea berrezartzean"
			RestoreToDisk            = "Hautatu automatikoki eskuragarri dauden diskoak"
			RestoreToDesktop         = "mahaigaina"
			RestoreToDownload        = "deskargatu"
			RestoreToDocuments       = "dokumentua"
			FileName                 = "fitxategiaren izena"
			Done                     = "Amaitu"
			Inoperable               = "Funtzionaezina"
			FileFormatError          = "Fitxategiaren formatua ez da zuzena"
			AdvOption                = "Aukerako ezaugarriak"
			Ok_Go_To                 = "Eskuragarri"
			Ok_Go_To_Main            = "programa nagusia"
			Ok_Go_To_No              = "Ez joan"
			OK_Go_To_Upgrade_package = "Sortu hedapen-motorra eguneratzeko pakete bat"
			Unpacking                = "Deskonprimitzea"
			Running                  = "Korrika"
			SaveTo                   = "gorde"
			OK                       = "Noski"
			Cancel                   = "Utzi"
			UserCancel               = "Erabiltzaileak bertan behera utzi du eragiketa."
			AllSel                   = "Hautatu guztiak"
			AllClear                 = "dena garbitu"
			Prerequisites            = "Aurrebaldintzak"
			Check_PSVersion          = "Egiaztatu PS 5.1 bertsioa eta berriagoa"
			Check_OSVersion          = "Egiaztatu Windows bertsioa> 10.0.16299.0"
			Check_Higher_elevated    = "Txekea pribilegio altuagoetara igo behar da"
			Check_execution_strategy = "Egiaztatu exekuzio estrategia"
			Check_Pass               = "pasa"
			Check_Did_not_pass       = "huts egin zuen"
			Check_Pass_Done          = "Zorionak, gainditu."
			How_solve                = "Nola konpondu"
			UpdatePSVersion          = "Instalatu azken PowerShell bertsioa"
			UpdateOSVersion          = "1. Joan Microsoft-en webgune ofizialera sistema eragilearen azken bertsioa deskargatzeko`n   2. Instalatu sistema eragilearen azken bertsioa eta saiatu berriro"
			HigherTermail            = "1. Ireki ""Terminal"" edo ""PowerShell ISE"" administratzaile gisa, `n      Ezarri PowerShell exekuzio-politika: Saihestu, PS komando-lerroa: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Behin konponduta, berriro exekutatu komandoa."
			HigherTermailAdmin       = "1. Ireki ""Terminal"" edo ""PowerShell ISE"" administratzaile gisa. `n    2. Behin konponduta, berriro exekutatu komandoa."
		}
	}
	@{
		Region   = "gl-es"
		Name     = "Galician (Spain)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Conseguilo en liña Engade automaticamente os idiomas instalados ao teu sistema Windows"
			UpdateServerSelect       = "Selección automática do servidor ou selección personalizada"
			UpdateServerNoSelect     = "Selecciona un servidor dispoñible"
			UpdatePriority           = "Xa se estableceu como prioridade"
			UpdateServerTestFailed   = "Fallou a proba de estado do servidor"
			UpdateQueryingUpdate     = "Consultando actualizacións..."
			UpdateQueryingTime       = "Comprobando se a última versión está dispoñible, a conexión levou {0} milisegundos."
			UpdateConnectFailed      = "Non se puido conectar ao servidor remoto, abortouse a comprobación de actualizacións."
			UpdateCheckServerStatus  = "Comproba o estado do servidor ( {0} opcións dispoñibles )"
			UpdateServerAddress      = "Enderezo do servidor"
			UpdateServeravailable    = "Estado: Dispoñible"
			UpdateServerUnavailable  = "Estado: Non dispoñible"
			InstlTo                  = "Instalar en, novo nome"
			SelectFolder             = "Seleccione o directorio"
			OpenFolder               = "Abrir directorio"
			Paste                    = "copia camiño"
			FailedCreateFolder       = "Produciuse un erro ao crear o directorio"
			Failed                   = "fallar"
			IsOldFile                = "Elimina os ficheiros antigos e téntao de novo"
			RestoreTo                = "Seleccionado automaticamente ao restaurar a ruta de instalación"
			RestoreToDisk            = "Selecciona automaticamente os discos dispoñibles"
			RestoreToDesktop         = "escritorio"
			RestoreToDownload        = "descargar"
			RestoreToDocuments       = "documento"
			FileName                 = "nome do ficheiro"
			Done                     = "Remate"
			Inoperable               = "Inoperable"
			FileFormatError          = "O formato do ficheiro é incorrecto"
			AdvOption                = "Funcións opcionais"
			Ok_Go_To                 = "Dispoñible para"
			Ok_Go_To_Main            = "programa principal"
			Ok_Go_To_No              = "Non vai"
			OK_Go_To_Upgrade_package = "Crea un paquete de actualización do motor de implementación"
			Unpacking                = "Descomprimindo"
			Running                  = "Correndo"
			SaveTo                   = "gardar para"
			OK                       = "Claro"
			Cancel                   = "Cancelar"
			UserCancel               = "O usuario cancelou a operación."
			AllSel                   = "Selecciona todo"
			AllClear                 = "limpar todo"
			Prerequisites            = "Requisitos previos"
			Check_PSVersion          = "Comproba a versión de PS 5.1 ou superior"
			Check_OSVersion          = "Verifique a versión de Windows > 10.0.16299.0"
			Check_Higher_elevated    = "O cheque debe ser elevado a privilexios superiores"
			Check_execution_strategy = "Comprobar a estratexia de execución"
			Check_Pass               = "pasar"
			Check_Did_not_pass       = "fallou"
			Check_Pass_Done          = "Parabéns, superado."
			How_solve                = "Como resolver"
			UpdatePSVersion          = "Instala a última versión de PowerShell"
			UpdateOSVersion          = "1. Vaia ao sitio web oficial de Microsoft para descargar a última versión do sistema operativo`n   2. Instala a última versión do sistema operativo e téntao de novo"
			HigherTermail            = "1. Abre ""Terminal"" ou ""PowerShell ISE"" como administrador, `n      Establecer a política de execución de PowerShell: Omitir, liña de comandos PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Unha vez resolto, volve executar o comando."
			HigherTermailAdmin       = "1. Abre ""Terminal"" ou ""PowerShell ISE"" como administrador. `n    2. Unha vez resolto, volve executar o comando."
		}
	}
	@{
		Region   = "id-id"
		Name     = "Indonesian (Indonesia)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Dapatkan secara online Secara otomatis menambahkan bahasa yang diinstal ke sistem Windows Anda"
			UpdateServerSelect       = "Pemilihan server otomatis atau pemilihan khusus"
			UpdateServerNoSelect     = "Silakan pilih server yang tersedia"
			UpdatePriority           = "Sudah ditetapkan sebagai prioritas"
			UpdateServerTestFailed   = "Tes status server gagal"
			UpdateQueryingUpdate     = "Meminta pembaruan..."
			UpdateQueryingTime       = "Saat memeriksa apakah versi terbaru tersedia, koneksi memerlukan waktu {0} milidetik."
			UpdateConnectFailed      = "Tidak dapat terhubung ke server jarak jauh, pemeriksaan pembaruan dibatalkan."
			UpdateCheckServerStatus  = "Periksa status server ( {0} opsi tersedia )"
			UpdateServerAddress      = "Alamat server"
			UpdateServeravailable    = "Status: Tersedia"
			UpdateServerUnavailable  = "Status: Tidak tersedia"
			InstlTo                  = "Instal ke, nama baru"
			SelectFolder             = "Pilih direktori"
			OpenFolder               = "Buka direktori"
			Paste                    = "jalur penyalinan"
			FailedCreateFolder       = "Gagal membuat direktori"
			Failed                   = "gagal"
			IsOldFile                = "Silakan hapus file lama dan coba lagi"
			RestoreTo                = "Dipilih secara otomatis saat memulihkan jalur instalasi"
			RestoreToDisk            = "Pilih disk yang tersedia secara otomatis"
			RestoreToDesktop         = "desktop"
			RestoreToDownload        = "unduh"
			RestoreToDocuments       = "dokumen"
			FileName                 = "nama file"
			Done                     = "Menyelesaikan"
			Inoperable               = "Tidak bisa dioperasikan"
			FileFormatError          = "Format file salah"
			AdvOption                = "Fitur opsional"
			Ok_Go_To                 = "Tersedia untuk"
			Ok_Go_To_Main            = "program utama"
			Ok_Go_To_No              = "Tidak pergi"
			OK_Go_To_Upgrade_package = "Buat paket peningkatan mesin penerapan"
			Unpacking                = "Membuka ritsleting"
			Running                  = "Berlari"
			SaveTo                   = "simpan ke"
			OK                       = "Tentu"
			Cancel                   = "Membatalkan"
			UserCancel               = "Pengguna telah membatalkan operasi."
			AllSel                   = "Pilih semua"
			AllClear                 = "bersihkan semuanya"
			Prerequisites            = "Prasyarat"
			Check_PSVersion          = "Periksa PS versi 5.1 ke atas"
			Check_OSVersion          = "Periksa versi Windows> 10.0.16299.0"
			Check_Higher_elevated    = "Cek harus ditingkatkan ke hak istimewa yang lebih tinggi"
			Check_execution_strategy = "Periksa strategi eksekusi"
			Check_Pass               = "lulus"
			Check_Did_not_pass       = "gagal"
			Check_Pass_Done          = "Selamat, lulus."
			How_solve                = "Bagaimana cara mengatasinya"
			UpdatePSVersion          = "Silakan instal versi PowerShell terbaru"
			UpdateOSVersion          = "1. Kunjungi situs web resmi Microsoft untuk mengunduh sistem operasi versi terbaru`n   2. Instal sistem operasi versi terbaru dan coba lagi"
			HigherTermail            = "1. Buka ""Terminal"" atau ""PowerShell ISE"" sebagai administrator, `n      Tetapkan kebijakan eksekusi PowerShell: Bypass, baris perintah PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Setelah terselesaikan, jalankan kembali perintah tersebut."
			HigherTermailAdmin       = "1. Buka ""Terminal"" atau ""PowerShell ISE"" sebagai administrator. `n    2. Setelah terselesaikan, jalankan kembali perintah tersebut."
		}
	}
	@{
		Region   = "vi-vn"
		Name     = "Vietnamese (Vietnam)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Tải trực tuyến Tự động thêm ngôn ngữ đã cài đặt vào hệ thống Windows của bạn"
			UpdateServerSelect       = "Lựa chọn máy chủ tự động hoặc lựa chọn tùy chỉnh"
			UpdateServerNoSelect     = "Vui lòng chọn một máy chủ có sẵn"
			UpdatePriority           = "Đã được đặt làm ưu tiên"
			UpdateServerTestFailed   = "Kiểm tra trạng thái máy chủ không thành công"
			UpdateQueryingUpdate     = "Truy vấn cập nhật..."
			UpdateQueryingTime       = "Đang kiểm tra xem có phiên bản mới nhất hay không, kết nối mất {0} mili giây."
			UpdateConnectFailed      = "Không thể kết nối với máy chủ từ xa, việc kiểm tra cập nhật bị hủy bỏ."
			UpdateCheckServerStatus  = "Kiểm tra trạng thái máy chủ (có sẵn {0} tùy chọn)"
			UpdateServerAddress      = "Địa chỉ máy chủ"
			UpdateServeravailable    = "Tình trạng: Có sẵn"
			UpdateServerUnavailable  = "Tình trạng: Không có sẵn"
			InstlTo                  = "Cài đặt vào, tên mới"
			SelectFolder             = "Chọn thư mục"
			OpenFolder               = "Mở thư mục"
			Paste                    = "sao chép đường dẫn"
			FailedCreateFolder       = "Không tạo được thư mục"
			Failed                   = "thất bại"
			IsOldFile                = "Vui lòng xóa các tập tin cũ và thử lại"
			RestoreTo                = "Tự động chọn khi khôi phục đường dẫn cài đặt"
			RestoreToDisk            = "Tự động chọn đĩa có sẵn"
			RestoreToDesktop         = "máy tính để bàn"
			RestoreToDownload        = "tải về"
			RestoreToDocuments       = "tài liệu"
			FileName                 = "tên tập tin"
			Done                     = "Hoàn thành"
			Inoperable               = "Không thể hoạt động"
			FileFormatError          = "Định dạng tệp không chính xác"
			AdvOption                = "Tính năng tùy chọn"
			Ok_Go_To                 = "Có sẵn để"
			Ok_Go_To_Main            = "chương trình chính"
			Ok_Go_To_No              = "Không đi"
			OK_Go_To_Upgrade_package = "Tạo gói nâng cấp công cụ triển khai"
			Unpacking                = "Giải nén"
			Running                  = "Đang chạy"
			SaveTo                   = "lưu vào"
			OK                       = "Chắc chắn"
			Cancel                   = "Hủy bỏ"
			UserCancel               = "Người dùng đã hủy thao tác."
			AllSel                   = "Chọn tất cả"
			AllClear                 = "xóa tất cả"
			Prerequisites            = "Điều kiện tiên quyết"
			Check_PSVersion          = "Kiểm tra phiên bản PS 5.1 trở lên"
			Check_OSVersion          = "Kiểm tra phiên bản Windows > 10.0.16299.0"
			Check_Higher_elevated    = "Kiểm tra phải được nâng lên đặc quyền cao hơn"
			Check_execution_strategy = "Kiểm tra chiến lược thực hiện"
			Check_Pass               = "vượt qua"
			Check_Did_not_pass       = "thất bại"
			Check_Pass_Done          = "Xin chúc mừng, đã vượt qua."
			How_solve                = "Làm thế nào để giải quyết"
			UpdatePSVersion          = "Vui lòng cài đặt phiên bản PowerShell mới nhất"
			UpdateOSVersion          = "1. Truy cập trang web chính thức của Microsoft để tải xuống phiên bản hệ điều hành mới nhất`n   2. Cài đặt phiên bản hệ điều hành mới nhất và thử lại"
			HigherTermail            = "1. Mở ""Terminal"" hoặc ""PowerShell ISE"" với tư cách quản trị viên, `n      设置 PowerShell 执行策略：绕过，PS命令行：`n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Sau khi giải quyết xong, hãy chạy lại lệnh."
			HigherTermailAdmin       = "1. Mở ""Terminal"" hoặc ""PowerShell ISE"" với tư cách quản trị viên. `n    2. Sau khi giải quyết xong, hãy chạy lại lệnh."
		}
	}
	@{
		Region   = "sr-latn-rs"
		Name     = "Serbian (Latin, Serbia)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Набавите га на мрежи. Аутоматски додајте инсталиране језике у свој Виндовс систем"
			UpdateServerSelect       = "Аутоматски избор сервера или прилагођени избор"
			UpdateServerNoSelect     = "Молимо изаберите доступни сервер"
			UpdatePriority           = "Већ постављено као приоритет"
			UpdateServerTestFailed   = "Тест статуса сервера није успео"
			UpdateQueryingUpdate     = "Упит за ажурирања..."
			UpdateQueryingTime       = "Проверавањем да ли је најновија верзија доступна, веза је трајала {0} милисекунди."
			UpdateConnectFailed      = "Није могуће повезати се са удаљеним сервером, провера ажурирања је прекинута."
			UpdateCheckServerStatus  = "Проверите статус сервера ( доступних опција: {0} )"
			UpdateServerAddress      = "Адреса сервера"
			UpdateServeravailable    = "Статус: Доступан"
			UpdateServerUnavailable  = "Статус: Није доступно"
			InstlTo                  = "Инсталирај на, ново име"
			SelectFolder             = "Изаберите директоријум"
			OpenFolder               = "Отворите директоријум"
			Paste                    = "путања за копирање"
			FailedCreateFolder       = "Креирање директоријума није успело"
			Failed                   = "пропасти"
			IsOldFile                = "Избришите старе датотеке и покушајте поново"
			RestoreTo                = "Аутоматски се бира приликом враћања инсталационе путање"
			RestoreToDisk            = "Аутоматски изаберите доступне дискове"
			RestoreToDesktop         = "десктоп"
			RestoreToDownload        = "преузимање"
			RestoreToDocuments       = "документ"
			FileName                 = "назив датотеке"
			Done                     = "Заврши"
			Inoperable               = "Неоперабилан"
			FileFormatError          = "Формат датотеке је нетачан"
			AdvOption                = "Опционе карактеристике"
			Ok_Go_To                 = "Доступан за"
			Ok_Go_To_Main            = "главни програм"
			Ok_Go_To_No              = "Не иде"
			OK_Go_To_Upgrade_package = "Креирајте пакет за надоградњу машине за примену"
			Unpacking                = "Распакивање"
			Running                  = "Трчање"
			SaveTo                   = "сачувати у"
			OK                       = "Наравно"
			Cancel                   = "Откажи"
			UserCancel               = "Корисник је отказао операцију."
			AllSel                   = "Изаберите све"
			AllClear                 = "очисти све"
			Prerequisites            = "Предуслови"
			Check_PSVersion          = "Проверите ПС верзију 5.1 и новију"
			Check_OSVersion          = "Проверите верзију Виндовс-а > 10.0.16299.0"
			Check_Higher_elevated    = "Провера мора бити подигнута на више привилегије"
			Check_execution_strategy = "Проверите стратегију извршења"
			Check_Pass               = "проћи"
			Check_Did_not_pass       = "пропао"
			Check_Pass_Done          = "Честитам, прошао."
			How_solve                = "Како решити"
			UpdatePSVersion          = "Инсталирајте најновију верзију ПоверСхелл-а"
			UpdateOSVersion          = "1. Идите на званичну веб локацију компаније Мицрософт да бисте преузели најновију верзију оперативног система`n   2. Инсталирајте најновију верзију оперативног система и покушајте поново"
			HigherTermail            = "1. Отворите ""Терминал"" или ""ПоверСхелл ИСЕ"" као администратор, `n      Подесите политику извршавања ПоверСхелл-а: Заобиђите, ПС командна линија:`n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Када се реши, поново покрените команду."
			HigherTermailAdmin       = "1. Отворите ""Терминал"" или ""ПоверСхелл ИСЕ"" као администратор. `n    2. Када се реши, поново покрените команду."
		}
	}
	@{
		Region   = "de-DE"
		Name     = "German (Germany)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Holen Sie es online. Fügen Sie installierte Sprachen automatisch zu Ihrem Windows-System hinzu"
			UpdateServerSelect       = "Automatische Serverauswahl oder benutzerdefinierte Auswahl"
			UpdateServerNoSelect     = "Bitte wählen Sie einen verfügbaren Server aus"
			UpdatePriority           = "Bereits als Priorität festgelegt"
			UpdateServerTestFailed   = "Serverstatustest fehlgeschlagen"
			UpdateQueryingUpdate     = "Ich frage nach Updates..."
			UpdateQueryingTime       = "Bei der Überprüfung, ob die neueste Version verfügbar ist, hat die Verbindung {0} Millisekunden gedauert."
			UpdateConnectFailed      = "Es konnte keine Verbindung zum Remote-Server hergestellt werden, die Suche nach Aktualisierungen wurde abgebrochen."
			UpdateCheckServerStatus  = "Serverstatus prüfen ( {0} Optionen verfügbar )"
			UpdateServerAddress      = "Serveradresse"
			UpdateServeravailable    = "Status: Verfügbar"
			UpdateServerUnavailable  = "Status: Nicht verfügbar"
			InstlTo                  = "Installieren unter, neuer Name"
			SelectFolder             = "Verzeichnis auswählen"
			OpenFolder               = "Verzeichnis öffnen"
			Paste                    = "Pfad kopieren"
			FailedCreateFolder       = "Verzeichnis konnte nicht erstellt werden"
			Failed                   = "scheitern"
			IsOldFile                = "Bitte löschen Sie die alten Dateien und versuchen Sie es erneut"
			RestoreTo                = "Wird beim Wiederherstellen des Installationspfads automatisch ausgewählt"
			RestoreToDisk            = "Verfügbare Datenträger automatisch auswählen"
			RestoreToDesktop         = "Desktop"
			RestoreToDownload        = "herunterladen"
			RestoreToDocuments       = "dokumentieren"
			FileName                 = "Dateiname"
			Done                     = "Beenden"
			Inoperable               = "Inoperabel"
			FileFormatError          = "Das Dateiformat ist falsch"
			AdvOption                = "Optionale Funktionen"
			Ok_Go_To                 = "Verfügbar für"
			Ok_Go_To_Main            = "Hauptprogramm"
			Ok_Go_To_No              = "Geht nicht"
			OK_Go_To_Upgrade_package = "Erstellen Sie ein Upgradepaket für die Bereitstellungs-Engine"
			Unpacking                = "Entpacken"
			Running                  = "Läuft"
			SaveTo                   = "Speichern unter"
			OK                       = "Sicher"
			Cancel                   = "Stornieren"
			UserCancel               = "Der Benutzer hat den Vorgang abgebrochen."
			AllSel                   = "Alles auswählen"
			AllClear                 = "Alles klar"
			Prerequisites            = "Voraussetzungen"
			Check_PSVersion          = "Überprüfen Sie PS-Version 5.1 und höher"
			Check_OSVersion          = "Überprüfen Sie die Windows-Version > 10.0.16299.0"
			Check_Higher_elevated    = "Die Prüfung muss auf höhere Berechtigungen erhöht werden"
			Check_execution_strategy = "Ausführungsstrategie prüfen"
			Check_Pass               = "passieren"
			Check_Did_not_pass       = "fehlgeschlagen"
			Check_Pass_Done          = "Herzlichen Glückwunsch, bestanden."
			How_solve                = "So lösen Sie es"
			UpdatePSVersion          = "Bitte installieren Sie die neueste PowerShell-Version"
			UpdateOSVersion          = "1. Besuchen Sie die offizielle Website von Microsoft, um die neueste Version des Betriebssystems herunterzuladen`n   2. Installieren Sie die neueste Version des Betriebssystems und versuchen Sie es erneut"
			HigherTermail            = "1. Öffnen Sie ""Terminal"" oder ""PowerShell ISE"" als Administrator, `n      PowerShell-Ausführungsrichtlinie festlegen: Bypass, PS-Befehlszeile: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. Sobald das Problem gelöst ist, führen Sie den Befehl erneut aus."
			HigherTermailAdmin       = "1. Öffnen Sie ""Terminal"" oder ""PowerShell ISE"" als Administrator. `n    2. Sobald das Problem gelöst ist, führen Sie den Befehl erneut aus."
		}
	}
	@{
		Region   = "ru-RU"
		Name     = "Russian (Russia)"
		Language = @{
			FontsUI                  = "Segoe UI"
			Get                      = "Получите его онлайн. Автоматически добавляйте установленные языки в вашу систему Windows"
			UpdateServerSelect       = "Автоматический выбор сервера или индивидуальный выбор"
			UpdateServerNoSelect     = "Пожалуйста, выберите доступный сервер"
			UpdatePriority           = "Уже установлено в качестве приоритета"
			UpdateServerTestFailed   = "Неудачная проверка состояния сервера"
			UpdateQueryingUpdate     = "Запрос обновлений..."
			UpdateQueryingTime       = "Проверка доступности последней версии. Соединение заняло {0} миллисекунд."
			UpdateConnectFailed      = "Невозможно подключиться к удаленному серверу, проверка обновлений прервана."
			UpdateCheckServerStatus  = "Проверьте состояние сервера ( доступны варианты: {0} )"
			UpdateServerAddress      = "Адрес сервера"
			UpdateServeravailable    = "Статус: Доступен"
			UpdateServerUnavailable  = "Статус: Не доступен"
			InstlTo                  = "Установить, новое имя"
			SelectFolder             = "Выберите каталог"
			OpenFolder               = "Открыть каталог"
			Paste                    = "копировать путь"
			FailedCreateFolder       = "Не удалось создать каталог"
			Failed                   = "неудача"
			IsOldFile                = "Пожалуйста, удалите старые файлы и повторите попытку."
			RestoreTo                = "Автоматически выбирается при восстановлении пути установки"
			RestoreToDisk            = "Автоматически выбирать доступные диски"
			RestoreToDesktop         = "рабочий стол"
			RestoreToDownload        = "скачать"
			RestoreToDocuments       = "документ"
			FileName                 = "имя файла"
			Done                     = "Заканчивать"
			Inoperable               = "Неработоспособный"
			FileFormatError          = "Формат файла неправильный"
			AdvOption                = "Дополнительные функции"
			Ok_Go_To                 = "Доступно для"
			Ok_Go_To_Main            = "основная программа"
			Ok_Go_To_No              = "Не собираюсь"
			OK_Go_To_Upgrade_package = "Создайте пакет обновления механизма развертывания."
			Unpacking                = "Распаковка"
			Running                  = "Бег"
			SaveTo                   = "сохранить в"
			OK                       = "Конечно"
			Cancel                   = "Отмена"
			UserCancel               = "Пользователь отменил операцию."
			AllSel                   = "Выбрать все"
			AllClear                 = "очистить все"
			Prerequisites            = "Предварительные условия"
			Check_PSVersion          = "Проверьте версию PS 5.1 и выше."
			Check_OSVersion          = "Проверьте версию Windows > 10.0.16299.0."
			Check_Higher_elevated    = "Проверка должна быть повышена до более высоких привилегий"
			Check_execution_strategy = "Проверьте стратегию исполнения"
			Check_Pass               = "проходить"
			Check_Did_not_pass       = "неуспешный"
			Check_Pass_Done          = "Поздравляю, прошло."
			How_solve                = "Как решить"
			UpdatePSVersion          = "Пожалуйста, установите последнюю версию PowerShell."
			UpdateOSVersion          = "1. Перейдите на официальный сайт Microsoft, чтобы загрузить последнюю версию операционной системы.`n   2. Установите последнюю версию операционной системы и повторите попытку."
			HigherTermail            = "1. Откройте ""Terminal"" или ""PowerShell ISE"" от имени администратора, `n      Установите политику выполнения PowerShell: Обход, командная строка PS: `n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. После устранения проблемы повторите команду."
			HigherTermailAdmin       = "1. Откройте ""Terminal"" или ""PowerShell ISE"" от имени администратора. `n    2. После устранения проблемы повторите команду."
		}
	}
	@{
		Region   = "ja-JP"
		Name     = "Japanese (Japan)"
		Language = @{
			FontsUI                  = "Yu Gothic UI"
			Get                      = "オンラインで入手 インストールされた言語を Windows システムに自動的に追加する"
			UpdateServerSelect       = "自動サーバー選択またはカスタム選択"
			UpdateServerNoSelect     = "利用可能なサーバーを選択してください"
			UpdatePriority           = "すでに優先として設定されています"
			UpdateServerTestFailed   = "サーバーステータステストの失敗"
			UpdateQueryingUpdate     = "更新を問い合わせています..."
			UpdateQueryingTime       = "最新バージョンが利用可能かどうかの確認に、接続に {0} ミリ秒かかりました。"
			UpdateConnectFailed      = "リモートサーバーに接続できず、アップデートのチェックが中止されました。"
			UpdateCheckServerStatus  = "サーバーのステータスを確認します ( {0} 個のオプションが利用可能 )"
			UpdateServerAddress      = "サーバーアドレス"
			UpdateServeravailable    = "ステータス: 利用可能"
			UpdateServerUnavailable  = "ステータス: 利用不可"
			InstlTo                  = "インストール先、新しい名前"
			SelectFolder             = "ディレクトリの選択"
			OpenFolder               = "ディレクトリを開く"
			Paste                    = "パスをコピーする"
			FailedCreateFolder       = "ディレクトリの作成に失敗しました"
			Failed                   = "失敗"
			IsOldFile                = "古いファイルを削除して再試行してください"
			RestoreTo                = "インストールパスを復元するときに自動的に選択されます"
			RestoreToDisk            = "利用可能なディスクを自動的に選択する"
			RestoreToDesktop         = "デスクトップ"
			RestoreToDownload        = "ダウンロード"
			RestoreToDocuments       = "書類"
			FileName                 = "ファイル名"
			Done                     = "仕上げる"
			Inoperable               = "動作不能"
			FileFormatError          = "ファイル形式が正しくありません"
			AdvOption                = "オプション機能"
			Ok_Go_To                 = "利用可能"
			Ok_Go_To_Main            = "メインプログラム"
			Ok_Go_To_No              = "行かない"
			OK_Go_To_Upgrade_package = "アップグレードパッケージの作成"
			Unpacking                = "解凍中"
			Running                  = "ランニング"
			SaveTo                   = "に保存する"
			OK                       = "もちろん"
			Cancel                   = "キャンセル"
			UserCancel               = "ユーザーが操作をキャンセルしました。"
			AllSel                   = "すべて選択"
			AllClear                 = "すべてクリアする"
			Prerequisites            = "前提条件"
			Check_PSVersion          = "PS バージョン 5.1 以降を確認してください"
			Check_OSVersion          = "Windows バージョン > 10.0.16299.0 を確認してください"
			Check_Higher_elevated   = "チェックはより高い特権に昇格する必要があります"
			Check_execution_strategy = "実行戦略を確認する"
			Check_Pass               = "合格"
			Check_Did_not_pass       = "失敗した"
			Check_Pass_Done          = "おめでとうございます、合格しました。"
			How_solve                = "解決方法"
			UpdatePSVersion          = "最新の PowerShell バージョンをインストールしてください"
			UpdateOSVersion          = "1. Microsoft の公式 Web サイトにアクセスして、`n      オペレーティング システムの最新バージョンをダウンロードします。`n   2. 最新バージョンのオペレーティング システムをインストールして再試行してください"
			HigherTermail            = "1. 管理者としてターミナルまたは PowerShell ISE を開きます。`n      设置 PowerShell 执行策略：绕过，PS命令行：`n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. 解決したら、コマンドを再実行します。"
			HigherTermailAdmin       = "1. 管理者としてターミナルまたは PowerShell ISE を開きます。`n    2. 解決したら、コマンドを再実行します。"
		}
	}
	@{
		Region   = "ko-KR"
		Name     = "Korean (Korea)"
		Language = @{
			FontsUI                  = "Malgun Gothic"
			Get                      = "온라인으로 받기 설치된 언어를 Windows 시스템에 자동으로 추가"
			UpdateServerSelect       = "자동 서버 선택 또는 사용자 정의 선택"
			UpdateServerNoSelect     = "사용 가능한 서버를 선택해주세요"
			UpdatePriority           = "이미 우선순위로 설정됨"
			UpdateServerTestFailed   = "서버 상태 테스트 실패"
			UpdateQueryingUpdate     = "업데이트를 쿼리하는 중..."
			UpdateQueryingTime       = "최신 버전을 사용할 수 있는지 확인하는 데 {0} 밀리초가 걸렸습니다."
			UpdateConnectFailed      = "원격 서버에 연결할 수 없습니다. 업데이트 확인이 중단되었습니다."
			UpdateCheckServerStatus  = "서버 상태 확인 ( {0} 옵션 사용 가능 )"
			UpdateServerAddress      = "서버 주소"
			UpdateServeravailable    = "상태: 사용 가능"
			UpdateServerUnavailable  = "상태: 사용할 수 없음"
			InstlTo                  = "설치 위치, 새 이름"
			SelectFolder             = "디렉토리 선택"
			OpenFolder               = "디렉토리 열기"
			Paste                    = "경로 복사"
			FailedCreateFolder       = "디렉터리를 생성하지 못했습니다."
			Failed                   = "실패했습니다"
			IsOldFile                = "오래된 파일을 삭제하고 다시 시도해주세요"
			RestoreTo                = "설치 경로 복원 시 자동 선택"
			RestoreToDisk            = "사용 가능한 디스크 자동 선택"
			RestoreToDesktop         = "데스크탑"
			RestoreToDownload        = "다운로드"
			RestoreToDocuments       = "문서"
			FileName                 = "파일 이름"
			Done                     = "마치다"
			Inoperable               = "작동불가"
			FileFormatError          = "파일 형식이 잘못되었습니다."
			AdvOption                = "선택적 기능"
			Ok_Go_To                 = "사용 가능"
			Ok_Go_To_Main            = "메인 프로그램"
			Ok_Go_To_No              = "안 가요"
			OK_Go_To_Upgrade_package = "업그레이드 패키지 생성"
			Unpacking                = "압축 해제 중"
			Running                  = "달리기"
			SaveTo                   = "다음에 저장"
			OK                       = "확신하는"
			Cancel                   = "취소"
			UserCancel               = "사용자가 작업을 취소했습니다."
			AllSel                   = "모두 선택"
			AllClear                 = "모두 지우기"
			Prerequisites            = "전제 조건"
			Check_PSVersion          = "PS 버전 5.1 이상을 확인하세요"
			Check_OSVersion          = "Windows 버전 > 10.0.16299.0 확인"
			Check_Higher_elevated    = "수표를 더 높은 권한으로 올려야 합니다"
			Check_execution_strategy = "실행 전략 확인"
			Check_Pass               = "통과하다"
			Check_Did_not_pass       = "실패한"
			Check_Pass_Done          = "축하해요, 합격했어요."
			How_solve                = "해결 방법"
			UpdatePSVersion          = "최신 PowerShell 버전을 설치하세요."
			UpdateOSVersion          = "1. 최신 버전의 운영 체제를 다운로드하려면 Microsoft 공식 웹사이트로 이동하세요.`n   2. 최신 버전의 운영 체제를 설치하고 다시 시도해 보세요."
			HigherTermail            = "1. 터미널 또는 PowerShell ISE를 관리자로 열고, `n      PowerShell 실행 정책 설정: 우회, PS 명령줄:`n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. 해결되면 명령을 다시 실행하십시오."
			HigherTermailAdmin       = "1. 터미널 또는 PowerShell ISE를 관리자로 엽니다.`n    2. 해결되면 명령을 다시 실행하십시오."
		}
	}
	@{
		Region   = "zh-CN"
		Name     = "Chinese (Simplified, China)"
		Language = @{
			FontsUI                  = "Microsoft YaHei UI"
			Get                      = "在线获取 自动将已安装的语言添加到 Windows 系统"
			UpdateServerSelect       = "自动选择服务器或自定义选择"
			UpdateServerNoSelect     = "请选择可用的服务器"
			UpdatePriority           = "已设置为优先级"
			UpdateServerTestFailed   = "未通过服务器状态测试"
			UpdateQueryingUpdate     = "正在查询更新中..."
			UpdateQueryingTime       = "正检查是否有最新版本可用，连接耗时 {0} 毫秒。"
			UpdateConnectFailed      = "无法连接到远程服务器，检查更新已中止。"
			UpdateCheckServerStatus  = "检查服务器状态 ( 共 {0} 个可选 )"
			UpdateServerAddress      = "服务器地址"
			UpdateServeravailable    = "状态：可用"
			UpdateServerUnavailable  = "状态：不可用"
			InstlTo                  = "安装到，新名称"
			SelectFolder             = "选择目录"
			OpenFolder               = "打开目录"
			Paste                    = "复制路径"
			FailedCreateFolder       = "创建目录失败"
			Failed                   = "失败"
			IsOldFile                = "请删除旧文件后重试"
			RestoreTo                = "还原安装路径时自动选择"
			RestoreToDisk            = "自动选择可用磁盘"
			RestoreToDesktop         = "桌面"
			RestoreToDownload        = "下载"
			RestoreToDocuments       = "文档"
			FileName                 = "文件名"
			Done                     = "完成"
			Inoperable               = "不可操作"
			FileFormatError          = "文件格式不正确"
			AdvOption                = "可选功能"
			Ok_Go_To                 = "可前往"
			Ok_Go_To_Main            = "主程序"
			Ok_Go_To_No              = "不前往"
			OK_Go_To_Upgrade_package = "创建升级包"
			Unpacking                = "正在解压"
			Running                  = "运行中"
			SaveTo                   = "保存到"
			OK                       = "确定"
			Cancel                   = "取消"
			UserCancel               = "用户已取消操作。"
			AllSel                   = "选择所有"
			AllClear                 = "清除所有"
			Prerequisites            = "先决条件"
			Check_PSVersion          = "检查 PS 版本 5.1 及以上"
			Check_OSVersion          = "检查 Windows 版本 > 10.0.16299.0"
			Check_Higher_elevated    = "检查必须提升至更高权限"
			Check_execution_strategy = "检查执行策略"
			Check_Pass               = "通过"
			Check_Did_not_pass       = "没有通过"
			Check_Pass_Done          = "恭喜，通过了。"
			How_solve                = "如何解决"
			UpdatePSVersion          = "请安装最新的 PowerShell 版本"
			UpdateOSVersion          = "1. 前往微软官方网站下载最新版本的操作系统`n   2. 安装最新版本的操作系统并重试"
			HigherTermail            = "1. 以管理员身份打开 ""终端"" 或 ""PowerShell ISE""，`n      设置 PowerShell 执行策略：绕过，PS命令行：`n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. 解决后，重新运行命令。"
			HigherTermailAdmin       = "1. 以管理员身份打开 ""终端"" 或 ""PowerShell ISE""。`n    2. 解决后，重新运行命令。"
		}
	}
	@{
		Region   = "zh-TW"
		Name     = "Chinese (Traditional, Taiwan)"
		Language = @{
			FontsUI                  = "Microsoft JhengHei UI"
			Get                      = "線上取得 自動將安裝的語言新增至 Windows 系統"
			UpdateServerSelect       = "自動選擇伺服器或自訂選擇"
			UpdateServerNoSelect     = "請選擇可用的伺服器"
			UpdatePriority           = "已設定為優先權"
			UpdateServerTestFailed   = "未通過伺服器狀態測試"
			UpdateQueryingUpdate     = "正在查詢更新中..."
			UpdateQueryingTime       = "正檢查是否有最新版本可用，連線耗時 {0} 毫秒。"
			UpdateConnectFailed      = "無法連線到遠端伺服器，檢查更新已中止。"
			UpdateCheckServerStatus  = "檢查伺服器狀態 ( 共 {0} 個可選 )"
			UpdateServerAddress      = "伺服器位址"
			UpdateServeravailable    = "狀態：可用"
			UpdateServerUnavailable  = "狀態：不可用"
			InstlTo                  = "安裝到，新名稱"
			SelectFolder             = "選擇目錄"
			OpenFolder               = "開啟目錄"
			Paste                    = "複製路徑"
			FailedCreateFolder       = "建立目錄失敗"
			Failed                   = "失敗"
			IsOldFile                = "請刪除舊檔案後重試"
			RestoreTo                = "還原安裝路徑時自動選擇"
			RestoreToDisk            = "自動選擇可用磁碟"
			RestoreToDesktop         = "桌面"
			RestoreToDownload        = "下載"
			RestoreToDocuments       = "文件"
			FileName                 = "檔案名稱"
			Done                     = "完成"
			Inoperable               = "不可操作"
			FileFormatError          = "文件格式不正確"
			AdvOption                = "選用功能"
			Ok_Go_To                 = "可前往"
			Ok_Go_To_Main            = "主程式"
			Ok_Go_To_No              = "不前往"
			OK_Go_To_Upgrade_package = "創建升級包"
			Unpacking                = "正在解壓縮"
			Running                  = "運作中"
			SaveTo                   = "儲存到"
			OK                       = "確定"
			Cancel                   = "取消"
			UserCancel               = "使用者已取消操作。"
			AllSel                   = "選擇所有"
			AllClear                 = "清除所有"
			Prerequisites            = "先決條件"
			Check_PSVersion          = "檢查 PS 版本 5.1 以上"
			Check_OSVersion          = "檢查 Windows 版本 > 10.0.16299.0"
			Check_Higher_elevated    = "檢查必須提升至更高權限"
			Check_execution_strategy = "檢查執行策略"
			Check_Pass               = "透過"
			Check_Did_not_pass       = "沒有通過"
			Check_Pass_Done          = "恭喜，通過了。"
			How_solve                = "如何解決"
			UpdatePSVersion          = "請安裝最新的 PowerShell 版本"
			UpdateOSVersion          = "1. 前往微軟官方網站下載最新版本的作業系統`n   2. 安裝最新版本的作業系統並重試"
			HigherTermail            = "1. 以管理員身分開啟 ""終端"" 或 ""PowerShell ISE""，`n      設定 PowerShell 執行策略：繞過，PS命令列：`n`n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Force`n`n   2. 解決後，重新運行命令。"
			HigherTermailAdmin       = "1. 以管理員身分開啟 ""終端"" 或 ""PowerShell ISE""。`n    2. 解決後，重新運行命令。"
		}
	}
)

Function Language
{
	param
	(
		$NewLang = (Get-Culture).Name
	)

	$Global:lang = @()
	$Global:IsLang = ""

	ForEach ($item in $AvailableLanguages) {
		if ($item.Region -eq $NewLang) {
			$Global:lang = $item.Language
			$Global:IsLang = $item.Region
			return
		}
	}

	ForEach ($item in $AvailableLanguages) {
		if ($item.Region -eq "en-US") {
			$Global:lang = $item.Language
			$Global:IsLang = $item.Region
			return
		}
	}

	Write-Host "No language packs found, please try again." -ForegroundColor Red
	exit
}

<#
	.Prerequisite
#>
Function Prerequisite
{
	Clear-Host
	$Host.UI.RawUI.WindowTitle = "$($lang.Get) | $($lang.Prerequisites)"
	write-host "`n  $($lang.Prerequisites)" -ForegroundColor Yellow
	write-host "  $('-' * 80)"

	write-host "  $($lang.Check_PSVersion): " -NoNewline
	if ($PSVersionTable.PSVersion.major -ge "5") {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
	} else {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White

		write-host "`n  $($lang.How_solve): " -ForegroundColor Yellow
		write-host "  $('-' * 80)"
		write-host "  1. $($lang.UpdatePSVersion)`n"
		pause
		exit
	}

	write-host "  $($lang.Check_OSVersion): " -NoNewline
	$OSVer = [System.Environment]::OSVersion.Version;
	if (($OSVer.Major -eq 10 -and $OSVer.Minor -eq 0 -and $OSVer.Build -ge 16299)) {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
	} else {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White

		write-host "`n  $($lang.How_solve): " -ForegroundColor Yellow
		write-host "  $('-' * 80)"
		write-host "  $($lang.UpdateOSVersion)`n"
		pause
		exit
	}

	write-host "  $($lang.Check_Higher_elevated): " -NoNewline
	if (([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544") {
		Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White

		write-host "  $($lang.Check_execution_strategy): " -NoNewline
		switch (Get-ExecutionPolicy) {
			"Bypass" {
				Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
			}
			"RemoteSigned" {
				Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
			}
			"Unrestricted" {
				Write-Host " $($lang.Check_Pass) " -BackgroundColor DarkGreen -ForegroundColor White
			}
			default {
				Write-Host " $($lang.Check_Did_not_pass) " -BackgroundColor DarkRed -ForegroundColor White
	
				write-host "`n  $($lang.How_solve): " -ForegroundColor Yellow
				write-host "  $('-' * 80)"
				write-host "  $($lang.HigherTermail)`n"
				pause
				exit
			}
		}
	} else {
		Write-Host " $($lang.Failed) " -BackgroundColor DarkRed -ForegroundColor White

		write-host "`n  $($lang.How_solve): " -ForegroundColor Yellow
		write-host "  $('-' * 80)"
		write-host "  $($lang.HigherTermailAdmin)`n"
		pause
		exit
	}

	write-host "`n  $($lang.Check_Pass_Done)" -ForegroundColor Green
	Start-Sleep -s 2
}

<#
	.Dynamic save function
#>
Function Save_Dynamic
{
	param
	(
		$regkey,
		$name,
		$value,
		[switch]$Multi,
		[switch]$String
	)

	$Path = "HKCU:\SOFTWARE\Yi\$($regkey)"

	if (-not (Test-Path $Path)) {
		New-Item -Path $Path -Force -ErrorAction SilentlyContinue | Out-Null
	}

	if ($Multi) {
		New-ItemProperty -LiteralPath $Path -Name $name -Value $value -PropertyType MultiString -force -ErrorAction SilentlyContinue | Out-Null
	}
	if ($String) {
		New-ItemProperty -LiteralPath $Path -Name $name -Value $value -PropertyType String -force -ErrorAction SilentlyContinue | Out-Null
	}
}

Function Get_Arch_Path
{
	param
	(
		[string]$Path
	)

	switch ($env:PROCESSOR_ARCHITECTURE) {
		"arm64" {
			if (Test-Path -Path "$($Path)\$($arm64)" -PathType Container) {
				return Convert-Path -Path "$($Path)\$($arm64)" -ErrorAction SilentlyContinue
			}
		}
		"AMD64" {
			if (Test-Path -Path "$($Path)\$($AMD64)" -PathType Container) {
				return Convert-Path -Path "$($Path)\$($AMD64)" -ErrorAction SilentlyContinue
			}
		}
		"x86" {
			if (Test-Path -Path "$($Path)\$($x86)" -PathType Container) {
				return Convert-Path -Path "$($Path)\$($x86)" -ErrorAction SilentlyContinue
			}
		}
	}

	return $Path
}

Function Join_MainFolder
{
	param
	(
		[string]$Path
	)
	if ($Path.EndsWith('\'))
	{
		return $Path
	} else {
		return "$($Path)\"
	}
}

Function Get_Zip
{
	param
	(
		$Run
	)

	$Local_Zip_Path = @(
		"${env:ProgramFiles}\7-Zip\$($Run)"
		"${env:ProgramFiles(x86)}\7-Zip\$($Run)"
	)

	ForEach ($item in $Local_Zip_Path) {
		if (Test-Path -Path $item -PathType leaf) {
			return $item
		}
	}

	return $False
}

Function Archive
{
	param
	(
		$filename,
		$to
	)

	$filename = Convert-Path $filename -ErrorAction SilentlyContinue

	if (Test-Path -Path $to -PathType leaf) {
		$to = Convert-Path $to -ErrorAction SilentlyContinue
	}

	write-host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
	Write-Host $filename -ForegroundColor Green

	write-host "  $($lang.SaveTo): " -NoNewline -ForegroundColor Yellow
	Write-Host $to -ForegroundColor Green

	write-host "  $($lang.Unpacking)".PadRight(28) -NoNewline

	$Verify_Install_Path = Get_Zip -Run "7z.exe"
	if (Test-Path -Path $Verify_Install_Path -PathType leaf) {
		$arguments = @(
			"x",
			"-r",
			"-tzip",
			"""$($filename)""",
			"-o""$($to)""",
			"-y";
		)

		Start-Process -FilePath $Verify_Install_Path -ArgumentList $Arguments -Wait -WindowStyle Minimized

		Write-Host $lang.Done -ForegroundColor Green
	} else {
		Add-Type -AssemblyName System.IO.Compression.FileSystem
		Expand-Archive -LiteralPath $filename -DestinationPath $to -force
		Write-Host $lang.Done -ForegroundColor Green
	}

	Write-Host
}

Function TestArchive
{
	param
	(
		$Path
	)

	Add-Type -Assembly System.IO.Compression.FileSystem

	Try {
		$zipFile = [System.IO.Compression.ZipFile]::OpenRead($Path)
		$zipFile.Dispose()
		Return $true
	} Catch {
		$zipFile.Dispose()
		Return $false
	} Finally {
		If ($zipFile) {
			Try {
				$zipFile.Dispose()
			} Catch {
				
			}
		}
	}
}

Function Verify_Available_Size
{
	param
	(
		[string]$Disk,
		[int]$Size
	)

	$TempCheckVerify = $false

	Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | Where-Object { ((Join_MainFolder -Path $Disk) -eq $_.Root) } | ForEach-Object {
		if ($_.Free -gt (Convert_Size -From GB -To Bytes $Size)) {
			$TempCheckVerify = $True
		} else {
			$TempCheckVerify = $false
		}
	}

	return $TempCheckVerify
}

Function Convert_Size
{
	param
	(
		[validateset("Bytes","KB","MB","GB","TB")]
		[string]$From,
		[validateset("Bytes","KB","MB","GB","TB")]
		[string]$To,
		[Parameter(Mandatory=$true)]
		[double]$Value,
		[int]$Precision = 4
	)

	switch($From) {
		"Bytes" { $value = $Value }
		"KB" { $value = $Value * 1024 }
		"MB" { $value = $Value * 1024 * 1024 }
		"GB" { $value = $Value * 1024 * 1024 * 1024 }
		"TB" { $value = $Value * 1024 * 1024 * 1024 * 1024 }
	}

	switch ($To) {
		"Bytes" { return $value }
		"KB" { $Value = $Value/1KB }
		"MB" { $Value = $Value/1MB }
		"GB" { $Value = $Value/1GB }
		"TB" { $Value = $Value/1TB }
	}

	return [Math]::Round($value, $Precision, [MidPointRounding]::AwayFromZero)
}

Function Test_Available_Disk
{
	param
	(
		[string]$Path
	)

	try {
		New-Item -Path $Path -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

		$RandomGuid = [guid]::NewGuid()
		$test_tmp_filename = "writetest-$($RandomGuid)"
		$test_filename = Join-Path -Path $Path -ChildPath $test_tmp_filename -ErrorAction SilentlyContinue

		[io.file]::OpenWrite($test_filename).close()

		if (Test-Path $test_filename -PathType Leaf) {
			Remove-Item -Path $test_filename -ErrorAction SilentlyContinue
			return $true
		}
		$false
	} catch {
		return $false
	}
}

<#
	.Test if the URL address is available
#>
Function Test_URI
{
	Param
	(
		[Parameter(Position=0,Mandatory,HelpMessage="HTTP or HTTPS")]
		[ValidatePattern( "^(http|https)://" )]
		[Alias("url")]
		[string]$URI,

		[Parameter(ParameterSetName="Detail")]
		[Switch]$Detail,

		[ValidateScript({$_ -ge 0})]
		[int]$Timeout = 30
	)

	Process
	{
		Try
		{
			$paramHash = @{
				UseBasicParsing = $True
				DisableKeepAlive = $True
				Uri = $uri
				Method = 'Head'
				ErrorAction = 'stop'
				TimeoutSec = $Timeout
			}
			$test = Invoke-WebRequest @paramHash

			if ($Detail) {
				$test.BaseResponse | Select-Object ResponseURI, ContentLength, ContentType, LastModified, @{
					Name = "Status";
					Expression = {
						$Test.StatusCode
					}
				}
			} else {
				if ($test.statuscode -ne 200) {
					$False
				} else {
					$True
				}
			}
		} Catch {
			write-verbose -message $_.exception
			if ($Detail) {
				$objProp = [ordered]@{
					ResponseURI = $uri
					ContentLength = $null
					ContentType = $null
					LastModified = $null
					Status = 404
				}

				New-Object -TypeName psobject -Property $objProp
			} else {
				$False
			}
		}
	}
}

Function Installation_interface_UI
{
	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	[System.Windows.Forms.Application]::EnableVisualStyles()

	write-host "`n  $($lang.Get)"
	write-host "  $('-' * 80)"

	Function Install_Init_Disk_To
	{
		switch ($UI_Main_Install_To.SelectedItem.Path) {
			"AutoSelectDisk" {}
			"Desktop" {
				Save_Dynamic -regkey "Multilingual\Get" -name "InstlTo" -value "Desktop" -String
				return Join-Path -Path $([Environment]::GetFolderPath("Desktop")) -ChildPath $Default_directory_name
			}
			"Download" {
				Save_Dynamic -regkey "Multilingual\Get" -name "InstlTo" -value "Download" -String
				return Join-Path -Path $((New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path) -ChildPath $Default_directory_name
			}
			"Documents" {
				Save_Dynamic -regkey "Multilingual\Get" -name "InstlTo" -value "Documents" -String
				return Join-Path -Path $([Environment]::GetFolderPath("MyDocuments")) -ChildPath $Default_directory_name
			}
			default {
				if (Get-ItemProperty -Path "HKCU:\SOFTWARE\Yi\Multilingual\Get" -Name "Instl_To_Custom" -ErrorAction SilentlyContinue) {
					$GetNewInstallTo = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Yi\Multilingual\Get" -Name "Instl_To_Custom"
					Save_Dynamic -regkey "Multilingual\Get" -name "InstlTo" -value $GetNewInstallTo -String
					return $GetNewInstallTo
				} else {
					$UI_Main_Install_To.SelectedIndex = $UI_Main_Install_To.FindString($lang.RestoreToDisk)
				}
			}
		}

		Save_Dynamic -regkey "Multilingual\Get" -name "InstlTo" -value "AutoSelectDisk" -String
		$drives = Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | Where-Object { -not ((Join_MainFolder -Path $env:SystemDrive) -eq $_.Root) } | Select-Object -ExpandProperty 'Root'
		$FlagsSearchNewDisk = $False
		ForEach ($item in $drives) {
			if (Test_Available_Disk -Path $item) {
				$FlagsSearchNewDisk = $True

				if (Verify_Available_Size -Disk $item -Size "1") {
					return Join-Path -Path $item -ChildPath $Default_directory_name
				}
			}
		}

		if (-not ($FlagsSearchNewDisk)) {
			return Join-Path -Path $env:SystemDrive -ChildPath $Default_directory_name
		}
	}

	$UI_Main           = New-Object system.Windows.Forms.Form -Property @{
		autoScaleMode  = 2
		Height         = 720
		Width          = 550
		Text           = $lang.Get
		Font           = New-Object System.Drawing.Font($lang.FontsUI, 9, [System.Drawing.FontStyle]::Regular)
		StartPosition  = "CenterScreen"
		MaximizeBox    = $False
		MinimizeBox    = $False
		ControlBox     = $False
		BackColor      = "#ffffff"
		FormBorderStyle = "Fixed3D"
	}

	$UI_Main_Menu      = New-Object System.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		Height         = 565
		Width          = 505
		autoSizeMode   = 1
		Location       = '15,10'
		autoScroll     = $True
	}

	$UI_Main_Auto_Select = New-Object System.Windows.Forms.CheckBox -Property @{
		Height         = 30
		Width          = 480
		Text           = $lang.UpdateServerSelect
		Checked        = $True
		add_Click      = {
			$UI_Main_Error.Text = ""

			if ($UI_Main_Auto_Select.Checked) {
				$UI_Main_List.Enabled = $False
			} else {
				$UI_Main_List.Enabled = $True
			}
		}
	}
	$UI_Main_List      = New-Object system.Windows.Forms.FlowLayoutPanel -Property @{
		BorderStyle    = 0
		autosize       = 1
		autoSizeMode   = 1
		autoScroll     = $False
		Padding        = "15,0,0,0"
		Enabled        = $False
	}

	$UI_Main_List_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 25
		Width          = 480
	}

	$UI_Main_Save_To   = New-Object System.Windows.Forms.Label -Property @{
		autoSize       = 1
		Margin         = "0,0,0,10"
		Text           = "$($lang.InstlTo): $($Default_directory_name)"
	}
	$UI_Main_Save_To_Path = New-Object System.Windows.Forms.TextBox -Property @{
		Height         = 30
		Width          = 435
		Margin         = "25,5,0,20"
		Text           = ""
		Enabled        = $False
	}

	$UI_Main_Save_To_SelectFolder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 480
		Padding        = "23,0,5,0"
		Text           = $lang.SelectFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""

			$FolderBrowser   = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
				RootFolder   = "MyComputer"
			}

			if ($FolderBrowser.ShowDialog() -eq "OK") {
				if (Test_Available_Disk -Path $FolderBrowser.SelectedPath) {
					$UI_Main_Save_To_Path.Text = Join-Path -Path $FolderBrowser.SelectedPath -ChildPath $Default_directory_name
					Save_Dynamic -regkey "Multilingual\Get" -name "Instl_To_Custom" -value $UI_Main_Save_To_Path.Text -String
					Save_Dynamic -regkey "Multilingual\Get" -name "InstlTo" -value $UI_Main_Save_To_Path.Text -String
					$UI_Main_Install_To.SelectedIndex = $UI_Main_Install_To.FindString($lang.SelectFolder)
				} else {
					$UI_Main_Error.Text = $lang.FailedCreateFolder
				}
			} else {
				$UI_Main_Error.Text = $lang.UserCancel
			}
		}
	}

	$UI_Main_Install_To_Restore = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 480
		Padding        = "36,0,0,0"
		Text           = $lang.RestoreTo
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""

			$UI_Main_Save_To_Path.Text = Install_Init_Disk_To
			$UI_Main_Error.Text = "$($lang.RestoreTo), $($lang.Done)"
		}
	}
	$UI_Main_Install_To = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 405
		margin         = "55,0,0,20"
		Text           = ""
		DropDownStyle  = "DropDownList"
		add_Click      = {
			$UI_Main_Error.Text = ""
		}
	}

	$InstallToNew = [Collections.ArrayList]@(
		[pscustomobject]@{ Path = "AutoSelectDisk"; Lang = $lang.RestoreToDisk; }
		[pscustomobject]@{ Path = "Desktop";        Lang = $lang.RestoreToDesktop; }
		[pscustomobject]@{ Path = "Download";       Lang = $lang.RestoreToDownload; }
		[pscustomobject]@{ Path = "Documents";      Lang = $lang.RestoreToDocuments; }
		[pscustomobject]@{ Path = "";               Lang = $lang.SelectFolder; }
	)

	$UI_Main_Install_To.BindingContext = New-Object System.Windows.Forms.BindingContext
	$UI_Main_Install_To.Datasource = $InstallToNew
	$UI_Main_Install_To.ValueMember = "Path"
	$UI_Main_Install_To.DisplayMember = "Lang"

	if (Get-ItemProperty -Path "HKCU:\SOFTWARE\Yi\Multilingual\Get" -Name "InstlTo" -ErrorAction SilentlyContinue) {
		$GetNewInstallTo = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Yi\Multilingual\Get" -Name "InstlTo"
		switch ($GetNewInstallTo) {
			"AutoSelectDisk" {
				$UI_Main_Install_To.SelectedIndex = $UI_Main_Install_To.FindString($lang.RestoreToDisk)
			}
			"Desktop" {
				$UI_Main_Install_To.SelectedIndex = $UI_Main_Install_To.FindString($lang.RestoreToDesktop)
			}
			"Download" {
				$UI_Main_Install_To.SelectedIndex = $UI_Main_Install_To.FindString($lang.RestoreToDownload)
			}
			"Documents" {
				$UI_Main_Install_To.SelectedIndex = $UI_Main_Install_To.FindString($lang.RestoreToDocuments)
			}
			default {
				$UI_Main_Install_To.SelectedIndex = $UI_Main_Install_To.FindString($lang.SelectFolder)
			}
		}
	} else {
		$UI_Main_Install_To.SelectedIndex = $UI_Main_Install_To.FindString($lang.RestoreToDownload)
	}
	$UI_Main_Save_To_Path.Text = Install_Init_Disk_To

	$UI_Main_InstlTo_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 15
		Width          = 480
	}

	$UI_Main_Save_To_OpenFolder = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 480
		Padding        = "23,0,0,0"
		Text           = $lang.OpenFolder
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""

			if ([string]::IsNullOrEmpty($UI_Main_Save_To_Path.Text)) {
				$UI_Main_Error.Text = "$($lang.OpenFolder), $($lang.Inoperable)"
			} else {
				if (Test-Path -Path $UI_Main_Save_To_Path.Text -PathType Container) {
					Start-Process $UI_Main_Save_To_Path.Text

					$UI_Main_Error.Text = "$($lang.OpenFolder): $($UI_Main_Save_To_Path.Text), $($lang.Done)"
				} else {
					$UI_Main_Error.Text = "$($lang.OpenFolder): $($UI_Main_Save_To_Path.Text), $($lang.Inoperable)"
				}
			}
		}
	}

	$UI_Main_Save_To_Paste = New-Object system.Windows.Forms.LinkLabel -Property @{
		Height         = 35
		Width          = 480
		Padding        = "23,0,0,0"
		Text           = $lang.Paste
		LinkColor      = "GREEN"
		ActiveLinkColor = "RED"
		LinkBehavior   = "NeverUnderline"
		add_Click      = {
			$UI_Main_Error.Text = ""

			if ([string]::IsNullOrEmpty($UI_Main_Save_To_Path.Text)) {
				$UI_Main_Error.Text = "$($lang.Paste), $($lang.Inoperable)"
			} else {
				Set-Clipboard -Value $UI_Main_Save_To_Path.Text

				$UI_Main_Error.Text = "$($lang.Paste), $($lang.Done)"
			}
		}
	}

	$UI_Main_Save_To_Wrap = New-Object system.Windows.Forms.Label -Property @{
		Height         = 25
		Width          = 480
	}

	$UI_Main_Adv_Name  = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 480
		Text           = $lang.AdvOption
	}

	$UI_Main_To_Name  = New-Object System.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 480
		Padding        = "20,0,0,0"
		Text           = $lang.Ok_Go_To
	}
	$UI_Main_To        = New-Object system.Windows.Forms.ComboBox -Property @{
		Height         = 30
		Width          = 420
		margin         = "40,0,0,0"
		Text           = ""
		DropDownStyle  = "DropDownList"
		add_Click      = {
			$UI_Main_Error.Text = ""
		}
	}

	$OKGoToNew = [Collections.ArrayList]@(
		[pscustomobject]@{ Path = "Main";    Lang = $lang.OK_Go_To_Main; }
		[pscustomobject]@{ Path = "Upgrade"; Lang = $lang.OK_Go_To_Upgrade_package; }
		[pscustomobject]@{ Path = "";        Lang = $lang.Ok_Go_To_No; }
	)

	$UI_Main_To.BindingContext = New-Object System.Windows.Forms.BindingContext
	$UI_Main_To.Datasource = $OKGoToNew
	$UI_Main_To.ValueMember = "Path"
	$UI_Main_To.DisplayMember = "Lang"

	$UI_Main_End_Wrap  = New-Object system.Windows.Forms.Label -Property @{
		Height         = 20
		Width          = 480
	}

	$UI_Main_Error     = New-Object system.Windows.Forms.Label -Property @{
		Height         = 30
		Width          = 510
		Location       = "10,602"
		Text           = ""
	}
	$UI_Main_OK        = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 255
		Location       = "8,635"
		Text           = $lang.OK
		add_Click      = {
			if (Download_UI_Save) {
				$UI_Main.Hide()
				Download_Process
				$UI_Main.Close()
			}
		}
	}
	$UI_Main_Canel     = New-Object system.Windows.Forms.Button -Property @{
		UseVisualStyleBackColor = $True
		Height         = 36
		Width          = 255
		Location       = "268,635"
		Text           = $lang.Cancel
		add_Click      = {
			$UI_Main.Hide()
			write-host "  $($lang.UserCancel)" -ForegroundColor Red
			$UI_Main.Close()
		}
	}
	$UI_Main.controls.AddRange((
		$UI_Main_Menu,
		$UI_Main_Error,
		$UI_Main_OK,
		$UI_Main_Canel
	))

	$UI_Main_Menu.controls.AddRange((
		$UI_Main_Auto_Select,
		$UI_Main_List,
		$UI_Main_List_Wrap,
		$UI_Main_Save_To,
		$UI_Main_Save_To_Path,
		$UI_Main_Save_To_SelectFolder,
			$UI_Main_Install_To_Restore,
			$UI_Main_Install_To,
			$UI_Main_InstlTo_Wrap,

		$UI_Main_Save_To_OpenFolder,
		$UI_Main_Save_To_Paste,
		$UI_Main_Save_To_Wrap,
		$UI_Main_Adv_Name,
		$UI_Main_To_Name,
		$UI_Main_To,
		$UI_Main_End_Wrap
	))

	ForEach ($item in $Update_Server) {
		$CheckBox   = New-Object System.Windows.Forms.CheckBox -Property @{
			Height  = 35
			Width   = 435
			Text    = $item
			Tag     = $item
			Checked = $true
			add_Click = {
				$UI_Main_Error.Text = ""
			}
		}
		$UI_Main_List.controls.AddRange($CheckBox)
	}

	<#
		.Add right-click menu: select all, clear button
	#>
	$UI_Main_List_Select = New-Object System.Windows.Forms.ContextMenuStrip
	$UI_Main_List_Select.Items.Add($lang.AllSel).add_Click({
		$UI_Main_List.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $true
				}
			}
		}
	})
	$UI_Main_List_Select.Items.Add($lang.AllClear).add_Click({
		$UI_Main_List.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Enabled) {
					$_.Checked = $false
				}
			}
		}
	})
	$UI_Main_List.ContextMenuStrip = $UI_Main_List_Select

	<#
		.Param
	#>
		<#
			.Custom update server
		#>
		if (-not [string]::IsNullOrEmpty($Cus)) {
			$UI_Main_Auto_Select.Checked = $False
			$UI_Main_List.Enabled = $True

			$WaitAdd = @()

			ForEach ($item in $Cus) {
				if ($Update_Server -notcontains $item) {
					$WaitAdd += $item
				}
			}

			if ($WaitAdd.Count -gt 0) {
				ForEach ($item in $WaitAdd) {
					$CheckBox   = New-Object System.Windows.Forms.CheckBox -Property @{
						Height  = 35
						Width   = 435
						Text    = $item
						Tag     = $item
						add_Click = {
							$UI_Main_Error.Text = ""
						}
					}
					$UI_Main_List.controls.AddRange($CheckBox)
				}
			}
			
			$UI_Main_List.Controls | ForEach-Object {
				if ($_ -is [System.Windows.Forms.CheckBox]) {
					if ($Cus -Contains $_.Tag) {
						$_.ForeColor = "GREEN"
						$_.Checked = $True
					} else {
						$_.Checked = $False
					}
				}
			}
		}

		<#
			.User Interactive: Install to
		#>
		if (-not [string]::IsNullOrEmpty($To)) {
			switch ($To) {
				"AutoSelectDisk" {
					$UI_Main_Install_To.SelectedIndex = $UI_Main_Install_To.FindString($lang.RestoreToDisk)
					$UI_Main_Save_To_Path.Text = Install_Init_Disk_To
				}
				"Desktop" {
					$UI_Main_Install_To.SelectedIndex = $UI_Main_Install_To.FindString($lang.RestoreToDesktop)
					$UI_Main_Save_To_Path.Text = Install_Init_Disk_To
				}
				"Download" {
					$UI_Main_Install_To.SelectedIndex = $UI_Main_Install_To.FindString($lang.RestoreToDownload)
					$UI_Main_Save_To_Path.Text = Install_Init_Disk_To
				}
				"Documents" {
					$UI_Main_Install_To.SelectedIndex = $UI_Main_Install_To.FindString($lang.RestoreToDocuments)
					$UI_Main_Save_To_Path.Text = Install_Init_Disk_To
				}
				default {
					$UI_Main_Install_To.SelectedIndex = $UI_Main_Install_To.FindString($lang.SelectFolder)
					$UI_Main_Save_To_Path.Text = $To
				}
			}
		}

		<#
			.User Interactive: First visit to
		#>
		if (-not [string]::IsNullOrEmpty($GoTo)) {
			switch ($GoTo) {
				"Main" {
					$UI_Main_To.SelectedIndex = $UI_Main_To.FindString($lang.OK_Go_To_Main)
				}
				"Upgrade" {
					$UI_Main_To.SelectedIndex = $UI_Main_To.FindString($lang.OK_Go_To_Upgrade_package)
				}
				"No" {
					$UI_Main_To.SelectedIndex = $UI_Main_To.FindString($lang.Ok_Go_To_No)
				}
				default {
					$UI_Main_To.SelectedIndex = $UI_Main_To.FindString($lang.OK_Go_To_Main)
				}
			}
		}

	<#
		.User Interactive: User interactive: silent installation
	#>
	if ($Silent) {
		if (Download_UI_Save) {
			Download_Process
		} else {
			$UI_Main.ShowDialog() | Out-Null
		}
	} else {
		$UI_Main.ShowDialog() | Out-Null
	}
}

Function Download_UI_Save
{
	$Script:ServerList = @()

	if ($UI_Main_Auto_Select.Checked) {
		ForEach ($item in $Update_Server | Sort-Object { Get-Random } ) {
			$Script:ServerList += $item
		}
	} else {
		$UI_Main_List.Controls | ForEach-Object {
			if ($_ -is [System.Windows.Forms.CheckBox]) {
				if ($_.Checked) {
					$Script:ServerList += $_.Tag
				}
			}
		}

		if ($Script:ServerList.Count -gt 0) {
		} else {
			$UI_Main_Error.Text = $lang.UpdateServerNoSelect
			return $false
		}
	}

	if (Test-Path -Path $UI_Main_Save_To_Path.Text -PathType Container) {
		if (Test_Available_Disk -Path $UI_Main_Save_To_Path.Text) {
			if((Get-ChildItem $UI_Main_Save_To_Path.Text -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0) {
				$UI_Main_Error.Text = $lang.IsOldFile
				return $false
			} else {
				return $true
			}
		} else {
			$UI_Main_Error.Text = $lang.FailedCreateFolder
			return $false
		}
	} else {
		if (Test_Available_Disk -Path $UI_Main_Save_To_Path.Text) {
			return $true
		} else {
			$UI_Main_Error.Text = $lang.FailedCreateFolder
			return $false
		}
	}
}

<#
	.Download process
#>
Function Download_Process
{
	write-host "  $($lang.UpdateCheckServerStatus -f $Script:ServerList.Count)
   $('-' * 80)"

	ForEach ($item in $Script:ServerList) {
		write-host "  * $($lang.UpdateServerAddress): " -NoNewline -ForegroundColor Yellow
		Write-Host $item -ForegroundColor Green

		if (Test_URI $item) {
			$PreServerVersion = $item
			$ServerTest = $true
			write-host "    $($lang.UpdateServeravailable)" -ForegroundColor Green
			break
		} else {
			write-host "    $($lang.UpdateServerUnavailable)`n" -ForegroundColor Red
		}
	}

	if ($ServerTest) {
		write-host "  $('-' * 80)"
		write-host "    $($lang.UpdatePriority)" -ForegroundColor Green
	} else {
		write-host "    $($lang.UpdateServerTestFailed)" -ForegroundColor Red
		write-host "  $('-' * 80)"
		return
	}

	write-host "`n  $($lang.UpdateQueryingUpdate)"

	$RandomGuid = [guid]::NewGuid()
	$Temp_Main_Path = Join-Path -Path $env:TEMP -ChildPath $RandomGuid
	New-Item -Path $Temp_Main_Path -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

	$NewFileName = [IO.Path]::GetFileName($item)
	$NewFilePath = Join-Path -Path $Temp_Main_Path -ChildPath $NewFileName

	$error.Clear()
	$time = Measure-Command { Invoke-WebRequest -Uri $PreServerVersion -OutFile $NewFilePath -TimeoutSec 15 -ErrorAction stop }

	if ($error.Count -eq 0) {
		write-host "`n  $($lang.UpdateQueryingTime -f $time.TotalMilliseconds)"
	} else {
		write-host "`n  $($lang.UpdateConnectFailed)"
		return
	}

	write-host "`n  $($lang.InstlTo): " -NoNewline -ForegroundColor Yellow
	Write-Host $UI_Main_Save_To_Path.Text -ForegroundColor Green
	write-host "  $('-' * 80)"
	if (Test-Path -Path $NewFilePath -PathType leaf) {
		if (TestArchive -Path $NewFilePath) {
			Archive -filename $NewFilePath -to $UI_Main_Save_To_Path.Text
			remove-item -path $Temp_Main_Path -force -Recurse -ErrorAction silentlycontinue | Out-Null

			if ([string]::IsNullOrEmpty($UI_Main_To.SelectedItem.Path)) {
				write-host "`n  $($lang.Ok_Go_To): " -NoNewline -ForegroundColor Yellow
				Write-Host $lang.Ok_Go_To_No -ForegroundColor Red
			} else {
				write-host "`n  $($lang.Ok_Go_To): " -NoNewline -ForegroundColor Yellow

				switch ($UI_Main_To.SelectedItem.Path) {
					"Main" {
						Write-Host $lang.Ok_Go_To_Main -ForegroundColor Green
						write-host "  $('-' * 80)"

						$test_new_File = Join-Path -Path $UI_Main_Save_To_Path.Text -ChildPath "Engine.ps1"
						if (Test-Path -Path $test_new_File -PathType leaf) {
							write-host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
							Write-Host $test_new_File -ForegroundColor Green

							write-host "  $($lang.Running)".PadRight(22) -NoNewline -ForegroundColor Yellow
							$arguments = @(
								"-ExecutionPolicy",
								"ByPass",
								"-file",
								"""$($test_new_File)"""
							)

							Start-Process "powershell" -ArgumentList $arguments -Verb RunAs
							Write-Host $lang.Done -ForegroundColor Green

							write-host "`n  $('-' * 80)"
							write-host "  $($lang.Ok_Go_To): $($lang.Ok_Go_To_Main), $($lang.Done)" -ForegroundColor Green
						} else {
							write-host "  $($lang.Inoperable)" -ForegroundColor Red
						}
					}
					"Upgrade" {
						Write-Host $lang.OK_Go_To_Upgrade_package -ForegroundColor Green
						write-host "  $('-' * 80)"

						$test_new_File = Join-Path -Path $UI_Main_Save_To_Path.Text -ChildPath "_Create.Upgrade.Package.ps1"
						if (Test-Path -Path $test_new_File -PathType leaf) {
							write-host "  $($lang.Filename): " -NoNewline -ForegroundColor Yellow
							Write-Host $test_new_File -ForegroundColor Green

							write-host "  $($lang.Running)".PadRight(22) -NoNewline -ForegroundColor Yellow
							$arguments = @(
								"-ExecutionPolicy",
								"ByPass",
								"-file",
								"""$($test_new_File)"""
							)

							Start-Process "powershell" -ArgumentList $arguments -Verb RunAs
							Write-Host $lang.Done -ForegroundColor Green

							write-host "`n  $('-' * 80)"
							write-host "  $($lang.Ok_Go_To): $($lang.OK_Go_To_Upgrade_package), $($lang.Done)" -ForegroundColor Green
						} else {
							write-host "  $($lang.Inoperable)" -ForegroundColor Red
						}
					}
					default {
						Write-Host $lang.Ok_Go_To_No -ForegroundColor Red
					}
				}
			}
		} else {
			write-host "  $($lang.FileFormatError)"
			remove-item -path $Temp_Main_Path -force -Recurse -ErrorAction silentlycontinue | Out-Null
		}
	} else {
		write-host "  $($lang.UpdateConnectFailed)"
		remove-item -path $Temp_Main_Path -force -Recurse -ErrorAction silentlycontinue | Out-Null
	}
}

<#
	.Reset script usage history
#>
if ($Reset) {
	$Path = "HKCU:\SOFTWARE\Yi\Multilingual\Get"
	Remove-Item -Path $Path -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
}

<#
	.Set language pack, usage:
	 Language                  | Language selected by the user
	 Language -NewLang "zh-CN" | Mandatory use of specified language
#>
if ($Language) {
	Language -NewLang $Language
} else {
	Language
}

<#
	.Prerequisites
#>
Prerequisite

<#
	.Installation interface
#>
Installation_interface_UI