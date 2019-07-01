@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL EnableDelayedExpansion
@REM AtlasViewerLaunch.bat
@REM close existing sessions

echo Closing existing atlasviewerapp-real
taskkill /f /im AtlasViewerApp-real.exe > NUL 2>&1

echo Setting up session cleanup for atlasviewer.exe
start %~dp0\session_cleanup.bat atlasviewer.exe 8
move /Y %APPDATA%\CIVM\AtlasViewer.ini %APPDATA%\CIVM\AtlasViewer.bak
call %~dp0\utils\find_and_replace %APPDATA%\CIVM\AtlasViewer.bak USERNAME %USERNAME% %APPDATA%\CIVM\AtlasViewer.ini
del %APPDATA%\CIVM\AtlasViewer.bak
set filepath=%~p1
cd %filepath%
echo %* >> c:\IP\AtlasViewerLaunchLog.txt
echo %* > c:\IP\AtlasViewerLaunch.txt
start /wait %*
exit