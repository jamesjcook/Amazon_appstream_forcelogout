@echo off
setlocal
TITLE dir_count
set reg_dir=%1
cd %reg_dir%
attrib.exe /s ./* | find /v "File not found - " | find /c /v ""
endlocal
exit /b
