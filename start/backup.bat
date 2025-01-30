@echo off
setlocal enabledelayedexpansion

REM ===========================
REM Load Environment Variables from .env File
REM ===========================

set "ENV_FILE=%~dp0..\env"

REM Read .env file and extract variables
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    if "%%a"=="MARTES_REMOTE_HOME" set "MARTES_REMOTE_HOME=%%b"
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)

REM Check if the variables were set
if "%MARTES_REMOTE_HOME%"=="" (
    echo ERROR: MARTES_REMOTE_HOME is not set. Check the .env file.
    pause
    exit /b 1
)

if "%DISTRO_NAME%"=="" (
    echo ERROR: DISTRO_NAME is not set. Check the .env file.
    pause
    exit /b 1
)

REM ===========================
REM Debug Output After Loading Variables
REM ===========================
echo MARTES_REMOTE_HOME is set to: %MARTES_REMOTE_HOME%
echo DISTRO_NAME is set to: %DISTRO_NAME%

echo Running backup.sh inside WSL distribution "%DISTRO_NAME%"...

REM ===========================
REM Get the Current and Parent Paths
REM ===========================

REM Get the current directory in Windows format
for /f "delims=" %%i in ('cd') do set "CURRENT_PATH=%%i"

REM Convert the current directory to WSL format
for /f "delims=" %%i in ('wsl wslpath "%CURRENT_PATH%"') do set "WSL_CURRENT_PATH=%%i"

REM Determine the parent path correctly
set "PARENT_PATH=%~dp0\.."
cd /d "%PARENT_PATH%"
set "PARENT_PATH=%cd%"

REM Debug: Print the value of PARENT_PATH
echo PARENT_PATH is set to: %PARENT_PATH%

REM ===========================
REM Run the Backup Script in WSL
REM ===========================

wsl -d "%DISTRO_NAME%" bash -c "sh '%MARTES_REMOTE_HOME%/backup.sh' '%PARENT_PATH%'"

REM Check if the command was successful
if %errorlevel% neq 0 (
    echo ERROR: Failed to execute backup.sh in "%DISTRO_NAME%".
    pause
    exit /b 1
)

echo backup.sh executed successfully in "%DISTRO_NAME%".
pause
exit /b
