@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)




REM Get the current directory in Windows format
for /f "delims=" %%i in ('wsl wslpath -w "$(pwd)"') do set CURRENT_PATH=%%i

REM Move up one directory
set PARENT_PATH=%~dp0..
cd %PARENT_PATH%
set PARENT_PATH=%cd%

REM Debug: Print the value of PARENT_PATH
echo PARENT_PATH is set to: %PARENT_PATH%

REM Run the restore script
wsl  -d %DISTRO_NAME%  sh "./restore_dev.sh" "%PARENT_PATH%"
pause