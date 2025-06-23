Option Explicit

Dim inputFile, outputFile, fso, infile, outfile, line

' กำหนดชื่อไฟล์ต้นทางและไฟล์ปลายทาง
inputFile = "C:\IOT Gateway\run2.log"
outputFile = "C:\IOT Gateway\time.log"

' สร้างอ็อบเจ็กต์ FileSystemObject
Set fso = CreateObject("Scripting.FileSystemObject")

' ตรวจสอบว่าไฟล์ต้นทางมีอยู่หรือไม่
If Not fso.FileExists(inputFile) Then
    
    WScript.Quit
End If

' เปิดไฟล์ต้นทางเพื่ออ่าน
Set infile = fso.OpenTextFile(inputFile, 1, False)

' ตรวจสอบว่าไฟล์มีข้อมูลหรือไม่
If infile.AtEndOfStream Then
    
    infile.Close
    WScript.Quit
End If

' เปิดไฟล์ปลายทางเพื่อเขียน
Set outfile = fso.OpenTextFile(outputFile, 2, True)

' อ่านไฟล์ทีละบรรทัด
Do Until infile.AtEndOfStream
    line = infile.ReadLine
    ' ตรวจสอบว่าความยาวบรรทัดมากกว่าหรือเท่ากับ 19 ตัวอักษร
    If Len(line) >= 19 Then
        ' ดึงตัวอักษรที่ 11 ถึง 18 และเขียนลงไฟล์
        outfile.WriteLine Mid(line, 12, 8)
    End If
Loop

' ปิดไฟล์
infile.Close
outfile.Close

' คืนค่าหน่วยความจำ
Set infile = Nothing
Set outfile = Nothing
Set fso = Nothing

' เพิ่มบรรทัดนี้เพื่อปิดสคริปต์
WScript.Quit
