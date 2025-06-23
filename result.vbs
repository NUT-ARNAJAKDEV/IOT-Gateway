Option Explicit

Dim inputFile, outputFile, attempt
inputFile = "C:\IOT Gateway\run2.log"
outputFile = "C:\IOT Gateway\result.log"

' ลองดึงข้อมูล 2 ครั้ง
For attempt = 1 To 2
    If ExtractAndSaveResults(inputFile, outputFile) Then Exit For
Next

' ปิดสคริปต์ตัวเอง
WScript.Quit

Function ExtractAndSaveResults(inFile, outFile)
    Dim fso, file, content, matches, resultString
    Dim regex, match, outputFileObj
    ExtractAndSaveResults = False ' กำหนดค่าเริ่มต้นเป็น False (ยังไม่เจอข้อมูล)
    
    ' สร้าง FileSystemObject
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    ' ตรวจสอบว่าไฟล์อินพุตมีอยู่หรือไม่
    If Not fso.FileExists(inFile) Then
        Exit Function
    End If
    
    ' เปิดไฟล์และตรวจสอบว่ามีเนื้อหาหรือไม่
    Set file = fso.OpenTextFile(inFile, 1, False)
    If file.AtEndOfStream Then
        file.Close
        Exit Function
    End If
    
    ' อ่านเนื้อหาไฟล์
    content = file.ReadAll
    file.Close
    
    ' สร้าง RegExp
    Set regex = New RegExp
    regex.Pattern = "(?:Visio Result -|Visio Result:)(.*?)(?=ReadingIncidences:)"
    regex.Global = True
    regex.IgnoreCase = True
    
    ' ค้นหาข้อมูล
    Set matches = regex.Execute(content)
    
    If matches.Count > 0 Then
        resultString = "|"
        For Each match In matches
            resultString = resultString & Trim(match.SubMatches(0)) & "|"
        Next
        
        ' บันทึกผลลัพธ์ลงไฟล์
        Set outputFileObj = fso.OpenTextFile(outFile, 2, True)
        outputFileObj.WriteLine resultString
        outputFileObj.Close
        
        ExtractAndSaveResults = True ' พบข้อมูล -> คืนค่า True
    End If
    
    ' Cleanup
    Set file = Nothing
    Set fso = Nothing
    Set regex = Nothing
    Set outputFileObj = Nothing
End Function
