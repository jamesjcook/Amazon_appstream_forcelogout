# Amazon_appstream_forcelogut
Code to force logout on program close in amazon appstream. Hopefully will soon be obsolete.

session_cleanup.bat  - the main, call this to set up the program watcher.
usage session_cleanup program.exe  eg, sesion_cleanup notepad.exe
the max time and the idle time shutdown events have been removed so they can be used from a more amazon friendly place. appstream max session time replaces the max time, and a cloudwatch alarm will replace the idle time. 

app_tattler.bat - records if program is open or not. saves the time of last check to a file in a specified directory. 
usage app_tattler.bat program.exe checking_directory

bg_task.vbs -  it uses vbs to run some command line headless. Only tested with .bat files.
usage bg_task.vbs program arg1 arg2 arg3

dir_count.bat - echos the count of items in a specified directory.
is_scheduled.bat - echos yes or no if the specified taskname is scheduled in the root of scheduled tasks
is_running - echos yes or no if the specified program.exe is currently running.
timestamp.bat - echos current time accurate to the minute.
sleep_ping.bat - function to delay, accurate to seconds.

ReportIdleTime.ps1 - Generously provided by amazon engineers, this will publish the current idle time to cloud watch. Their version published on interval, it has been converted to publish just once, and windows shceduler is used to run it again every minute.

Overview of operation,use session_cleanup program.exe to get things operational. 

It has two run modes, setup and check. 
Setup will use app_tattler and is_scheduled to see if program.exe is running and set up the app_tattler schedule. 
In both check and setup mode it verifies it is scheduled to run.
If is scheduled to run it will enter check mode. 
In check mode it verifies at least one program is in the checking_directory. If it is it does nothing, otherwise it logs out.

