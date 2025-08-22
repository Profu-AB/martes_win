@echo off
chcp 65001 >nul

set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    if "%%a"=="DISTRO_DEFAULT_NAME" set "DISTRO_NAME=%%b"
    if "%%a"=="LINUX_USER_NAME"     set "LINUX_USER_NAME=%%b"
)

echo Distro  : %DISTRO_NAME%
echo Anvandare: %LINUX_USER_NAME%

rem 1) Skapa användaren om den saknas
wsl -d %DISTRO_NAME% --user root bash -lc "id -u %LINUX_USER_NAME% >/dev/null 2>&1 || adduser --disabled-password --gecos '' %LINUX_USER_NAME%"

rem 2) Lägg i sudo
wsl -d %DISTRO_NAME% --user root bash -lc "usermod -aG sudo %LINUX_USER_NAME%"

rem 3) Sätt default user i wsl.conf
wsl -d %DISTRO_NAME% --user root bash -lc "printf '[user]\ndefault=%LINUX_USER_NAME%\n' > /etc/wsl.conf"

rem 4) Starta om distrot så att ändringen gäller
wsl --terminate %DISTRO_NAME%

echo Klart. Starta med: wsl -d %DISTRO_NAME%
