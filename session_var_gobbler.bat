@echo off
setlocal enableDelayedExpansion

set "the_file=%1"
@REM Example file contents
@REM # var_reset  
@REM  ApplicationId=AtlasViewerLaunch20170626 FleetName=InteractivePublishing_prod2 StackName=InteractivePublishing_prod2 Validity=45 UserId=218 LibraryItem=V17001 LibraryId=19  ENDECHO  

for /F "delims=" %%a in ('findstr /I "ENDECHO" %1') do set "varLine=%%a"
echo input is %varLine%
@REM ::::::::::::::::::::::::::::::::::::::::::
echo pass1
call :CLEARVAR
@REM for /F is line by line, but we only hav eone line, thats why this gets processed once.
set "tvarLine=%varLine: ENDECHO=%" @REM Removes the endecho
echo loop on %tvarLine%
for /F "tokens=1,2,3* delims== " %%a in ("%tvarLine%") do ( 
echo a:%%a
echo b:%%b
echo c:%%c
set %%a=%%b
set "%tvarLine%=%%c"
)

echo result
call :SHOWVAR
@REM ::::::::::::::::::::::::::::::::::::::::::
echo pass2
call :CLEARVAR
set "tvarLine=%varLine: ENDECHO=%" @REM Removes the endecho
set "tvarLine=%tvarline:  = %" @REM collapses double spacesin to single.
echo loop on %tvarLine%
for %%a in (%tvarLine:"="=,%) do ( 
echo t1=%%a
echo t2=%%b
)

@REM ::::::::::::::::::::::::::::::::::::::::::
echo pass3
call :CLEARVAR
@REm  "tokens=1,2 delims== "
set "repLine1=%varLine:\==,%"
echo repLine1=%repLine1%
set "repLine2=%repLine1: =,%"
echo repLine2=%repLine2%
for %%a in ("%repLine2%") do ( 
set "%%a=%%b"
)
call :SHOWVAR


@REM ::::::::::::::::::::::::::::::::::::::::::
echo pass4
call :CLEARVAR
@REM Define a variable containing a LineFeed character
set LF=^


@REM The above 2 empty lines are critical - do not remove
echo loop on %tvarLine%
@REM Parse and set the values
for %%A in ("!LF!") do (
  for /f "eol== tokens=1,2 delims==" %%B in ("!tvarLine: =%%~A!") do set "%%B=%%C"
)


call :SHOWVAR

@REM END OF MAIN END OF MAIN END OF MAIN END OF MAIN END OF MAIN END OF MAIN END OF MAIN 
goto :EOF

:SHOWVAR
echo a:%ApplicationId%
echo f:%FleetName%
echo s:%StackName%
echo v:%Validity%
echo u:%UserId%
echo i:%LibraryItem%
echo l:%LibraryId%
goto :EOF

:CLEARVAR
set "ApplicationId="
set "FleetName="
set "StackName="
set "Validity="
set "UserId="
set "LibraryItem="
set "LibraryId="
goto :EOF