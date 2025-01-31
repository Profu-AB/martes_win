@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: Get the current script directory dynamically
set "CURRENT_PATH=%~dp0"
set "WSL_TAR_PATH=%CURRENT_PATH%ubuntu-profu.tar"
set "WSL_NAME=Ubuntu-Profu"
set "BASE_DISTRO=Ubuntu-22.04"
set "FOUND=false"

echo Kontrollerar om %BASE_DISTRO% finns installerad...

:: Read and process WSL list output correctly
for /f "delims=" %%i in ('wsl --list --quiet ^| wsl --exec iconv -f UTF-16LE -t ASCII') do (
    set "DISTRONAME=%%i"
    
    if /I "!DISTRONAME!"=="%BASE_DISTRO%" (
        
        set FOUND=true
    )
)

:: Check if the instance was found
if "!FOUND!"=="false" (
    echo WSL instance "%BASE_DISTRO%" fanns inte sedan tidigare så vi installerar den...
    wsl --install -d "%BASE_DISTRO%"
    wsl -d "%BASE_DISTRO%" --exec echo "WSL Initialized" >nul 2>&1
)

wsl --export "%BASE_DISTRO%" "%WSL_TAR_PATH%"
wsl --import "%WSL_NAME%" "%CURRENT_PATH%%WSL_NAME%" "%WSL_TAR_PATH%" --version 2