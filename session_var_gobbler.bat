@echo off
setlocal enableDelayedExpansion

set "the_file=%1"
@REM Example file contents
@REM # var_reset  
@REM  ApplicationId=AtlasViewerLaunch20170626 FleetName=InteractivePublishing_prod2 StackName=InteractivePublishing_prod2 Validity=45 UserId=218 LibraryItem=V17001 LibraryId=19  ENDECHO  

@REM read the file, looking for the keyline ending with "ENDECHO"
for /F "delims=" %%a in ('findstr /I "ENDECHO" %the_file') do set "varLine=%%a"
echo input is %varLine%

@REM ::::::::::::::::::::::::::::::::::::::::::
@REM Removes the endecho
set "tvarLine=%varLine: ENDECHO=%"

@REM ::::::::::::::::::::::::::::::::::::::::::
@REM From a great answer on stack overflow
@REM https://stackoverflow.com/a/12630844 
@REM modified slightly, our string separates each pair with spaces, so, 
@REM the inner for loop went from 
@REM ("!tvarLine:,=%%~A!") to ("!tvarLine: =%%~A!")

@REM Define a variable containing a LineFeed character
set LF=^


@REM The above 2 empty lines are critical - do not remove
@REM Parse and set the values
for %%A in ("!LF!") do (
  for /f "eol== tokens=1,2 delims==" %%B in ("!tvarLine: =%%~A!") do set "%%B=%%C"
)
