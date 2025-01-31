@echo off
echo Shutting down...

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



REM Run docker-compose


wsl -d "%DISTRO_NAME%" docker compose -f "%MARTES_REMOTE_HOME%/docker-compose.yaml" down


echo Containers stoped.

pause
