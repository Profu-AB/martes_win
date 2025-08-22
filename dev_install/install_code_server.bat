@echo off
setlocal EnableExtensions DisableDelayedExpansion
chcp 65001 >nul

REM --- Load .env if present (DISTRO_DEFAULT_NAME, LINUX_USER_NAME are optional) ---
set "ENV_FILE=%~dp0..\.env"
if exist "%ENV_FILE%" (
  for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    if /i "%%a"=="DISTRO_DEFAULT_NAME" set "DISTRO_NAME=%%b"
    if /i "%%a"=="LINUX_USER_NAME"     set "LINUX_USER_NAME=%%b"
  )
)

REM --- Allow overriding via first/second arg: install_code_server_simple.bat <distro> [linux_user] ---
if not "%~1"=="" set "DISTRO_NAME=%~1"
if not "%~2"=="" set "LINUX_USER_NAME=%~2"

if not defined DISTRO_NAME (
  echo Usage: %~nx0 ^<WSL-distro-name^> [linux-user]
  echo Or set DISTRO_DEFAULT_NAME in .env
  exit /b 1
)

REM --- If no user given, use the distro's default user ---
if not defined LINUX_USER_NAME (
  for /f "usebackq delims=" %%U in (`wsl -d %DISTRO_NAME% -- bash -lc "whoami"`) do set "LINUX_USER_NAME=%%U"
)

echo Distro: %DISTRO_NAME%
echo User  : %LINUX_USER_NAME%
echo.

REM 1) Install prerequisites + code-server (as root)
wsl -d %DISTRO_NAME% --user root bash -lc "set -e; apt-get update && apt-get install -y curl ca-certificates"
wsl -d %DISTRO_NAME% --user root bash -lc "set -e; curl -fsSL https://code-server.dev/install.sh | sh"

REM 2) Write minimal config for the target user (localhost, no auth)
wsl -d %DISTRO_NAME% --user %LINUX_USER_NAME% bash -lc ^
  "set -e; mkdir -p ~/.config/code-server; \
   printf 'bind-addr: 127.0.0.1:8080\nauth: none\ncert: false\n' > ~/.config/code-server/config.yaml; \
   chmod 600 ~/.config/code-server/config.yaml"

REM 3) Start code-server in the background (no systemd required)
wsl -d %DISTRO_NAME% --user %LINUX_USER_NAME% bash -lc ^
  "pgrep -x code-server >/dev/null || nohup code-server >/dev/null 2>&1 &"

echo.
echo ✅ code-server installed and started.
echo Open: http://localhost:8080
echo Config: ~%LINUX_USER_NAME%/.config/code-server/config.yaml
endlocal
