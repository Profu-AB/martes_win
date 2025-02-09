@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    
    if "%%a"=="DISTRO_DEFAULT_NAME" set "DISTRO_NAME=%%b"
)

set "CURRENT_PATH=%~dp0"



set "FOUND=false"

echo 📦 Installerar Martes 
echo Kontrollerar om WSL-distributionen %DISTRO_NAME% redan finns installerad...

:: Read and process WSL list output correctly
for /f "delims=" %%i in ('wsl --list --quiet ^| wsl --exec iconv -f UTF-16LE -t ASCII') do (
    set "WSL_NAME=%%i"
    
    if /I "!WSL_NAME!"=="%DISTRO_NAME%" (
        set FOUND=true
    )
)

:: Check if the instance was found
if "!FOUND!"=="false" (
    echo "%DISTRO_NAME%" fanns inte sedan tidigare så vi installerar den...
    call install_wsl_profu_2.bat
    echo startar script i WSL distributionen....
    endlocal
    call setup_wsl.bat
    
    
) 


exit /b

