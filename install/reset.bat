@echo off
setlocal enabledelayedexpansion

REM ===========================
REM Load Environment Variables from .env File
REM ===========================

REM Read .env file and extract DISTRO_NAME
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" .env') do (
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)

REM Check if the variable was set
if "%DISTRO_NAME%"=="" (
    echo ERROR: DISTRO_NAME is not set. Check the .env file.
    pause
    exit /b 1
)

REM ===========================
REM Debug Output After Loading Variables
REM ===========================
echo DISTRO_NAME is set to: %DISTRO_NAME%
echo Unregistering WSL distribution "%DISTRO_NAME%"...

REM ===========================
REM Unregister the WSL Distribution
REM ===========================

wsl --unregister "%DISTRO_NAME%"

REM Check if the command was successful
if %errorlevel% neq 0 (
    echo ERROR: Failed to unregister WSL distribution "%DISTRO_NAME%".
    pause
    exit /b 1
)

echo WSL distribution "%DISTRO_NAME%" has been unregistered successfully.
pause
exit /b

