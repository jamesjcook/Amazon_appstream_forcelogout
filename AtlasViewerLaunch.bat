@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL EnableDelayedExpansion
@REM AtlasViewerLaunch.bat
@REM close existing sessions

echo Closing existing atlasviewerapp-real
taskkill /f /im AtlasViewerApp-real.exe > NUL 2>&1

echo Setting up session cleanup for atlasviewer.exe
start %~dp0\session_cleanup.bat atlasviewer.exe 8

set filepath=%~p1
cd %filepath%
echo %* >> c:\CIVM_Apps\AtlasViewerLaunchLog.txt
echo %* > c:\CIVM_Apps\AtlasViewerLaunch.txt
start /wait %*
exit \b
