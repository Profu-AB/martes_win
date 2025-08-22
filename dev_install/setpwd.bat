@echo off
chcp 65001 >nul
setlocal DisableDelayedExpansion

rem --- read .env ---
set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
  if "%%a"=="DISTRO_DEFAULT_NAME" set "DISTRO_NAME=%%b"
  if "%%a"=="LINUX_USER_NAME"     set "LINUX_USER_NAME=%%b"
)

set "LINUX_USER_PASSWORD=%~1"
if not defined LINUX_USER_PASSWORD (
  echo Usage: %~nx0 ^<password^>
  exit /b 1
)




:: Get the current script directory dynamically
set "CURRENT_PATH=%~dp0"
set "FOUND=false"


wsl -d %DISTRO_NAME% --user root bash -lc "echo '%LINUX_USER_NAME%:%LINUX_USER_PASSWORD%' | chpasswd"