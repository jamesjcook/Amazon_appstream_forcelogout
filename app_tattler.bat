@echo off
TITLE app_tattler
SETLOCAL ENABLEDELAYEDEXPANSION

set program=%1
set reg_dir=%2
set PATH=%PATH%;%~dp0

@REM echo Checking %program% will store found time stored in %reg_dir%
:CHECK
set appOn=OFF
@REM Alternate method to capture output of command based on temp files.
@REM application arg0 arg1 > temp.txt
@REM set /p VAR=<temp.txt

FOR /F "usebackq tokens=*" %%i IN (`is_running %program%`) DO (
    set appOn=%%i
)

@REM echo Watcher got status: %appOn%
if %appOn%==YES ( 
    call timestamp > %reg_dir%\%program%.txt
) else ( 
    @REM echo App not open 
    if exist %reg_dir%\%program%.txt ( 
        @REM echo "Remove %reg_dir%\%program%.txt" 
        del %reg_dir%\%program%.txt
    ) else (
        @REM echo strangely missing %reg_dir%\%program%.txt
    )
)
:exit
ENDLOCAL
exit /b