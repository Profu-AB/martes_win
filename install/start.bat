@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
    if "%%a"=="LICENSE" set "LICENSE=%%b"
)

call "%~dp0start_wsl.bat"

:: Run Docker Compose in WSL
echo Running Docker Compose in WSL...
wsl -d %DISTRO_NAME% --exec docker compose -f ./docker-compose.yaml up -d

:: Finish
echo Docker Compose has started the services in detached mode.

:: start http://localhost:8080
start http://localhost:8080/?license=%LICENSE%



