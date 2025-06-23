' ฟังก์ชันสำหรับย้ายข้อมูลบรรทัดแรก
Function MoveTopRow(sourceFile, destinationFile)
  On Error Resume Next ' จัดการข้อผิดพลาด

  ' สร้างอ็อบเจ็กต์ FileSystemObject
  Set fso = CreateObject("Scripting.FileSystemObject")

  ' ตรวจสอบว่าไฟล์ต้นทางมีอยู่หรือไม่
  If Not fso.FileExists(sourceFile) Then
    Exit Function
  End If

  ' อ่านข้อมูลจากไฟล์ต้นทาง
  Set inputFile = fso.OpenTextFile(sourceFile, 1, False, -2) ' 1 = อ่าน, -2 = ใช้ค่าเริ่มต้นของระบบ
  If inputFile.AtEndOfStream Then
    inputFile.Close
    Exit Function
  End If

  ' อ่านบรรทัดแรก
  topRow = inputFile.ReadLine

  ' อ่านข้อมูลที่เหลือ
  remainingLines = ""
  Do While Not inputFile.AtEndOfStream
    remainingLines = remainingLines & inputFile.ReadLine & vbCrLf
  Loop
  inputFile.Close

  ' เขียนบรรทัดแรกลงในไฟล์ปลายทาง
  Set outputFile = fso.OpenTextFile(destinationFile, 8, True, -2) ' 8 = เขียนต่อท้าย, True = สร้างไฟล์ถ้าไม่มี
  outputFile.WriteLine topRow
  outputFile.Close

  ' เขียนข้อมูลที่เหลือกลับลงในไฟล์ต้นทาง (ทับข้อมูลเดิม)
  Set outputFile = fso.OpenTextFile(sourceFile, 2, False, -2) ' 2 = เขียน
  outputFile.Write remainingLines
  outputFile.Close

End Function

' เรียกใช้งานฟังก์ชัน
sourceFile = "C:\IOT Gateway\err1.log"
destinationFile = "C:\IOT Gateway\err2.log"
Call MoveTopRow(sourceFile, destinationFile)

' เพิ่มบรรทัดนี้เพื่อปิดสคริปต์
WScript.Quit