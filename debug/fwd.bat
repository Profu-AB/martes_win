@echo off
setlocal enabledelayedexpansion

echo Retrieving WSL2 IP address...

:: Get WSL2 IP address
for /f "tokens=1 delims= " %%A in ('wsl -d Ubuntu-Profu hostname -I') do set WSL_IP=%%A

:: Check if the IP address was retrieved
if "%WSL_IP%"=="" (
    echo Failed to retrieve WSL2 IP address.
    exit /b 1
)

echo WSL2 IP Address: %WSL_IP%

:: Define ports to forward
set PORTS=80 8000 27018

:: Loop through each port and add forwarding rules
for %%P in (%PORTS%) do (
    echo Adding port forwarding for port %%P...
    netsh interface portproxy add v4tov4 listenport=%%P listenaddress=0.0.0.0 connectport=%%P connectaddress=%WSL_IP%
    echo Adding firewall rule for port %%P...
    netsh advfirewall firewall add rule name="WSL2 Port %%P" dir=in action=allow protocol=TCP localport=%%P
)

echo Port forwarding complete!
exit /b 0
