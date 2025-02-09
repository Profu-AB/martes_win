@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    
    if "%%a"=="DISTRO_DEFAULT_NAME" set "DISTRO_NAME=%%b"
)

set "CURRENT_PATH=%~dp0"
set "BASE_DISTRO=%DISTRO_NAME%
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
    echo WSL instance "%BASE_DISTRO%" fanns inte sedan tidigare så vi installerar den...
    wsl --install -d "%BASE_DISTRO%"
    wsl -d "%BASE_DISTRO%" --exec echo "WSL Initialized" >nul 2>&1
)

