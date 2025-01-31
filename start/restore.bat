@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    if "%%a"=="MARTES_REMOTE_HOME" set "MARTES_REMOTE_HOME=%%b"
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)

REM Debug: Print the value of MARTES_REMOTE_HOME
echo MARTES_REMOTE_HOME is set to: %MARTES_REMOTE_HOME%

REM Get the current directory in Windows format
for /f "delims=" %%i in ('wsl wslpath -w "$(pwd)"') do set CURRENT_PATH=%%i

REM Move up one directory
set PARENT_PATH=%~dp0..
cd %PARENT_PATH%
set PARENT_PATH=%cd%

REM Debug: Print the value of PARENT_PATH
echo PARENT_PATH is set to: %PARENT_PATH%

REM Run the restore script
REM wsl sh "%MARTES_REMOTE_HOME%/restore.sh" "%PARENT_PATH%"
wsl -d %DISTRO_NAME% bash -c "sh '%MARTES_REMOTE_HOME%/restore.sh' '%PARENT_PATH%'"

pause