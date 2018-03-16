@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL EnableDelayedExpansion

for /f "tokens=* USEBACKQ" %%f in (`c:\IP\SessionContextRetriever.exe`) do (
set var=%%f
)

IF [%var%] == [] (
  echo "Session var was empty! Launching notepad and cmd and git-bash to poke around!"
  start notepad
  start cmd
  start C:\IP_setup\Git\git-bash.exe --cd-to-home
  pause
) else (
  echo %var% >> c:\IP\AppStreamLaunchLog.txt
  echo %var% > c:\IP\AppStreamLaunch.txt
  start /wait %var%
)
exit \b
