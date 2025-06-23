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

' รายการไฟล์ที่ต้องการล้าง
Dim filesToClear
filesToClear = Array("C:\IOT Gateway\date.log", "C:\IOT Gateway\time.log", "C:\IOT Gateway\sample.log", "C:\IOT Gateway\technique.log", "C:\IOT Gateway\result.log", "C:\IOT Gateway\card.log", "C:\IOT Gateway\run2.log")

' ล้างไฟล์ทั้งหมด
ClearFiles filesToClear

' ปิดโปรแกรม
WScript.Quit