@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)


echo Kör dev_backup.sh i WSL distribution "%DISTRO_NAME%"...

REM ===========================
REM Get the Current and Parent Paths
REM ===========================

REM Get the current directory in Windows format
for /f "delims=" %%i in ('cd') do set "CURRENT_PATH=%%i"

REM Convert the current directory to WSL format
for /f "delims=" %%i in ('wsl wslpath "%CURRENT_PATH%"') do set "WSL_CURRENT_PATH=%%i"

REM Determine the parent path correctly
set "PARENT_PATH=%~dp0\.."
cd /d "%PARENT_PATH%"
set "PARENT_PATH=%cd%"

REM Debug: Print the value of PARENT_PATH
echo PARENT_PATH is set to: %PARENT_PATH%

REM ===========================
REM Run the Backup Script in WSL
REM ===========================

wsl -d %DISTRO_NAME% bash -c "sh './dev_backup.sh' '%PARENT_PATH%'"

REM Check if the command was successful
if %errorlevel% neq 0 (
    echo ERROR: Failed to execute backup.sh in "%DISTRO_NAME%".
    pause
    exit /b 1
)

echo klart! "%DISTRO_NAME%".
pause
exit /b
