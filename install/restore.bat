@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env"

rem Read DISTRO_NAME from .env file
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
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

rem Run the restore script inside the WSL distribution
wsl -d %DISTRO_NAME% bash -c "sh /mnt/c/%WSL_PARENT_PATH%/restore.sh"

pause
