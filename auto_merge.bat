@echo off
REM บรรทัดนี้ปิดการแสดงคำสั่งทั้งหมดในขณะที่รันสคริปต์

title รันไฟล์ Python
echo Running Python file...

REM ตรวจสอบว่า Python ติดตั้งอยู่หรือไม่
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python is not found on the system. Please install Python first.
    pause
    exit /b
)

REM รันไฟล์ Python (เปลี่ยนชื่อไฟล์ตามต้องการ)
python auto_merge.py

REM แสดงข้อความเมื่อรันเสร็จ
echo Finished running the Python file.
pause