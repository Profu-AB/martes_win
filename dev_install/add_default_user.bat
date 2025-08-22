@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion

rem --- Läs .env ---
set "ENV_FILE=%~dp0..\.env"
if not exist "%ENV_FILE%" (
  echo [FEL] Hittar inte %ENV_FILE%
  exit /b 1
)

for /f "usebackq tokens=1,2 delims==" %%a in (`findstr /r "^[^#]" "%ENV_FILE%"`) do (
  set "k=%%a"
  set "v=%%b"
  rem trimma enkel CR/LF/mellanslag runt värdet
  for /f "tokens=* delims= " %%# in ("!v!") do set "v=%%#"
  set "v=!v:~0,-0!"
  if /i "!k!"=="DISTRO_DEFAULT_NAME" set "DISTRO_NAME=!v!"
  if /i "!k!"=="LINUX_USER_NAME"     set "LINUX_USER_NAME=!v!"
)

if not defined DISTRO_NAME (
  echo [FEL] DISTRO_DEFAULT_NAME saknas i .env
  exit /b 1
)
if not defined LINUX_USER_NAME (
  echo [FEL] LINUX_USER_NAME saknas i .env
  exit /b 1
)

echo Distro  : %DISTRO_NAME%
echo Anvandare: %LINUX_USER_NAME%

rem --- Skapa anvandaren om den saknas, lagg i sudo, satta default-user i wsl.conf ---
wsl -d %DISTRO_NAME% --user root bash -lc ^
  "set -e; \
   if ! id -u %LINUX_USER_NAME% >/dev/null 2>&1; then \
     adduser --disabled-password --gecos '' %LINUX_USER_NAME%; \
   fi; \
   usermod -aG sudo %LINUX_USER_NAME%; \
   printf '[user]\ndefault=%LINUX_USER_NAME%\n' > /etc/wsl.conf"

rem --- Terminera så att default-user träder i kraft ---
wsl --terminate %DISTRO_NAME%

echo Klart. Starta distrot med:  wsl -d %DISTRO_NAME%
echo Du bor nu landa som anvandaren "%LINUX_USER_NAME%".

