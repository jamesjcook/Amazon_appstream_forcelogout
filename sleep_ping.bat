@echo off
TITLE sleep_ping
set /a ns_p1=%1+1
@REM echo %time%
ping 127.0.0.1 -n %ns_p1% > nul
@REM echo %time%
exit /b
