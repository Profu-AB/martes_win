@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    if "%%a"=="MARTES_REMOTE_HOME" set "MARTES_REMOTE_HOME=%%b"
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)



call start_wsl.bat


:: Specify the path to your Docker Compose YAML file (modify with the actual path)
set COMPOSE_FILE_PATH=./docker-compose.yaml

:: Run Docker Compose in WSL
echo Running Docker Compose in WSL...
wsl -d %DISTRO_NAME% --exec docker compose -f %COMPOSE_FILE_PATH% up -d

:: Finish
echo Docker Compose has started the services in detached mode.
endlocal



