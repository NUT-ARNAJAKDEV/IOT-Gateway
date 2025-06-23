Option Explicit

Dim inputFile, outputFile, objFSO, objFile, data, last18Chars

' กำหนดที่อยู่ของไฟล์
inputFile = "C:\IOT Gateway\run2.log"
outputFile = "C:\IOT Gateway\card.log"

' สร้างอ็อบเจ็กต์ FileSystemObject
Set objFSO = CreateObject("Scripting.FileSystemObject")

' ตรวจสอบว่าไฟล์ run2.log มีอยู่หรือไม่
If objFSO.FileExists(inputFile) Then
    ' เปิดไฟล์เพื่ออ่าน
    Set objFile = objFSO.OpenTextFile(inputFile, 1, False)
    
    ' ตรวจสอบว่าไฟล์ไม่ว่างเปล่า
    If Not objFile.AtEndOfStream Then
        data = Trim(objFile.ReadAll()) ' อ่านข้อมูลทั้งหมดและตัดช่องว่างด้านหน้า-ท้าย
    End If
    
    objFile.Close
    Set objFile = Nothing
    
    ' ตรวจสอบว่าไฟล์มีข้อมูลหรือไม่
    If Len(data) > 0 Then
        ' ดึง 18 ตัวอักษรสุดท้าย (หรือทั้งหมดถ้าน้อยกว่า 18)
        If Len(data) < 20 Then
            last18Chars = data
        Else
            last18Chars = Right(data, 20)
        End If
        
        ' เขียนข้อมูลลงในไฟล์ card.log
        Set objFile = objFSO.OpenTextFile(outputFile, 2, True)
        objFile.Write last18Chars
        objFile.Close
        Set objFile = Nothing
        
    Else
        
    End If
Else
    
End If

' ทำความสะอาดอ็อบเจ็กต์
Set objFSO = Nothing

' เพิ่มบรรทัดนี้เพื่อปิดสคริปต์
WScript.Quit
