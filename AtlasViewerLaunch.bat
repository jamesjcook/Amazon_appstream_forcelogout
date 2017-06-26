@REM AtlasViewerLaunch.bat
@close existing sessions
taskkill /im AtlasViewerApp-real.exe
start %~dp0\session_cleanup.bat atlasviewer.exe 8
set file=%1
FOR %%i IN ("!file!") DO (
ECHO filedrive=%%~di
ECHO filepath=%%~pi
set filepath=%%~pi
ECHO filename=%%~ni
ECHO fileextension=%%~xi
)
cd %filepath%
timeout 3
call %*
exit 