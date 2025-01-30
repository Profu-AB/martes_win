@echo off
setlocal enabledelayedexpansion

REM Define variables for easier maintenance

set "ENV_FILE=%~dp0..\env"
REM Read .env file and extract variables
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    if "%%a"=="MARTES_REMOTE_HOME" set "MARTES_REMOTE_HOME=%%b"
    if "%%a"=="DISTRO_NAME" set "DISTRO_NEW_NAME=%%b"
    if "%%a"=="DISTRO_DEFAULT_NAME" set "DISTRO_DEFAULT_NAME=%%b"
)


REM Check if WSL is installed
wsl --version >nul 2>&1
if %errorlevel% neq 0 (
    echo WSL is not installed. Installing WSL...
    
    REM Enable the Windows Subsystem for Linux feature
    dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    if %errorlevel% neq 0 (
        call :exit_with_error "Failed to enable the Windows Subsystem for Linux feature."
    )

    REM Enable the Virtual Machine Platform feature
    dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    if %errorlevel% neq 0 (
        call :exit_with_error "Failed to enable the Virtual Machine Platform feature."
    )

    REM Install the WSL update package
    echo Installing the latest WSL package...
    wsl --update
    if %errorlevel% neq 0 (
        call :exit_with_error "Failed to update WSL."
    )

    REM Restart the system to apply changes
    echo.
    echo Please restart your computer to complete the installation.
    echo After restarting, re-run this script to continue.
    pause
    exit /b
)

REM Ensure WSL is set to use version 2 by default
echo.
echo Setting WSL version 2 as the default...
wsl --set-default-version 2
if %errorlevel% neq 0 (
    call :exit_with_error "Failed to set WSL version 2 as default."
)
echo WSL version 2 set as default.

REM Check if the new distribution name already exists
wsl --list --quiet | findstr /i "%DISTRO_NEW_NAME%" >nul
if %errorlevel% equ 0 (
    call :exit_with_error "The distribution name '%DISTRO_NEW_NAME%' already exists. Please choose a different name or uninstall the existing one."
)

REM Install the desired Linux distribution with the default name
echo.
echo Installing %DISTRO_DEFAULT_NAME%...
wsl --install -d "%DISTRO_DEFAULT_NAME%"
if %errorlevel% neq 0 (
    call :exit_with_error "Failed to install %DISTRO_DEFAULT_NAME%."
)

REM Wait for the installation to complete by checking if the distro is listed
set "MAX_RETRIES=60"
set "COUNT=0"

:wait_for_install
wsl --list --quiet | findstr /i "%DISTRO_DEFAULT_NAME%" >nul
if %errorlevel% neq 0 (
    set /a COUNT+=1
    if %COUNT% geq %MAX_RETRIES% (
        call :exit_with_error "Installation of %DISTRO_DEFAULT_NAME% timed out."
    )
    echo Waiting for %DISTRO_DEFAULT_NAME% to install... (Attempt %COUNT% of %MAX_RETRIES%)
    timeout /t 5 >nul
    goto wait_for_install
)
echo %DISTRO_DEFAULT_NAME% installation detected.

REM Rename the distribution to the new desired name
echo.
echo Renaming %DISTRO_DEFAULT_NAME% to %DISTRO_NEW_NAME%...
wsl --rename "%DISTRO_DEFAULT_NAME%" "%DISTRO_NEW_NAME%"
if %errorlevel% neq 0 (
    call :exit_with_error "Failed to rename the distribution."
)
echo Renamed successfully to %DISTRO_NEW_NAME%.

REM *Do not set the new distribution as default*
REM Users can set their preferred default distribution manually if desired.

REM Wait for WSL setup to finish and create the user
echo.
echo %DISTRO_NEW_NAME% is now being set up. Please complete the prompts to create a Linux username and password.
echo.

REM Add a one-time auto-exit command to /etc/bash.bashrc for initial setup
wsl -d "%DISTRO_NEW_NAME%" -u root bash -c "echo 'exit 0' >> /etc/bash.bashrc"
if %errorlevel% neq 0 (
    call :exit_with_error "Failed to modify /etc/bash.bashrc for initial setup."
)

REM Start WSL for user setup
wsl -d "%DISTRO_NEW_NAME%" bash -c "echo 'running initial setup...' && exit"
if %errorlevel% neq 0 (
    call :exit_with_error "Failed to initiate user setup."
)

REM Inform the user and return to the command prompt
echo.
echo WSL setup is complete. You are now back at the Windows command prompt.
echo.

REM Terminate only the new distribution to apply changes
wsl --terminate "%DISTRO_NEW_NAME%"
if %errorlevel% neq 0 (
    echo Failed to terminate "%DISTRO_NEW_NAME%". Please check its status manually.
) else (
    echo Successfully terminated "%DISTRO_NEW_NAME%".
)

REM List all installed distributions with verbose information
wsl --list --verbose

REM Remove the auto-exit command after first login
wsl -d "%DISTRO_NEW_NAME%" -u root bash -c "sed -i '/exit 0/d' /etc/bash.bashrc"
if %errorlevel% neq 0 (
    echo Failed to remove the auto-exit command from /etc/bash.bashrc.
    echo You may need to remove it manually.
)

echo.
echo Installation and renaming of %DISTRO_NEW_NAME% completed successfully.
echo.
exit /b
