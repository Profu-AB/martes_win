@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)

rem Ask the user for confirmation
echo Det här kommer avinstallera Martes och all data du har sparat kommer att försvinna (dock ej backuper). Är du säker på att du vill göra detta?

choice /C YN /M "Tryck Y för att gå vidare, N för att avbryta"

rem If user presses "Y", continue with the unregistration
if errorlevel 2 (
    echo Operation avbruten.
    exit /B
) else (
    echo Avinstallerar  WSL distributionen "%DISTRO_NAME%"...
    wsl --unregister %DISTRO_NAME%
    wsl --list -v
)

rem End of script
