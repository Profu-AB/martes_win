@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env"
set "JOULE_OLLAMA="
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (

    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
    if "%%a"=="LICENSE" set "LICENSE=%%b"
    if "%%a"=="JOULE_OLLAMA" set "JOULE_OLLAMA=%%b"
)



call start_wsl.bat


:: Specify the path to your Docker Compose YAML file (modify with the actual path)
set COMPOSE_FILE_PATH=./docker-compose.yaml

:: Check if Ollama should be started
set PROFILE_FLAG=
if "%JOULE_OLLAMA%"=="true" set PROFILE_FLAG=--profile ollama

:: Run Docker Compose in WSL
echo Running Docker Compose in WSL...
if "%JOULE_OLLAMA%"=="true" (
    echo Starting with Joule AI (Ollama)...
) else (
    echo Starting without Joule AI (Ollama)...
)
wsl -d %DISTRO_NAME% --exec docker compose -f %COMPOSE_FILE_PATH% %PROFILE_FLAG% up -d

:: Finish
echo Docker Compose has started the services in detached mode.

:: start http://localhost:8080
start http://localhost:8080/?license=%LICENSE%

endlocal



