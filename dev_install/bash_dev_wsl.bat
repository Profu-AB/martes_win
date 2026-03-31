@echo off
chcp 65001 >nul

set "ENV_FILE=%~dp0..\.env"
set "DEV_DISTRO_NAME="
set "DISTRO_NAME="
set "DISTRO_DEFAULT_NAME="
set "LINUX_USER_NAME="
set "SELECTED_DISTRO_NAME="

for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (

    if /I "%%a"=="DEV_DISTRO_NAME" set "DEV_DISTRO_NAME=%%b"
    if /I "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
    if /I "%%a"=="DISTRO_DEFAULT_NAME" set "DISTRO_DEFAULT_NAME=%%b"
    if /I "%%a"=="LINUX_USER_NAME" set "LINUX_USER_NAME=%%b"
)

if defined DEV_DISTRO_NAME set "SELECTED_DISTRO_NAME=%DEV_DISTRO_NAME%"
if not defined SELECTED_DISTRO_NAME if defined DISTRO_NAME set "SELECTED_DISTRO_NAME=%DISTRO_NAME%"
if not defined SELECTED_DISTRO_NAME if defined DISTRO_DEFAULT_NAME set "SELECTED_DISTRO_NAME=%DISTRO_DEFAULT_NAME%"

if "%SELECTED_DISTRO_NAME%"=="" (
    echo ERROR: DEV_DISTRO_NAME, DISTRO_NAME or DISTRO_DEFAULT_NAME is not set in %ENV_FILE%
    exit /b 1
)

wsl -d %SELECTED_DISTRO_NAME% --exec bash -c "cd /home/martes/martes/docker/dev && exec bash"
