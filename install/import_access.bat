@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env"

rem Read DISTRO_NAME and LICENSE from .env file
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
    if "%%a"=="LICENSE" set "LICENSE=%%b"
)

echo LICENSE=%LICENSE%

rem Get the current directory in Windows format
for /f "delims=" %%i in ('wsl wslpath -w "$(pwd)"') do set CURRENT_PATH=%%i

rem Move up one directory and get the parent path
set PARENT_PATH=%~dp0..
cd %PARENT_PATH%
set PARENT_PATH=%cd%

rem Debug: Print the value of PARENT_PATH
echo PARENT_PATH is set to: %PARENT_PATH%

rem Convert the parent path to a WSL-compatible path using wslpath
for /f "delims=" %%i in ('wsl wslpath "%PARENT_PATH%"') do set WSL_PARENT_PATH=%%i

rem Ensure the import_access.sh script is in the correct WSL path
set IMPORT_SCRIPT_PATH=%WSL_PARENT_PATH%/install/import_access.sh

rem Define the correct path for the backup directory (assuming it's one level up)
set BACKUP_PATH=%WSL_PARENT_PATH%/backup

rem Move up one directory
set PARENT_PATH=%~dp0..
cd %PARENT_PATH%
set PARENT_PATH=%cd%\msaccess

rem Debug: Print the value of PARENT_PATH
echo Access database path is set to: %PARENT_PATH%

rem Run the import_access.sh script inside the WSL distribution with LICENSE as a parameter
wsl -d %DISTRO_NAME% --exec bash -c "chmod +x '%IMPORT_SCRIPT_PATH%' && '%IMPORT_SCRIPT_PATH%' '%LICENSE%'"

pause
