@echo on
@SETLOCAL ENABLEEXTENSIONS
@SETLOCAL EnableDelayedExpansion

@call timestamp >> c:\IP\sesh.txt
@c:\IP\SessionContextRetriever.exe >> c:\IP\sesh.txt

@echo off
@REM added quotes around var set to better protect it, however that may not be our problem at all!
@REM Could have been that we accidentially had code in our launch params and WE NEED IT TO BE EMPTY.
for /f "tokens=* USEBACKQ" %%f in (`c:\IP\SessionContextRetriever.exe`) do (
set "var=%%f"
)
%var%

timeout 4
if not exist c:\IP\session_vars.txt (
  echo SESSION_RETRIEVE_FAILURE!!!! ENTERING DEBUG!
  start cmd & start notepad & start explorer 
) else (
  echo session startup
  type c:\IP\session_vars.txt
)

timeout 2
exit \b
