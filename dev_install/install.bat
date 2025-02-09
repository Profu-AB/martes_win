@echo off
chcp 65001 >nul

set "CURRENT_PATH=%~dp0"


echo 📦 Installerar WSL... 
wsl --version >nul 2>&1
if %errorlevel% neq 0 (
    echo "WSL är inte installerat så vi installerar detta. Observera att detta kräver att du är lokal admin och det kommer kräva omstart av din dator efteråt."
    
    REM Enable the Windows Subsystem for Linux feature
    dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

    REM Enable the Virtual Machine Platform feature
    dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

    REM Install the WSL update package
    echo Uppdaterar WSL...
    wsl --update

    REM Restart the system to apply changes
    echo.
    echo Vänligen starta om  din dator för att färdigställa denna delen av installationen.
    echo Efter omstart kör du detta script install_wsl.bat igen.
    pause
    exit /b
)

call install_wsl_profu
wsl --shutdown


exit /b