@echo off
echo Uppdate DefaultValues in Martes Database

@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)


wsl -d "%DISTRO_NAME%" bash -c "sh ./update_db.sh"



pause