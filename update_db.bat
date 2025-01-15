REM Check if the variable is set
if "%MARTES_REMOTE_HOME%"=="" (
    echo MARTES_REMOTE_HOME är inte satt. Kontrollera .env-filen.
    pause
    exit /b
)

REM Debug: Print the value of MARTES_REMOTE_HOME
echo MARTES_REMOTE_HOME is set to: %MARTES_REMOTE_HOME%

REM Get the current directory in Windows format
for /f "delims=" %%i in ('wsl wslpath -w "$(pwd)"') do set CURRENT_PATH=%%i

REM Move up one directory
set PARENT_PATH=%~dp0..
cd %PARENT_PATH%
set PARENT_PATH=%cd%\msaccess

REM Debug: Print the value of PARENT_PATH
echo Access database path is set to: %PARENT_PATH%

REM Run the import script
wsl sh "%MARTES_REMOTE_HOME%/update_db.sh" "%PARENT_PATH%"

pause