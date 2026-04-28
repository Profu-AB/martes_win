@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env.qa"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
    if "%%a"=="LICENSE" set "LICENSE=%%b"
)

call "%~dp0start_wsl.bat"

:: Run Docker Compose in WSL
echo Running Docker Compose in WSL (QA)...
wsl -d %DISTRO_NAME% --exec docker compose -f ./docker-compose.yaml up -d

:: Finish
echo Docker Compose has started the QA services in detached mode.

:: Open QA frontend
start http://localhost:8081/?license=%LICENSE%
