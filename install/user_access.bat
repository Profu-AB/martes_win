@echo off
REM Enable delayed variable expansion
setlocal enabledelayedexpansion

REM Retrieve the current directory in Windows format
set "WIN_PATH=%cd%"

REM Use wslpath to convert Windows path to WSL path
for /f "usebackq tokens=*" %%i in (`wsl wslpath "%WIN_PATH%"`) do set "WSL_PATH=%%i"

REM Optional: Echo the paths for debugging
echo Windows Path: %WIN_PATH%
echo WSL Path: %WSL_PATH%

REM Execute the WSL script in the converted directory
wsl bash -c "cd '%WSL_PATH%' && ./user_access.sh"


cd ..\start