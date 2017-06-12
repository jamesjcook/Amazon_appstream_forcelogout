@echo off
TITLE is_running
@REM echo Checking %1
tasklist /FI "IMAGENAME eq %1" 2>NUL | find /I /N "%1">NUL
if "%ERRORLEVEL%"=="0" ( echo YES ) else ( echo NO )

@REM tasklist /FI "windowtitle eq %1" 2>NUL | find /I /N "%1">NUL
@REM if "%ERRORLEVEL%"=="0" ( echo YES ) else ( echo NO )
exit /b
