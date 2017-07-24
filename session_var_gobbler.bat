@echo off

set "the_file=%1"
set "the_folder=%~dp1"
@REM echo %the_folder%
@REM setlocal enableDelayedExpansion 
@REM Example file contents
@REM # var_reset  
@REM  ApplicationId=AtlasViewerLaunch20170626 FleetName=InteractivePublishing_prod2 StackName=InteractivePublishing_prod2 Validity=45 UserId=218 LibraryItem=V17001 LibraryId=19  ENDECHO  

@REM read the file, looking for the keyline ending with "ENDECHO"
for /F "delims=" %%a in ('findstr /I "ENDECHO" %the_file%') do set "varLine=%%a"
@REM echo input is %varLine%

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
(SET LF=^
%=this line is empty=%
)
@REM The above 2 empty lines are critical - do not remove
@REM Parse and set the values
for %%A in ("!LF!") do (
  for /f "eol== tokens=1,2 delims==" %%B in ("!tvarLine: =%%~A!") do ( 
    set "%%B=%%C"
	@REM the set here only sets the variables internally, to get them exported, have to endlocal and pass them along
	@REM All methods to pass them along failed, using a temp bat script to be called outside setlocal to fix that issue.
	@REM echo set "%%B=%%C" >> %the_folder%set_vars.bat
  )
)
@REM endlocal
@REM call %the_folder%set_vars.bat
@REM del %the_folder%set_vars.bat
@REM exit /b
@REM goto :EOF

echo in_s:%UserId%

set "UserId="
echo int_s:%UserId%
call :eol_lo %tvarLine%
echo in_2s:%UserId%

exit /b
goto :EOF

:total
echo in tot
echo arg 1 is "%1"
echo arg 2 is "%2"
echo arg all is "%*"
set "LF=%*"
@REM Parse and set the values
for %%A in ("!LF!") do (
  for /f "eol== tokens=1,2 delims==" %%B in ("!tvarLine: =%%~A!") do ( 
    set "%%B=%%C"
	)
)
exit /b
goto :EOF

:lf_lo
for %%A in ("!LF!") do (
  for /f "eol== tokens=1,2 delims==" %%B in ("!tvarLine: =%%~A!") do ( 
    set "%%B=%%C"
  )
)
exit /b
goto :EOF

:eol_lo
(SET LF=^
%=this line is empty=%
)
for /f "eol== tokens=1,2 delims==" %%B in ("%tvarLine: =%LF%%") do ( 
  REM set "%%B=%%C"
  echo el:%%B=%%C
)
exit /b
goto :EOF