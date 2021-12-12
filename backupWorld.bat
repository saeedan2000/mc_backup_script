@echo off
:: This script either makes a fresh backup of a minecraft world or restores it to the most recent backup
:: If the first command argument is "backup" it backs up the world. If it is "restore" it restores it.
:: If it is neither, it prints an error message and terminates. The second command line argument is the
:: world name to back up or restore.

:: check for too many or too few arguments
if not -%3-==-- goto :BADARGS
if -%2-==-- goto :BADARGS

:: set path to the .minecraft saves folder which contains all the worlds
set saves_path=C:\Users\Saeed\AppData\Roaming\.minecraft\saves\
:: set path to the onedrive folder containing world backups
set back_path=C:\Users\Saeed\OneDrive\Documents\mc_world_backup\

:: check for worldname in command line arguments, and set world_name variable
if not -%2-==-- set world_name=%2

:: set default worldname if we didn't get a name as a command line argument
if -%2-==-- set world_name=%def_world%

:: set name of backup directory
set back_name=%world_name%_backup

:: here we check the first command line argument (should be save/restore)
if %1==restore goto :RESTORE
if %1==backup goto :BACKUP
goto :BADARGS

:BACKUP
:: check that this world does exist
if not exist %saves_path%%world_name% goto :WORLDDNE
echo Backing up world %world_name%
:: check if a backup already exists and delete it if so
echo deleting any existing backups for world %world_name%...
if exist %back_path%%back_name% rd /S/Q %back_path%%back_name%
:: wait for deletion
timeout /T 3 /NOBREAK
echo finished deleting existing backups.

:: make a directory to hold the world backup on onedrive
md %back_path%%back_name%

:: copy the world to onedrive
Xcopy /E/H/K %saves_path%%world_name% %back_path%%back_name%

:: we are done
goto SUCCESS

:RESTORE
:: check that this world does exist
if not exist %back_path%%back_name% goto :WORLDDNE
echo Restoring world %world_name%
echo deleting any existing save of world %world_name%
if exist %saves_path%%world_name% rd /S/Q %saves_path%%world_name%
:: wait for deletion
timeout /T 3 /NOBREAK
echo finished deleting existing saves.

:: make a directory to hold the new save
md %saves_path%%world_name%

:: copy the backup to saves
Xcopy /E/H/K %back_path%%back_name% %saves_path%%world_name%

:: we are done
goto SUCCESS

:WORLDDNE
if %1==restore echo World "%world_name%" does not exist in backups, failed to restore.
if %1==backup echo World "%world_name%" does not exist in saves, failed to backup.
goto :EOF

:BADARGS
echo Incorrect command line arguments. Expected usage below.
echo Usage: backupWorld ^<action^> ^<worldname^>
echo The action argument can be either "restore" (replace the world with the most recent backup), or "backup"
echo (make a backup for this world)
goto :EOF

:SUCCESS
echo Finished %1 of world %world_name%
:: Done!
