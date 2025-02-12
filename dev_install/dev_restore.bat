@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env"

rem Read DISTRO_NAME from .env file
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    if "%%a"=="DISTRO_DEFAULT_NAME" set "DISTRO_NAME=%%b"
)

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

rem Ensure the restore.sh script is in the correct WSL path
set RESTORE_PATH=%WSL_PARENT_PATH%/dev_install/dev_restore.sh

rem Define the correct path for the backup directory (assuming it's one level up)
set BACKUP_PATH=%WSL_PARENT_PATH%/backup

rem Debug: Print the value of BACKUP_PATH
echo BACKUP_PATH is set to: %BACKUP_PATH%

rem Run the restore script inside the WSL distribution
wsl -d %DISTRO_NAME% --exec bash -c "chmod +x '%RESTORE_PATH%' && '%RESTORE_PATH%' '%BACKUP_PATH%'"

pause
