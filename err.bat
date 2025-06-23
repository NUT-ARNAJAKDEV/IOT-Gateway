@echo off
:check_log
for /f %%A in (err1.log) do set LOG_CONTENT=%%A

if defined LOG_CONTENT (
    echo "err1.log has data, running the script .vbs"
    start "" /b wscript.exe err_prepare.vbs
    timeout /t 2 /nobreak > nul
    start "" /b wscript.exe err_date.vbs
    timeout /t 2 /nobreak > nul
    start "" /b wscript.exe err_time.vbs
    timeout /t 2 /nobreak > nul
    start "" /b wscript.exe err_result.vbs
    timeout /t 2 /nobreak > nul
    start "" /b wscript.exe err_final_inspected.vbs
    timeout /t 5 /nobreak > nul
    goto check_log
) else (
    timeout /t 10
    goto check_log
)