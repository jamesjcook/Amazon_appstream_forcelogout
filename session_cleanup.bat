@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL EnableDelayedExpansion

@REM echo find task %taskname%
TITLE session_cleanup
set reg_dir=%USERPROFILE%\appreg
set program=%1
set delay=%2
set var_file=c:\CIVM_apps\session_vars.txt
if [%2]==[] set delay=0
@REM if [%3]==[] set var_txt=NONE
call sleep_ping %delay%

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
    FOR /F "usebackq tokens=*" %%i IN (`call %~dp0\is_scheduled.bat %program%_check`) DO (
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
    @REM Check for session max length timer
    FOR /F "usebackq tokens=*" %%i IN (`call %~dp0\is_scheduled.bat session_cleanup_maxtime`) DO (
        set is_sched=%%i
    )
    if !is_sched!==YES ( 
        echo Max timeout scheduled, removing before recreation
        schtasks /F /delete /tn session_cleanup_maxtime > NUL 2>&1
    )
    @REM :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    @REM WARNING: THIS IS WHERE WE SCHEUDLE HARD SESSION LIMIT OF 120 MINUTES
    @REM :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    @REM ---- THESE lines use future_time.bat which I have decided I dont need.
    @REM FOR /F "usebackq tokens=*" %%i IN (`%~dp0\future_time.bat 120`) DO (	
    @REM     set NEWTIME=%%i    
    @REM )
    @REM echo Will logout at !NEWTIME!
    @REM schtasks /create /ST !NEWTIME! /SC DAILY /tn session_cleanup_maxtime /tr "shutdown -l" 
    @REM  Could add auto remove task with /Z  but it requires  /ED   enddate in dd/mm/yyyy
    @REM ---- Switched to two part game using onevent and delay. 
    @REM   We schedule task to run after event, then we trigger straight away.
    @REM Removing this as there is an appstream max time feature, which has now been turned on for our fleets.
    @REM schtasks /create  /SC onevent /EC System /MO *[System/EventID=1000] /DELAY 0120:00 /tn session_cleanup_maxtime /tr "shutdown -s"  
    @REM example: eventcreate  /Id eventid  /D eventDescription /T eventType /L eventLogfileName
    @REM Tried to be cool and use id 6009, which co-insides with usere initiated shutdown, but schtasks only responts to 1-1000
    @REM eventcreate  /Id 1000  /D "Maximum appstream session length without a new program start count." /T information /L system
)

set is_sched=NO
@REM echo Check anything is running
FOR /F "usebackq tokens=*" %%i IN (`dir_count %reg_dir%`) DO (
    set dirCount=%%i
)
@REM Check if we're already scheduled. 
@REM If we arnt, and things were running then schedule us.
FOR /F "usebackq tokens=*" %%i IN (`call %~dp0\is_scheduled.bat session_cleanup_check`) DO (
    set is_sched=%%i
)

echo session_cleanup sched stat "!is_sched!"
if !is_sched!==YES (
    echo found schedule
    goto CHECK
) else (
@REM Not scheduled yet,  
    if %dirCount% GTR 0 (
    @REM and there are registered programs. so schedule us.
        schtasks /create /sc MINUTE /tn session_cleanup_check /tr "%~dp0\bg_task.vbs %~dp0\session_cleanup NOPROGRAM"
        @REM start /B /MIN /BELOWNORMAL %~dp0\app_tattler %program% %reg_dir% %interval%
    ) else (
	    echo Program not running, not scheduling
    )
    @REM Schedule idle logout Set terribly low(1 min) due to windows idle detect being so slow.
    @REM Disabled the idle shutdown in prep for using the cloudwach 
    @REM schtasks /create /sc ONIDLE /tn session_cleanup_idle /tr "shutdown -s" /i 5
    goto END
) 


:CHECK
@REM var_line_parser will put the session vars in the environment each time its run.
%~dp0\var_line_parser.bat %~dp0\..\ask.txt
%~dp0\var_line_parser.bat %var_file%
set script=%~dp0\ReportIdleTime.ps1
Powershell -NoProfile -ExecutionPolicy Bypass -Command "& %script% -FleetName %FleetName% -StackName %StackName% -UserId %UserId% -AccessKey %AccessKey% -SecretKey %SecretKey%"

if %dirCount% EQU 0 (
    @REM trigger logout here
    echo Logging Off
    schtasks /F /delete /tn session_cleanup_idle > NUL 2>&1
    schtasks /F /delete /tn session_cleanup_check > NUL 2>&1
    @REM schtasks /F /delete /tn session_cleanup_maxtime > NUL 2>&1
    shutdown -s
) else (
    echo SessionProgramsStillActive 
)

:END
@REM start /min /belownormal sleep_ping 5 & exit /B 
exit 
ENDLOCAL