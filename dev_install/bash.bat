@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env"

REM Read variables from .env file
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    
    if "%%a"=="DISTRO_DEFAULT_NAME" set "DISTRO_NAME=%%b"
)

REM Enter WSL and change directory

wsl -d %DISTRO_NAME% sh -c "cd /home/\$USER; bash"
