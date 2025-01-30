REM Define the WSL distribution name
set "DISTRO_NAME=Ubuntu-22.04-Profu"

wsl --terminate "%DISTRO_NAME%"

echo WSL distribution "%DISTRO_NAME%" has been terminated successfully.