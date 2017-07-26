@REM @echo off
@set FleetName=IB201706 
@set StackName=IB201706 
@set UserId=218
set script=c:\CIVM_Apps\Amazon_appstream_forcelogout\ReportIdleTime.ps1
call var_line_parser ..\ask.txt
@REM start_type can be a empty space, call , or bg_task.vbs They all seem to work.
@REM bg_task wont show any output.
@REM call is not necessary
@REM set "start_type=bg_task.vbs" 
@REM set "start_type=call"
set "start_type= "
set "delay=10"
%start_type% powershell -noprofile -executionpolicy bypass "& %script% -FleetName %FleetName% -StackName %StackName% -UserId %UserId% -AccessKey %AccessKey% -SecretKey %SecretKey%"
@echo call sleep 1
date /t
call sleep_ping.bat %delay% 
%start_type% powershell -noprofile -executionpolicy bypass "& %script% -FleetName %FleetName% -StackName %StackName% -UserId %UserId% -AccessKey %AccessKey% -SecretKey %SecretKey%"
echo call sleep 2
date /t
call sleep_ping.bat %delay% 
%start_type% powershell -noprofile -executionpolicy bypass "& %script% -FleetName %FleetName% -StackName %StackName% -UserId %UserId% -AccessKey %AccessKey% -SecretKey %SecretKey%"
echo call sleep 3
date /t
call sleep_ping.bat %delay% 
%start_type% powershell -noprofile -executionpolicy bypass "& %script% -FleetName %FleetName% -StackName %StackName% -UserId %UserId% -AccessKey %AccessKey% -SecretKey %SecretKey%"
echo call sleep 4
date /t
call sleep_ping.bat %delay% 
%start_type% powershell -noprofile -executionpolicy bypass "& %script% -FleetName %FleetName% -StackName %StackName% -UserId %UserId% -AccessKey %AccessKey% -SecretKey %SecretKey%"
echo call sleep 5
date /t
call sleep_ping.bat %delay% 
%start_type% powershell -noprofile -executionpolicy bypass "& %script% -FleetName %FleetName% -StackName %StackName% -UserId %UserId% -AccessKey %AccessKey% -SecretKey %SecretKey%"
echo call sleep 6
date /t
call sleep_ping.bat %delay% 
