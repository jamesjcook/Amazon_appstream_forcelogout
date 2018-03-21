@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL EnableDelayedExpansion

for /f "tokens=* USEBACKQ" %%f in (`c:\IP\SessionContextRetriever.exe`) do (
set var=%%f
)
%var%


if not exist c:\IP\session_vars.txt (
  echo ESSION_RETRIEVE_FAILURE!!!! ENTERING DEBUG!
  start cmd & start notepad & start explorer & start git-bash --cd-to-home
  timeout 2
) else (
  echo session startup
  type c:\IP\session_var.txt
  timout 2
)
exit \b
