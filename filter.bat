@echo off
:check_log
for /f %%A in (run1.log) do set LOG_CONTENT=%%A

if defined LOG_CONTENT (
    echo "run1.log has data, running the script .vbs"
    start "" /b wscript.exe selected.vbs
    timeout /t 2 /nobreak > nul
    start "" /b wscript.exe _date.vbs
    timeout /t 2 /nobreak > nul
    start "" /b wscript.exe _time.vbs
    timeout /t 2 /nobreak > nul
    start "" /b wscript.exe card.vbs
    timeout /t 2 /nobreak > nul
    start "" /b wscript.exe sample.vbs
    timeout /t 2 /nobreak > nul
    start "" /b wscript.exe result.vbs
    timeout /t 2 /nobreak > nul
    start "" /b wscript.exe technique.vbs
    timeout /t 2 /nobreak > nul
    start "" /b wscript.exe recheck.vbs
    timeout /t 10 /nobreak > nul
    start "" /b wscript.exe recheck_clear.vbs
    timeout /t 2 /nobreak > nul
    start "" /b wscript.exe final_inspected.vbs
    timeout /t 1 /nobreak > nul
    start "" /b wscript.exe clear.vbs
    timeout /t 10 /nobreak > nul
    goto check_log
) else (
    timeout /t 10
    goto check_log
)