@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)





wsl -d %DISTRO_NAME% sh -c "cd /home/martes/martes_setup/nginx/conf.d/ && chmod 664 default.conf" 