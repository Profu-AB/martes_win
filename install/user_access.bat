@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

REM ===========================
REM Configuration Variables
REM ===========================

REM Define the WSL distribution name
set "DISTRO_NAME=Ubuntu-22.04-Profu"

REM Define the setup script to run within WSL
set "SETUP_SCRIPT=user_access.sh"

REM Define the relative path to the 'start' directory
set "START_DIR=..\start"

REM ===========================
REM Helper Functions
REM ===========================

REM Function to display error messages and exit
:exit_with_error
echo ERROR: %~1
pause
exit /b 1

REM ===========================
REM Retrieve Current Directory Paths
REM ===========================

REM Retrieve the current directory in Windows format
set "WIN_PATH=%cd%"

REM Use wslpath to convert Windows path to WSL path
for /f "usebackq tokens=*" %%i in (`wsl wslpath "%WIN_PATH%"`) do set "WSL_PATH=%%i"

REM Optional: Echo the paths for debugging
echo Windows Path: %WIN_PATH%
echo WSL Path: %WSL_PATH%

REM ===========================
REM Retrieve the Current Windows Username
REM ===========================

set "WINDOWS_USER=%USERNAME%"
echo Current Windows User: %WINDOWS_USER%

REM ===========================
REM Execute the WSL Script with the Windows Username
REM ===========================

REM Check if the WSL distribution exists
wsl --list --quiet | findstr /i "%DISTRO_NAME%" >nul
if %errorlevel% neq 0 (
    call :exit_with_error "The WSL distribution '%DISTRO_NAME%' is not installed."
)

REM Execute user_access.sh within the specified WSL distribution, passing the Windows username
echo Executing '%SETUP_SCRIPT%' for user '%WINDOWS_USER%' in distribution '%DISTRO_NAME%'...
wsl -d "%DISTRO_NAME%" bash -c "cd '%WSL_PATH%' && ./user_access.sh '%WINDOWS_USER%'"
if %errorlevel% neq 0 (
    call :exit_with_error "Failed to execute '%SETUP_SCRIPT%' in '%DISTRO_NAME%'."
)

echo '%SETUP_SCRIPT%' executed successfully.

REM ===========================
REM Navigate to the 'start' Directory and Execute 'check.bat'
REM ===========================

echo Navigating to the 'start' directory and executing 'check.bat'...
cd "%START_DIR%"
if %errorlevel% neq 0 (
    call :exit_with_error "Failed to navigate to the 'start' directory."
)

REM Check if 'check.bat' exists before calling it
if exist "check.bat" (
    call check.bat
    if %errorlevel% neq 0 (
        call :exit_with_error "Failed to execute 'check.bat'."
    )
) else (
    echo Warning: 'check.bat' not found in the 'start' directory.
)

REM ===========================
REM Final Success Message
REM ===========================

echo.
echo Done, Martes should now be ready!
pause
exit /b
