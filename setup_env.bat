@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

:: Check if the user provided a license argument
IF "%~1"=="" (
    echo Error: License code is missing.
    echo Usage: setup_env.bat YOUR_LICENSE_CODE
    exit /b 1
)

SET "LICENSE=%~1"

:: Copy .env.template to .env
COPY /Y .env.template .env

:: Replace placeholder with the actual license key
(for /f "delims=" %%i in (.env) do (
    set "line=%%i"
    set "line=!line:BYT_DENNA_TEXT_MOT_DIN_LICENSKOD=%LICENSE%!"
    echo !line!
)) > .env.tmp

:: Overwrite .env with the modified content
MOVE /Y .env.tmp .env

echo ✅ .env file has been created with your license code!
