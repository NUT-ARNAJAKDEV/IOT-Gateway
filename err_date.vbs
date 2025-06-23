Option Explicit

Dim inputFile, outputFile, objFSO, objFile, data, first10Chars
Dim otherScript

inputFile = "C:\IOT Gateway\err2.log"
outputFile = "C:\IOT Gateway\err_date.log"

Set objFSO = CreateObject("Scripting.FileSystemObject")

On Error Resume Next
If objFSO.FileExists(inputFile) Then
    Set objFile = objFSO.OpenTextFile(inputFile, 1, False)
    data = Trim(objFile.ReadAll) ' อ่านข้อมูลทั้งหมดและลบช่องว่าง
    objFile.Close
    Set objFile = Nothing

    If Len(data) > 0 Then
        first10Chars = Left(data, 10) ' ดึง 10 ตัวอักษรแรก

        ' เขียนข้อมูลลงในไฟล์ output
        Set objFile = objFSO.OpenTextFile(outputFile, 2, True)
        objFile.Write first10Chars
        objFile.Close
        Set objFile = Nothing
    Else
        ' ถ้าไม่มีข้อมูล
    End If
Else
    ' ถ้าไฟล์ไม่พบ
End If
On Error GoTo 0

Set objFSO = Nothing

' ปิดโปรแกรม
WScript.Quit