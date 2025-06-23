@echo off
:check_log
set "LOG_CONTENT="

for /f %%A in (final_inspected.log) do set LOG_CONTENT=%%A

:: ตรวจสอบว่ามีค่าหรือไม่
if defined LOG_CONTENT (
    
    goto process_go
) else (
    :: ตรวจสอบเพิ่มเติมว่าเป็นค่าว่างเปล่าจริง ๆ หรือไม่ (กรณีที่ set "" แล้วยัง defined อยู่)
    if "%LOG_CONTENT%"=="" (
        go run standby.go
        timeout /t 15 /nobreak > nul
        goto wait_and_retry
    ) else (
        
        goto wait_and_retry
    )
)

:process_go
go run move.go
timeout /t 4 /nobreak > nul
go run verify_rows.go
timeout /t 2 /nobreak > nul
go run update.go
timeout /t 4 /nobreak > nul
go run standby_write.go
timeout /t 4 /nobreak > nul
goto check_log

:wait_and_retry
timeout /t 45 > nul
goto check_log
