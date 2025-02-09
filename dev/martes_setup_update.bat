@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    if "%%a"=="MARTES_REMOTE_HOME" set "MARTES_REMOTE_HOME=%%b"
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)

wsl -d %DISTRO_NAME% sh -c "git config --global --add safe.directory /home/martes/martes_setup" 

wsl -d %DISTRO_NAME% sh -c "cd /home/martes/martes_setup && git pull --rebase" 