@echo off
chcp 65001 >nul

set "CURRENT_PATH=%~dp0"


echo Installerar WSL...
wsl --version >nul 2>&1
if %errorlevel% neq 0 (
    echo "WSL ar inte installerat sa vi installerar detta. Observera att detta kraver att du ar lokal admin och det kommer krava omstart av din dator efterat."

    REM Enable the Windows Subsystem for Linux feature
    dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

    REM Enable the Virtual Machine Platform feature
    dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

    REM Install the WSL update package
    echo Uppdaterar WSL...
    wsl --update

    REM Restart the system to apply changes
    echo.
    echo Vanligen starta om din dator for att fardigstalla denna delen av installationen.
    echo Efter omstart kor du detta script install.bat igen.
    pause
    exit /b
)

call install_2.bat
