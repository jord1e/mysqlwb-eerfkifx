@echo off
TITLE MySQL Workbench EERFKIFx
SET wb_base=C:\Program Files\MySQL\MySQL Workbench 8.0 CE\
SET wb_path="%wb_base%images"
CLS
ECHO:
ECHO    .------------------------------------------.
ECHO    ^| MySQL Workbench EER Foreign Key Icon Fix ^|
ECHO    ^| Fix for MySQL Workbench bug #92141       ^|
ECHO    ^| github.com/jord1e/mysqlwb-eerfkifx       ^|
ECHO    '------------------------------------------'
ECHO:
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO Please run this script as administrator
    GOTO end
)
IF NOT EXIST "%wb_base%" (
    ECHO MySQL Workbench installation is not located at "%wb_base%", please change the script
    ECHO:
    GOTO end
)
ECHO Checking to see if MySQL Workbench is running
TASKLIST /FI "IMAGENAME eq MySQLWorkbench.exe" 2>NUL | FIND /I /N "MySQLWorkbench.exe" >NUL
IF %ERRORLEVEL% EQU 0 (
    ECHO MySQL Workbench is running, save your files and press enter ^(MySQL Workbench will then be closed^)
    PAUSE
    ECHO Attempting to kill
    TASKKILL /IM MySQLWorkbench.exe /F
    ECHO Waiting for 5 seconds ^(full shutdown^)
    PING -n 6 127.0.0.1>nul
) ELSE (
    ECHO MySQL Workbench is not running
)
ECHO:
ECHO Copying images folder from Workbench directory
XCOPY /E /I /Q /Y %wb_path% images
ECHO:
ECHO Patching folder (this may take some time)
ECHO:
CALL patch.bat images/ 1>NUL
IF %ERRORLEVEL% EQU 1 (
    ECHO:
    ECHO Error whilst processing images folder
    GOTO end
)

ECHO Finished patching folder; copying folder back to Workbench
XCOPY /E /I /Q /Y images %wb_path%
ECHO:
IF %ERRORLEVEL% EQU 1 (
    ECHO Couldn^'t move images folder back^, please do so manually
    explorer %wb_base%
    PAUSE
) ELSE (
    ECHO Removing local images folder
    RMDIR /S /Q images
    IF %ERRORLEVEL% EQU 1 (
        ECHO Error whilst deleting local images folder
    ) ELSE (
        ECHO Done.
    )
    ECHO:
    ECHO Finished, you can now start MySQL Workbench again
)

:end
TIMEOUT 30
