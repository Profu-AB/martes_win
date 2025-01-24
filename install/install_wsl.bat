@echo off

REM Check if WSL is installed
wsl --version >nul 2>&1
if %errorlevel% neq 0 (
    echo "WSL is not installed. Installing WSL..."
    
    REM Enable the Windows Subsystem for Linux feature
    dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

    REM Enable the Virtual Machine Platform feature
    dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

    REM Install the WSL update package
    echo "Installing the latest WSL package..."
    wsl --update

    REM Restart the system to apply changes
    echo.
    echo "Please restart your computer to complete the installation."
    echo "After restarting, re-run this script to continue."
    pause
    exit /b
)

REM Ensure WSL is set to use version 2 by default
echo.
echo "Setting WSL version 2 as the default..."
wsl --set-default-version 2

REM Install the desired Linux distribution
echo.
echo "Installing Ubuntu-22.04..."
wsl --install -d Ubuntu-22.04

REM Change the default WSL distribution to Ubuntu-22.04
echo.
echo "Setting Ubuntu-22.04 as the default WSL distribution..."
wsl --set-default Ubuntu-22.04

REM Wait for WSL setup to finish and create the user
echo.
echo "Ubuntu-22.04 is now being set up. Please complete the prompts to create a Linux username and password."
echo.

REM Add a one-time auto-exit command
wsl -d Ubuntu-22.04 -u root bash -c "echo 'exit 0' >> /etc/bash.bashrc"

REM Start WSL for user setup
wsl -d Ubuntu-22.04 bash -c "echo 'running initial setup...' && exit"


REM Inform the user and return to the command prompt
echo.
echo "WSL setup is complete. You are now back at the Windows command prompt."
echo.



wsl --shutdown
wsl --list --verbose

REM Remove the auto-exit command after first login
wsl -d Ubuntu-22.04 -u root bash -c "sed -i '/exit 0/d' /etc/bash.bashrc"



exit /b