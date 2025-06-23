Sub ClearFiles(filepaths)
    Dim objFSO, filepath
    Set objFSO = CreateObject("Scripting.FileSystemObject")

    For Each filepath In filepaths
        If objFSO.FileExists(filepath) Then
            On Error Resume Next
            objFSO.OpenTextFile(filepath, 2, True).Close
            If Err.Number <> 0 Then
                Err.Clear
            End If
            On Error GoTo 0
        End If
    Next

    Set objFSO = Nothing
End Sub

' สร้างอ็อบเจ็กต์ FileSystemObject
Dim objFSO, resultFile, fileSize
Set objFSO = CreateObject("Scripting.FileSystemObject")

' ตรวจสอบว่า result.log มีอยู่หรือไม่
resultFile = "C:\IOT Gateway\result.log"
If objFSO.FileExists(resultFile) Then
    ' ตรวจสอบขนาดไฟล์ result.log
    fileSize = objFSO.GetFile(resultFile).Size
    If fileSize > 0 Then
        ' ถ้าไฟล์ไม่ว่างเปล่า ให้หยุดโปรแกรมและปิดตัวทันที
        WScript.Quit
    End If
End If

' รายการไฟล์ที่ต้องการล้าง (รวมถึง result.log)
Dim filesToClear
filesToClear = Array("C:\IOT Gateway\date.log", "C:\IOT Gateway\time.log", "C:\IOT Gateway\sample.log", "C:\IOT Gateway\technique.log", "C:\IOT Gateway\result.log", "C:\IOT Gateway\card.log", "C:\IOT Gateway\run2.log")

' ดำเนินการล้างไฟล์ทั้งหมด
ClearFiles filesToClear

' ปิดโปรแกรม
WScript.Quit
