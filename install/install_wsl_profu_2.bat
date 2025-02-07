@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    if "%%a"=="MARTES_REMOTE_HOME" set "MARTES_REMOTE_HOME=%%b"
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)

set "CURRENT_PATH=%~dp0"
set "WSL_TAR_PATH=%CURRENT_PATH%ubuntu-profu.tar"
set "BASE_DISTRO=Ubuntu-22.04"
set "FOUND=false"



:: Read and process WSL list output correctly
for /f "delims=" %%i in ('wsl --list --quiet ^| wsl --exec iconv -f UTF-16LE -t ASCII') do (
    set "WSL_NAME=%%i"
    
    if /I "!WSL_NAME!"=="%BASE_DISTRO%" (        
        set FOUND=true
    )
)

:: Check if the instance was found
if "!FOUND!"=="false" (
    
    wsl --install -d "%BASE_DISTRO%"
    wsl -d "%BASE_DISTRO%" --exec echo "WSL Initialized" >nul 2>&1
)

REM --export "%BASE_DISTRO%" "%WSL_TAR_PATH%"
REM wsl --import "%DISTRO_NAME%" "%CURRENT_PATH%%DISTRO_NAME%" "%WSL_TAR_PATH%" --version 2