@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env.qa"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)

echo Detta tar bort QA-distron "%DISTRO_NAME%" och alla containrar/volymer.
set /p CONFIRM=Ar du saker? (j/n):
if /i not "%CONFIRM%"=="j" exit /b 0

call "%~dp0shutdown.bat"

wsl --unregister %DISTRO_NAME%
echo QA-distron "%DISTRO_NAME%" har avregistrerats.

if exist "%~dp0wsl_%DISTRO_NAME%" (
    rmdir /s /q "%~dp0wsl_%DISTRO_NAME%"
    echo WSL-mappen har tagits bort.
)
