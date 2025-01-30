
@echo off
echo Starting WSL distribution "%DISTRO_NAME%" and keeping it running in the background...

REM Define the WSL distribution name
set "DISTRO_NAME=Ubuntu-22.04-Profu"

REM Start the WSL distribution with a persistent command to keep it running
wsl -d "%DISTRO_NAME%" --exec dbus-launch true

echo WSL distribution "%DISTRO_NAME%" is now running in the background.