Function ReadFile(filepath)
    Dim objFSO, objFile, content
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    
    If objFSO.FileExists(filepath) Then
        If objFSO.GetFile(filepath).Size > 0 Then ' ตรวจสอบขนาดไฟล์
            Set objFile = objFSO.OpenTextFile(filepath, 1, False, -2) ' เปิดไฟล์แบบอ่านเท่านั้น (1), ใช้ Unicode (-2)
            content = Trim(objFile.ReadAll)
            objFile.Close
        Else
            content = "" ' ถ้าไฟล์ว่างเปล่า
        End If
    Else
        content = ""
    End If
    
    ReadFile = Replace(content, vbCrLf, " ") ' ลบการขึ้นบรรทัดใหม่ภายในเนื้อหา
    Set objFile = Nothing
    Set objFSO = Nothing
End Function

Function IsEmptyFile(filepath)
    Dim content
    content = ReadFile(filepath)
    If Len(content) = 0 Then
        IsEmptyFile = True
    Else
        IsEmptyFile = False
    End If
End Function

' สร้างฟังก์ชันที่ตรวจสอบไฟล์ทั้งหมด
Function CheckFilesEmpty(files)
    Dim file
    For Each file In files
        If Not IsEmptyFile(file) Then
            CheckFilesEmpty = False
            Exit Function
        End If
    Next
    CheckFilesEmpty = True ' ถ้าไฟล์ทั้งหมดเป็นค่าว่าง
End Function

' รายการไฟล์ที่ต้องการตรวจสอบและล้าง
Dim filesToCheck
filesToCheck = Array("C:\IOT Gateway\date.log", "C:\IOT Gateway\time.log", "C:\IOT Gateway\sample.log", "C:\IOT Gateway\technique.log", "C:\IOT Gateway\result.log", "C:\IOT Gateway\card.log", "C:\IOT Gateway\run2.log")

Dim keywords, description, dispense, dateVal, timeVal, sample, result, machine, card, finalData, objFSO, objFile

Set keywords = CreateObject("Scripting.Dictionary")
keywords.Add "ABO-Rh (2D)RT", "C:\IOT Gateway\case1.config"
keywords.Add "ABO-Rh (2D)", "C:\IOT Gateway\case2.config"
keywords.Add "3 Screen (AHG)", "C:\IOT Gateway\case3.config"
keywords.Add "Confirm", "C:\IOT Gateway\case4.config"
keywords.Add "Confirm P", "C:\IOT Gateway\case5.config"
keywords.Add "Auto-Control (AHG)", "C:\IOT Gateway\case6.config"
keywords.Add "Newborn (Group+DC)", "C:\IOT Gateway\case7.config"
keywords.Add "11 Ab ID (AHG)", "C:\IOT Gateway\case8.config"
keywords.Add "2 Screen (AHG)", "C:\IOT Gateway\case9.config"
keywords.Add "Reverse Group (A1-B)", "C:\IOT Gateway\case10.config"
keywords.Add "Rh Pheno", "C:\IOT Gateway\case11.config"
keywords.Add "Xmatch (AHG)", "C:\IOT Gateway\case12.config"
keywords.Add "Direct Coombs (AHG)", "C:\IOT Gateway\case13.config"

description = ReadFile("C:\IOT Gateway\technique.log")
dispense = ""

For Each keyword In keywords.Keys
    If InStr(description, keyword) > 0 Then
        dispense = ReadFile(keywords.Item(keyword))
        Exit For
    End If
Next

dateVal = ReadFile("C:\IOT Gateway\date.log")
timeVal = ReadFile("C:\IOT Gateway\time.log")
sample = ReadFile("C:\IOT Gateway\sample.log")
result = ReadFile("C:\IOT Gateway\result.log")
machine = ReadFile("C:\IOT Gateway\machine.config")
card = ReadFile("C:\IOT Gateway\card.log")

' ตรวจสอบว่าไฟล์ทั้งหมดเป็นค่าว่างหรือไม่
If Not CheckFilesEmpty(filesToCheck) Then
    ' ถ้ามีข้อมูลในไฟล์อย่างน้อยหนึ่งไฟล์ จะดำเนินการบันทึกข้อมูลลงใน final_inspected.log
    finalData = dateVal & ", " & timeVal & ", " & sample & ", " & description & ", " & result & ", Running, " & machine & ", " & card & ", " & dispense
    
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    Set objFile = objFSO.OpenTextFile("C:\IOT Gateway\final_inspected.log", 8, True, -2) ' เปิดไฟล์แบบ Append (8), ใช้ Unicode (-2)
    
    ' เพิ่มบรรทัดใหม่ก่อนเขียนข้อมูล
    objFile.Write vbCrLf ' เขียนตัวขึ้นบรรทัดใหม่ก่อน
    objFile.Write finalData ' เขียนข้อมูล
    
    objFile.Close
End If

Set objFile = Nothing
Set objFSO = Nothing
Set keywords = Nothing

' เพิ่มบรรทัดนี้เพื่อปิดโปรแกรม
WScript.Quit
