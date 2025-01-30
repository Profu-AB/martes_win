@echo off
setlocal enabledelayedexpansion

REM ===========================
REM Configuration Variables
REM ===========================

REM Define the distribution name
set "DISTRO_NAME=Ubuntu-22.04-Profu"

REM Define the Linux username to be created
set "USERNAME=martes"

REM Define the GitHub repository to clone
set "REPO_URL=https://github.com/mmagnemyr/martes_setup.git"

REM Define the setup script to run after cloning
set "SETUP_SCRIPT=setup_new.sh"

REM Define the path to cleanup (if needed)
set "CLEANUP_PATH=/home/martes/martes_setup"

REM ===========================
REM Helper Functions
REM ===========================

REM Function to display error messages and exit
:exit_with_error
echo ERROR: %~1
pause
exit /b 1

REM ===========================
REM Check if WSL is Installed
REM ===========================

wsl --version >nul 2>&1
if %errorlevel% neq 0 (
    echo WSL is not installed. Please install WSL first.
    pause
    exit /b
)

REM ===========================
REM Combine sudo commands to Avoid Multiple Password Prompts
REM ===========================

echo Configuring user '%USERNAME%' and setting up sudoers...

wsl -d "%DISTRO_NAME%" bash -c "sudo bash -c \"\
    id -u %USERNAME% &>/dev/null || adduser --disabled-password --gecos '' %USERNAME%; \
    echo '%USERNAME% ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/%USERNAME%; \
    rm -rf %CLEANUP_PATH%\""

if %errorlevel% neq 0 (
    call :exit_with_error "Failed to add user '%USERNAME%' and configure sudoers."
)

echo User '%USERNAME%' created and sudoers configured successfully.

REM ===========================
REM Clone or Update the Repository as '%USERNAME%'
REM ===========================

echo Cloning or updating the repository as user '%USERNAME%'...

wsl -d "%DISTRO_NAME%" bash -c "sudo -u %USERNAME% bash -c \"\
    if [ ! -d ~/martes_setup ]; then \
        git clone %REPO_URL% ~/martes_setup; \
    else \
        cd ~/martes_setup && git pull; \
    fi\""

if %errorlevel% neq 0 (
    call :exit_with_error "Failed to clone or update the repository."
)

echo Repository cloned or updated successfully.

REM ===========================
REM Run the Setup Script as '%USERNAME%'
REM ===========================

echo Running the setup script '%SETUP_SCRIPT%' as user '%USERNAME%'...

wsl -d "%DISTRO_NAME%" bash -c "sudo -u %USERNAME% bash -c \"\
    cd ~/martes_setup && bash %SETUP_SCRIPT%\""

if %errorlevel% neq 0 (
    call :exit_with_error "Failed to run the setup script '%SETUP_SCRIPT%'."
)

echo Setup script executed successfully.

REM ===========================
REM Execute Additional Batch Scripts
REM ===========================

echo Executing additional batch scripts...

REM Execute user_access.bat
if exist "user_access.bat" (
    call user_access.bat
    if %errorlevel% neq 0 (
        call :exit_with_error "Failed to execute user_access.bat."
    )
) else (
    echo Warning: user_access.bat not found.
)

REM Navigate to the 'start' directory and execute check.bat
if exist "..\start\check.bat" (
    cd ..\start\
    if %errorlevel% neq 0 (
        call :exit_with_error "Failed to navigate to the 'start' directory."
    )
    call check.bat
    if %errorlevel% neq 0 (
        call :exit_with_error "Failed to execute check.bat."
    )
) else (
    echo Warning: check.bat not found in the 'start' directory.
)

REM ===========================
REM Final Success Message
REM ===========================

echo.
echo Done, Martes should now be ready!
pause
exit /b
