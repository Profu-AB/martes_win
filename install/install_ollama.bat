@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env"

for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)

set PARENT_PATH=%~dp0..
cd %PARENT_PATH%

call install\start_wsl.bat

for /f "delims=" %%i in ('wsl wslpath "%PARENT_PATH%"') do set WSL_PARENT_PATH=%%i
set SCRIPT_PATH=%WSL_PARENT_PATH%/install/install_ollama.sh

wsl -d %DISTRO_NAME% --exec bash -c "chmod +x '%SCRIPT_PATH%' && '%SCRIPT_PATH%'"

pause
