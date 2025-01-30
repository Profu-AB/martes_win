@echo off
echo Uppdate DefaultValues in Martes Database

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

REM Debug: Print the value of MARTES_REMOTE_HOME
echo MARTES_REMOTE_HOME is set to: %MARTES_REMOTE_HOME%

REM Change to the directory containing update.sh and docker-compose.yml
REM wsl bash -c "cd '%MARTES_REMOTE_HOME%' && sh update_db.sh"
wsl -d "%DISTRO_NAME%" bash -c "cd '%MARTES_REMOTE_HOME%' && sh update_db.sh"



pause