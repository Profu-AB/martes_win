@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    
    if "%%a"=="DISTRO_DEFAULT_NAME" set "DISTRO_NAME=%%b"
)

echo %DISTRO_NAME%
wsl -d %DISTRO_NAME% bash -c "sudo -u martes bash -c 'cd ~/martes_setup && bash user_access.sh'"

exit /b
