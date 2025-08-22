@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    
    if "%%a"=="DISTRO_DEFAULT_NAME" set "DISTRO_NAME=%%b"
    if "%%a"=="LINUX_USER_NAME" set "LINUX_USER_NAME=%%b"
)

echo %DISTRO_NAME%

REM 1) Prereqs + install code-server
wsl -d %DISTRO_NAME% -- bash -lc "set -e; sudo apt update && sudo apt install -y curl ca-certificates"
wsl -d %DISTRO_NAME% -- bash -lc "set -e; curl -fsSL https://code-server.dev/install.sh | sh"

REM 2) Create config with hashed password for the target user
wsl -d %DISTRO_NAME% -- bash -lc "set -e; HASH=\$(code-server hash-password < '%PWFILE%'); runuser -l %LINUX_USER_NAME% -c 'mkdir -p ~/.config/code-server && printf \"bind-addr: 0.0.0.0:8080\nauth: password\nhashed-password: %s\ncert: false\n\" \"'$HASH'\" > ~/.config/code-server/config.yaml && chmod 600 ~/.config/code-server/config.yaml'"

REM 3) Start code-server (background). If you later enable systemd in WSL, you can switch to the service.
wsl -d %DISTRO_NAME% -- bash -lc "runuser -l %LINUX_USER_NAME% -c 'nohup code-server >/dev/null 2>&1 &'"


