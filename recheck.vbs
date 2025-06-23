Option Explicit

Dim resultFile, dateFile, cardFile, pathConfig, logFile, runFile
Dim dateData, cardData, filePath, line, resultData, logData
Dim fso, file, configFile

Set fso = CreateObject("Scripting.FileSystemObject")

' กำหนดพาธไฟล์
resultFile = "C:\IOT Gateway\result.log"
dateFile = "C:\IOT Gateway\date.log"
cardFile = "C:\IOT Gateway\card.log"
pathConfig = "C:\IOT Gateway\path.config"
runFile = "C:\IOT Gateway\run1.log"

' ตรวจสอบว่าไฟล์ result.log, date.log, card.log มีอยู่หรือไม่
If Not (fso.FileExists(resultFile) And fso.FileExists(dateFile) And fso.FileExists(cardFile) And fso.FileExists(pathConfig)) Then
    WScript.Quit
End If

' อ่านข้อมูลจาก result.log
Set file = fso.OpenTextFile(resultFile, 1)
If Not file.AtEndOfStream Then
    resultData = Trim(file.ReadAll)
Else
    resultData = ""
End If
file.Close

' อ่านข้อมูลจาก date.log
Set file = fso.OpenTextFile(dateFile, 1)
If Not file.AtEndOfStream Then
    dateData = Trim(file.ReadAll)
Else
    dateData = ""
End If
file.Close

' อ่านข้อมูลจาก card.log
Set file = fso.OpenTextFile(cardFile, 1)
If Not file.AtEndOfStream Then
    cardData = Trim(file.ReadAll)
Else
    cardData = ""
End If
file.Close

' ถ้า result.log, date.log, card.log ไม่ว่าง ให้ปิดโปรแกรม
If resultData <> "" Or dateData = "" Or cardData = "" Then
    WScript.Quit
End If

' อ่านพาธไฟล์ log จาก path.config
Set configFile = fso.OpenTextFile(pathConfig, 1)
If Not configFile.AtEndOfStream Then
    filePath = Trim(configFile.ReadAll)
Else
    filePath = ""
End If
configFile.Close

' ตรวจสอบว่าไฟล์ log เป้าหมายมีอยู่หรือไม่
If filePath = "" Or Not fso.FileExists(filePath) Then
    WScript.Quit
End If

' อ่านข้อมูลจากไฟล์ log เป้าหมาย
Set file = fso.OpenTextFile(filePath, 1)
logData = ""

Do Until file.AtEndOfStream
    line = file.ReadLine
    If InStr(line, dateData) > 0 And InStr(line, cardData) > 0 And (InStr(line, "Visio Result:") > 0 Or InStr(line, "Visio Result -") > 0 Or InStr(line, "END CardReading")) Then
        logData = logData & " " & line
        If InStr(line, "END CardReading") > 0 Then
            logData = logData & vbCrLf
        End If
    End If
Loop
file.Close

' เขียนข้อมูลลงใน run1.log
If logData <> "" Then
    Set file = fso.OpenTextFile(runFile, 2, True)
    file.Write logData
    file.Close
End If

' ปิดการทำงานของสคริปต์
WScript.Quit
