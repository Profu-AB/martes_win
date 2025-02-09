@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (
    
    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)

:: Get the current directory
set CURRENT_DIR=%cd%

:: Define the Alpine tarball location in the current directory's "tars" folder
set TAR_FILE=%CURRENT_DIR%\tars\alpine_edge-080220250902.tar

:: Define the custom name for the WSL instance
set CUSTOM_NAME=%DISTRO_NAME%

:: Import Alpine Linux with a custom name to the current directory in WSL
echo importerar linux distributionen "Alpine" till %CURRENT_DIR% med namnet "%CUSTOM_NAME%"...
wsl --import %CUSTOM_NAME% "%CURRENT_DIR%\wsl_%CUSTOM_NAME%" "%TAR_FILE%"

:: Ensure the Alpine instance is initialized by setting up its filesystem and configuring

echo Installerar nödvändiga filer i %CUSTOM_NAME%
wsl -d %CUSTOM_NAME% --exec ash -c "apk update && apk add bash"

:: Running setup.sh script inside the WSL instance using bash
echo Running setup.sh script inside the WSL instance...
wsl -d %CUSTOM_NAME% --exec bash -c "chmod +x setup.sh && ./setup.sh"

REM wsl -d %CUSTOM_NAME% --exec ash -c "echo Klart!"

:: Finish
echo "%CUSTOM_NAME%" har färdigställts och finns nu i  %CURRENT_DIR%\wsl_%CUSTOM_NAME%.
echo wsl --shutodwn
wsl --shutdown
wsl --list -v
call start.bat
endlocal
