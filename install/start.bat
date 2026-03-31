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

:: Wait for backend to be ready
echo Waiting for backend to start...
:wait_loop
wsl -d %DISTRO_NAME% --exec bash -c "curl -sf http://localhost:8000/getVersion > /dev/null 2>&1" && goto :ready
timeout /t 2 /nobreak >nul
goto :wait_loop
:ready
echo Backend is ready.

start http://localhost:8080/?license=%LICENSE%

endlocal
