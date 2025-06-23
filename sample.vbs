Dim inputFile, outputFile
inputFile = "C:\IOT Gateway\run2.log"
outputFile = "C:\IOT Gateway\sample.log"

Dim objFSO, objFile, objOutFile, strData, matches, regEx, match

' สร้างอ็อบเจ็กต์ FileSystemObject
Set objFSO = CreateObject("Scripting.FileSystemObject")

' ตรวจสอบว่าไฟล์อินพุตมีอยู่หรือไม่
If Not objFSO.FileExists(inputFile) Then
    WScript.Quit
End If

' เปิดไฟล์เพื่อตรวจสอบเนื้อหา
Set objFile = objFSO.OpenTextFile(inputFile, 1, False)

' ตรวจสอบว่าไฟล์ไม่ว่างก่อนอ่าน
If objFile.AtEndOfStream Then
    objFile.Close
    WScript.Quit
End If

' อ่านข้อมูลจากไฟล์
strData = objFile.ReadAll
objFile.Close

' กำหนด Regular Expression เพื่อค้นหาข้อความระหว่าง Sample: และ STAT:
Set regEx = New RegExp
regEx.Pattern = "Sample:\s*(.*?)\s*STAT:"
regEx.Global = True
regEx.IgnoreCase = True
regEx.MultiLine = True

Set matches = regEx.Execute(strData)

' ตรวจสอบว่าพบข้อมูลหรือไม่
If matches.Count > 0 Then
    ' เปิดไฟล์สำหรับเขียนข้อมูลผลลัพธ์
    Set objOutFile = objFSO.OpenTextFile(outputFile, 2, True)
    
    ' วนลูปบันทึกข้อมูลที่พบ
    For Each match In matches
        objOutFile.WriteLine Trim(match.SubMatches(0))
    Next
    
    objOutFile.Close
End If

' ทำความสะอาดอ็อบเจ็กต์
Set objFSO = Nothing
Set objFile = Nothing
Set objOutFile = Nothing
Set regEx = Nothing

' ปิดสคริปต์
WScript.Quit
