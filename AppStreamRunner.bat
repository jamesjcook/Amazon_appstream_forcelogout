@echo on
@SETLOCAL ENABLEEXTENSIONS
@SETLOCAL EnableDelayedExpansion

@set PATH=%PATH%;%~dp0
@set sesh_run=c:\ip\sesh.bat

@REM dump sessioncontext to a test file plainly first
@REM we'll test that file for empty later.
@c:\IP\SessionContextRetriever.exe >> %sesh_run%test
echo @SETLOCAL ENABLEEXTENSIONS > %sesh_run%
echo @SETLOCAL EnableDelayedExpansion >> %sesh_run%
@c:\IP\SessionContextRetriever.exe >> %sesh_run%

@echo off
(
    for /f usebackq^ eol^= %%a in (
        %sesh_run%test
        ) do break
) && (
    start /wait %sesh_run%
) || (
    echo session context failure & start cmd & start notepad & start explorer
)
exit /b
