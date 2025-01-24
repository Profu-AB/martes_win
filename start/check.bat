@echo off
echo Kontrollerar Martes Containers...

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

REM Print the value of MARTES_REMOTE_HOME
echo MARTES_REMOTE_HOME=%MARTES_REMOTE_HOME%

wsl docker ps




pause