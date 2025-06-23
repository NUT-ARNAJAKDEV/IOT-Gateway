Option Explicit

Sub ProcessErrorLog()
    Dim inputFile, outputFile, fileSystem, inputFileObj, outputFileObj, tempFileObj, line, errorMessage
    inputFile = "C:\IOT Gateway\err2.log"
    outputFile = "C:\IOT Gateway\err_result.log"
    Dim tempFile
    tempFile = "C:\IOT Gateway\temp_err2.log"

    ' ตรวจสอบว่าไฟล์ inputFile มีอยู่หรือไม่
    Set fileSystem = CreateObject("Scripting.FileSystemObject")
    If Not fileSystem.FileExists(inputFile) Then
        
        Exit Sub
    End If
    
    ' เปิดไฟล์ inputFile สำหรับการอ่าน
    Set inputFileObj = fileSystem.OpenTextFile(inputFile, 1) ' 1 คือโหมดอ่าน
    
    ' เปิดไฟล์ outputFile สำหรับการเขียน (หรือเพิ่มข้อมูลถ้ามีอยู่แล้ว)
    Set outputFileObj = fileSystem.OpenTextFile(outputFile, 8, True) ' 8 คือโหมดเพิ่มข้อมูล

    ' สร้างไฟล์ชั่วคราวสำหรับเก็บข้อมูลที่ไม่ใช่ [ERROR]
    Set tempFileObj = fileSystem.CreateTextFile(tempFile, True) ' สร้างไฟล์ใหม่ในโหมดเขียน

    ' อ่านไฟล์บรรทัดละบรรทัด
    Do Until inputFileObj.AtEndOfStream
        line = inputFileObj.ReadLine
        If InStr(line, "[ERROR]") > 0 Then
            ' หากพบ [ERROR] ให้แยกข้อความหลัง [ERROR] และเขียนลงใน outputFile
            errorMessage = Trim(Mid(line, InStr(line, "[ERROR]") + 8))
            outputFileObj.WriteLine errorMessage
        Else
            ' หากไม่พบ [ERROR] ให้เขียนบรรทัดนั้นกลับเข้าไปใน tempFile
            tempFileObj.WriteLine line
        End If
    Loop

    ' ปิดไฟล์
    inputFileObj.Close
    outputFileObj.Close
    tempFileObj.Close

    ' ลบไฟล์ชั่วคราว (ไม่ลบไฟล์ต้นฉบับ)
    fileSystem.DeleteFile tempFile

End Sub

' เรียกใช้งานฟังก์ชัน
ProcessErrorLog()

' ปิดโปรแกรม
WScript.Quit