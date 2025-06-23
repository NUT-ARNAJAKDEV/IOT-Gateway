Option Explicit

Dim inputFile, outputFile
inputFile = "C:\IOT Gateway\run2.log"
outputFile = "C:\IOT Gateway\technique.log"

Call ExtractTechniqueData(inputFile, outputFile)

Sub ExtractTechniqueData(inputFile, outputFile)
    Dim fso, file, data, regex, matches, match, result
    Set fso = CreateObject("Scripting.FileSystemObject")

    ' ตรวจสอบว่าไฟล์ input มีอยู่จริงหรือไม่
    If Not fso.FileExists(inputFile) Then
        Exit Sub
    End If

    ' เปิดไฟล์เพื่ออ่าน
    Set file = fso.OpenTextFile(inputFile, 1, False) ' 1 = ForReading
    
    ' ตรวจสอบว่าไฟล์ว่างเปล่าหรือไม่
    If file.AtEndOfStream Then
        file.Close
        Exit Sub
    End If
    
    ' อ่านไฟล์ทั้งหมด
    data = file.ReadAll
    file.Close

    ' สร้าง Regular Expression
    Set regex = New RegExp
    regex.Pattern = "Technique:\s*(.*?)\s*Sample:"
    regex.IgnoreCase = True
    regex.Global = True

    ' ค้นหาข้อความที่ตรงกับ Pattern
    Set matches = regex.Execute(data)
    
    ' ตรวจสอบว่าพบข้อมูลหรือไม่
    If matches.Count > 0 Then
        ' เปิดไฟล์ output เพื่อเขียนข้อมูล
        Set file = fso.OpenTextFile(outputFile, 2, True) ' 2 = ForWriting, True = Create file if not exists
        result = ""

        ' วนลูปผ่านค่าที่พบ
        For Each match In matches
            result = result & Trim(match.SubMatches(0)) & vbCrLf
        Next
        
        file.Write result
        file.Close
    End If

    ' Clean up
    Set file = Nothing
    Set fso = Nothing
    Set regex = Nothing
    Set matches = Nothing

        WScript.Quit ' ปิดโปรแกรมหลังจากทำงานเสร็จสิ้น
End Sub
