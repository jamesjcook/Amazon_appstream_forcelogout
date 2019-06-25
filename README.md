# Amazon_appstream_forcelogut
Code to grease the wheels of appstream deployment.
Written in lowest common denominator language.(windows batch files, vbs and powershell)
Initially developed to force logout on program close in amazon appstream. Hopefully will soon be obsolete.

utility code moved to windows_batch_utils, those are app_tattler.bat, bg_task.vbs, dir_count.bat, fileparts.bat, is_running.bat is_scheduled.bat sleep_pint.bat, timestamp.bat, var_line_parser.bat
see external deff.

Dont forget to initalize 
  * git submodule update --init --recursive


AppStreamRunner.bat - Assuming you've downloaded the sessioncontextretriever.exe from aws. It will run the session context as a program. It has proven robust to any ludicrous string of windows cmd syntax you want to throw at it. We use it by passing a string of echo commands to set up a minimal start script for our application. We also pass stack/fleet/user details and use echo to dump them to a file.


AppStreamRunner.bat is the only published application, it is configured with no arguments by default.


AtlasViewerLaunch.bat - Application specific session_cleanup run. Can be used as a template for your special purpose. Ours included only one running copy of a specific program, which must be open in the session. Theoritically this script is not needed and AppStreamRunner could do it all with session context. However with a char limit of 1024 on session context, it would be easy to overflow.

session_cleanup.bat  - the main, call this to set up the program watcher.
usage session_cleanup program.exe  eg, sesion_cleanup notepad.exe
the max time and the idle time shutdown events have been removed so they can be used from a more amazon friendly place. appstream max session time replaces the max time, and a cloudwatch alarm will replace the idle time. 

as_idlecheck.py - amazon cloudwatch python script. Granted from generious amazon engineer, lightly modified to make general. This is used in cloudwatch to read the UserIdleTime reported from ReportIdleTime.ps1 in the appstream session. Its included here to keep the different parts together. 


ReportIdleTime.ps1 - Generously provided by amazon engineers, this will publish the current idle time to cloud watch. Their version published on interval, it has been converted to publish just once, and windows scheduler is used to run it again every minute.

Overview of operation,use session_cleanup program.exe to get things operational. 

It has two run modes, setup and check. 
Setup will use app_tattler and is_scheduled to see if program.exe is running and set up the app_tattler schedule. 
In both check and setup mode it verifies it is scheduled to run.
If is scheduled to run it will enter check mode. 
In check mode it verifies at least one program is in the checking_directory. If it is it does nothing, otherwise it logs out.

Important details
---
These scripts use simple variable files to get information about the apsptream environment. The format is a single line ending with ENDECHO. Any other lines are ignored.
That line contains varname=value pairs separated by spaces. 
There are two specific files used by these scripts, one named ask.txt needs to exist with your amazon push key for cloud watch. The access on this key must be absolutely minimal becuase there is a hig chance it will be exposed. The keys will have to exist while your program is running. Ours were just baked into the appstream image.  It must contain AccessKey=THETHING SecretKey=SOMETHING ENDECHO.
The other file these scripts use is session_vars.txt. It's location is hardcoded to c:\\ip\\session_vars.txt. Use echo commands passed in the full session context to AppStreamRunner.bat to populate that file. It needs StackName=yourstackname FleetName=yourfleetname UserId=theuserforthesession ENDECHO
