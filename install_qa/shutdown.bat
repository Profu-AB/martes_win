@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env.qa"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)

call "%~dp0start_wsl.bat"

echo Stopping QA Docker Compose services...
wsl -d %DISTRO_NAME% --exec docker compose -f ./docker-compose.yaml down

call "%~dp0stop_wsl.bat"
