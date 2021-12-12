@echo off
:: this batch file starts the minecraft launcher, waits for MC to terminate then asks whether to backup
:: and which world to backup.

:: default world to backup
set def_world=survival_world

start /wait "" "C:\Program Files (x86)\Minecraft\MinecraftLauncher.exe"
:: ask whether to backup the world
set /P input=Make a backup? (y/n, case sensitive) 

:CHECKINPUT
if %input%==y goto :ASKWORLD
if %input%==n goto :EOF
goto :BADARGS

:BADARGS
:: received input of neither n nor y
set /P input=Bad input, please enter "y" or "n": 
goto :CHECKINPUT

:ASKWORLD
set /P input=Enter name of world to backup or def for default (%def_world%): 
:CALLBW
if not %input%==def call backupWorld.bat backup %input%
if %input%==def call backupWorld.bat backup %def_world%