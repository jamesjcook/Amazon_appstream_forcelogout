@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL EnableDelayedExpansion

@REM echo find task %taskname%
TITLE session_cleanup
set reg_dir=%USERPROFILE%\appreg
set program=%1
set interval=1

set PATH=%PATH%;%~dp0
if not exist %reg_dir% (
    mkdir %reg_dir%
)
echo SessionCleanup start with %program%
@REM schtasks /create /tn "Some task name" /tr "app.exe" /sc HOURLY 
set is_sched=NO
if NOT %program%==NOPROGRAM ( 
    @REM echo app_tattler schedule setup
    @REM check if scheduler exists for program
    @REM Run the app_tattler once to initalize things
    
    call %~dp0\app_tattler %program% %reg_dir%
    echo Check anything is running
    FOR /F "usebackq tokens=*" %%i IN (`%~dp0\is_scheduled.bat %program%_check`) DO (
        set is_sched=%%i
    )
    echo session_cleanup sched stat "!is_sched!"
    @REM This was stuck on never being found. 
    @REM The issue was a space returned to the var unexpectidly 
    if !is_sched!==YES ( 
        echo %program% appcheck schedule found 
    ) else (
        schtasks /create /sc MINUTE /tn %program%_check /tr  "%~dp0\bg_task.vbs %~dp0\app_tattler %program% %reg_dir%"
    )
)
set is_sched=NO
@REM echo Check anything is running
FOR /F "usebackq tokens=*" %%i IN (`dir_count %reg_dir%`) DO (
    set dirCount=%%i
)
@REM Check if we're already scheduled. 
@REM If we arnt, and things were running then schedule us.
FOR /F "usebackq tokens=*" %%i IN (`%~dp0\is_scheduled.bat session_cleanup_check`) DO (
    set is_sched=%%i
)
echo session_cleanup sched stat "!is_sched!"
if !is_sched!==YES (
    echo found schedule
    goto CHECK
) else ( 
    if %dirCount% GTR 0 (
        schtasks /create /sc MINUTE /tn session_cleanup_check /tr "%~dp0\bg_task.vbs %~dp0\session_cleanup NOPROGRAM"
        @REM start /B /MIN /BELOWNORMAL %~dp0\app_tattler %program% %reg_dir% %interval%
        goto END
    )
) 

:CHECK
if %dirCount% EQU 0 (
    @REM trigger logout here
    echo Logging Off
    schtasks /F /delete /tn session_cleanup_check > NUL 2>&1
    shutdown -l
) else (
    echo SessionProgramsStillActive 
)

:END
if exist %USERPROFILE%\is_sched.txt ( del %USERPROFILE%\is_sched.txt ) 
start /min /belownormal sleep_ping 5 & exit /B 

ENDLOCAL