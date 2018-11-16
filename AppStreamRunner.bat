@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL EnableDelayedExpansion

for /f "tokens=* USEBACKQ" %%f in (`c:\IP\SessionContextRetriever.exe`) do (
set var=%%f
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
