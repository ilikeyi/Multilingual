ConvertFrom-StringData -StringData @'
	# th-TH
	# Thai (Thailand)

	Prerequisites                   = ข้อกำหนดเบื้องต้น
	Check_PSVersion                 = ตรวจสอบ PS เวอร์ชัน 5.1 ขึ้นไป
	Check_OSVersion                 = ตรวจสอบเวอร์ชัน Windows > 10.0.16299.0
	Check_Higher_elevated           = เช็คจะต้องยกระดับสิทธิ์ให้สูงขึ้น
	Check_execution_strategy        = ตรวจสอบกลยุทธ์การดำเนินการ

	Check_Pass                      = ผ่าน
	Check_Did_not_pass              = ล้มเหลว
	Check_Pass_Done                 = ยินดีด้วย ผ่านไปแล้ว
	How_solve                       = วิธีแก้ปัญหา
	UpdatePSVersion                 = โปรดติดตั้ง PowerShell เวอร์ชันล่าสุด
	UpdateOSVersion                 = 1. ไปที่เว็บไซต์อย่างเป็นทางการของ Microsoft เพื่อดาวน์โหลดระบบปฏิบัติการเวอร์ชันล่าสุด\n   2. ติดตั้งระบบปฏิบัติการเวอร์ชันล่าสุดแล้วลองอีกครั้ง
	HigherTermail                   = 1. เปิด Terminal หรือ PowerShell ISE ในฐานะผู้ดูแลระบบ, \n      ตั้งค่านโยบายการดำเนินการ PowerShell: บายพาส, บรรทัดคำสั่ง PS: \n\n      Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope LocalMachine -Force\n\n   2. เมื่อแก้ไขแล้วให้รันคำสั่งอีกครั้ง.
	HigherTermailAdmin              = 1. เปิด Terminal หรือ PowerShell ISE ในฐานะผู้ดูแลระบบ. \n    2. เมื่อแก้ไขแล้วให้รันคำสั่งอีกครั้ง.
'@