@echo off
set FleetName=IB201706
set StackName=IB201706
set UserId=218
var_line_parser ..\ask.txt
bg_task.vbs powershell -noprofile -executionpolicy bypass "& %script% -FleetName %FleetName% -StackName %StackName% -UserId %UserId% -AccessKey %AccessKey% -SecretKey %SecretKey%"
echo call sleep 1
date /t
call sleep_ping.bat 60 
bg_task.vbs powershell -noprofile -executionpolicy bypass "& %script% -FleetName %FleetName% -StackName %StackName% -UserId %UserId% -AccessKey %AccessKey% -SecretKey %SecretKey%"
echo call sleep 2
date /t
call sleep_ping.bat 60 
bg_task.vbs powershell -noprofile -executionpolicy bypass "& %script% -FleetName %FleetName% -StackName %StackName% -UserId %UserId% -AccessKey %AccessKey% -SecretKey %SecretKey%"
echo call sleep 3
date /t
call sleep_ping.bat 60 
bg_task.vbs powershell -noprofile -executionpolicy bypass "& %script% -FleetName %FleetName% -StackName %StackName% -UserId %UserId% -AccessKey %AccessKey% -SecretKey %SecretKey%"
echo call sleep 4
date /t
call sleep_ping.bat 60 
bg_task.vbs powershell -noprofile -executionpolicy bypass "& %script% -FleetName %FleetName% -StackName %StackName% -UserId %UserId% -AccessKey %AccessKey% -SecretKey %SecretKey%"
echo call sleep 5
date /t
call sleep_ping.bat 60 
bg_task.vbs powershell -noprofile -executionpolicy bypass "& %script% -FleetName %FleetName% -StackName %StackName% -UserId %UserId% -AccessKey %AccessKey% -SecretKey %SecretKey%"
echo call sleep 6
date /t
call sleep_ping.bat 60 
