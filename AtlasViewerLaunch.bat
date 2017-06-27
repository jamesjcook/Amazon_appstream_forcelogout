@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL EnableDelayedExpansion
@REM AtlasViewerLaunch.bat
@REM close existing sessions
taskkill /im AtlasViewerApp-real.exe > NUL 2>&1
start %~dp0\session_cleanup.bat atlasviewer.exe 8
set filepath=%~p1
cd %filepath%

start /wait %*
exit \b