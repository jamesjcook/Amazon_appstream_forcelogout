@echo off
SETLOCAL ENABLEEXTENSIONS
TITLE is_scheduled
set taskname=%1

schtasks /query /NH /TN %taskname% 2>&1 | find /c "ERROR" > %USERPROFILE%\schErr.txt
FOR /F "usebackq tokens=*" %%i IN (`type %USERPROFILE%\schErr.txt` ) do ( set schstat=%%i )

@REM MUST MAKE SURE THERE IS NO SPACE AFTER THE YES/NO
if 0 equ %schstat% ( 
    echo YES
) else ( 
    echo NO
)
ENDLOCAL
if exist %USERPROFILE%\schErr.txt ( del %USERPROFILE%\schErr.txt )
exit /b
