Option Explicit

' ฟังก์ชันในการอ่านข้อมูลจากไฟล์
Function ReadFile(filePath)
    Dim objFSO, objFile, strContent
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    
    If objFSO.FileExists(filePath) Then
        Set objFile = objFSO.OpenTextFile(filePath, 1) ' อ่านไฟล์ในโหมด Read (1)
        
        ' ตรวจสอบว่าไฟล์มีข้อมูลหรือไม่
        If Not objFile.AtEndOfStream Then
            strContent = objFile.ReadAll
        Else
            strContent = "" ' กำหนดค่าว่างหากไฟล์ว่างเปล่า
        End If
        
        objFile.Close
    Else
        strContent = ""
    End If
    
    ReadFile = Trim(strContent)
    Set objFSO = Nothing
    Set objFile = Nothing
End Function

' ฟังก์ชันในการล้างเนื้อหาของไฟล์
Sub ClearFiles(filePaths)
    Dim objFSO, i
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    
    For i = 0 To UBound(filePaths)
        If objFSO.FileExists(filePaths(i)) Then
            objFSO.CreateTextFile(filePaths(i), True).Close ' ลบเนื้อหาของไฟล์
        End If
    Next
    
    Set objFSO = Nothing
End Sub

' อ่านข้อมูลจากไฟล์ต่างๆ และตรวจสอบว่าไฟล์มีข้อมูลหรือไม่
Dim date, time, result, machine, dispense

date = ReadFile("C:\IOT Gateway\err_date.log")
If Len(date) = 0 Then
    WScript.Quit
End If

time = ReadFile("C:\IOT Gateway\err_time.log")
If Len(time) = 0 Then
    WScript.Quit
End If

result = ReadFile("C:\IOT Gateway\err_result.log")
If Len(result) = 0 Then
    WScript.Quit
End If

machine = ReadFile("C:\IOT Gateway\machine.config")
If Len(machine) = 0 Then
    WScript.Quit
End If

dispense = ReadFile("C:\IOT Gateway\case0.config")
If Len(dispense) = 0 Then
    WScript.Quit
End If

' ลบบรรทัดใหม่หรือ Tab ออกจากข้อมูลที่อ่านมา
date = Replace(date, vbCrLf, " ")
time = Replace(time, vbCrLf, " ")
result = Replace(result, vbCrLf, " ")
machine = Replace(machine, vbCrLf, " ")
dispense = Replace(dispense, vbCrLf, " ")

' จัดเรียงข้อมูลและบันทึกลงในไฟล์ final_inspected.log
Dim finalData, objFSO, objFile
finalData = date & ", " & time & ", N/A, N/A, " & result & ", Error, " & machine & ", N/A, " & dispense

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile("C:\IOT Gateway\final_inspected.log", 8, True) ' เปิดไฟล์ในโหมด Append (8)
objFile.Write finalData & vbCrLf ' เพิ่ม vbCrLf ที่ท้ายเพื่อให้บันทึกข้อมูลในบรรทัดใหม่
objFile.Close
Set objFSO = Nothing
Set objFile = Nothing

' ล้างไฟล์ที่กำหนด
Dim filePaths
filePaths = Array("C:\IOT Gateway\err_date.log", "C:\IOT Gateway\err_time.log", _
                  "C:\IOT Gateway\err_result.log", "C:\IOT Gateway\err2.log")

ClearFiles filePaths

' ปิดโปรแกรม
WScript.Quit
