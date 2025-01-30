@echo off
echo Martes Update

set "DISTRO_NAME=Ubuntu-22.04-Profu"

REM Load environment variables from .env file
setlocal enabledelayedexpansion
for /f "tokens=1,2 delims==" %%a in ('type .env') do (
    if "%%a"=="MARTES_REMOTE_HOME" set "MARTES_REMOTE_HOME=%%b"
)

REM Kontrollera om variabeln är satt
if "%MARTES_REMOTE_HOME%"=="" (
    echo MARTES_REMOTE_HOME är inte satt. Kontrollera .env-filen.
    pause
    exit /b
)

REM Convert the Windows path to a WSL path (if necessary)
REM This assumes that %MARTES_REMOTE_HOME% is a Windows path, so we convert it to the WSL format


REM Debug: Print the value of MARTES_REMOTE_HOME
echo MARTES_REMOTE_HOME is set to: %MARTES_REMOTE_HOME%

echo "turn off"
echo "MARTES_REMOTE_HOME: %MARTES_REMOTE_HOME%"
wsl bash -c "echo 'Current directory:' && cd \"${MARTES_REMOTE_HOME}\" && pwd && ls"


REM wsl bash -c "cd '%MARTES_REMOTE_HOME%' && sh update.sh"
wsl -d "%DISTRO_NAME%" bash -c "cd '%MARTES_REMOTE_HOME%' && sh update.sh"

pause
