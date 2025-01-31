@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: Get the current script directory dynamically
set "CURRENT_PATH=%~dp0"
set "WSL_TAR_PATH=%CURRENT_PATH%ubuntu-profu.tar"
set "WSL_NAME=Ubuntu-Profu"
set "FOUND=false"

echo 📦 Installerar Martes 
echo Kontrollerar om WSL-distributionen %WSL_NAME% redan finns installerad...

:: Read and process WSL list output correctly
for /f "delims=" %%i in ('wsl --list --quiet ^| wsl --exec iconv -f UTF-16LE -t ASCII') do (
    set "DISTRONAME=%%i"
    
    if /I "!DISTRONAME!"=="%WSL_NAME%" (
        set FOUND=true
    )
)

:: Check if the instance was found
if "!FOUND!"=="false" (
    echo "%WSL_NAME%" fanns inte sedan tidigare så vi installerar den...
    call install_wsl_profu_2.bat
    echo startar script i WSL distributionen....
    endlocal
    call setup_wsl.bat
    
    
) 


exit /b
