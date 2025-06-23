@echo off

REM Wait for 1 seconds
timeout /t 1 /nobreak > nul

REM ปิดทุกโปรเซสที่ใช้ wscript.exe (สำหรับ .vbs)
taskkill /IM wscript.exe /F

exit
