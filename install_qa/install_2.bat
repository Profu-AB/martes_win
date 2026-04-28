@echo off
chcp 65001 >nul
set "ENV_FILE=%~dp0..\.env.qa"
for /f "tokens=1,2 delims==" %%a in ('findstr /r "^[^#]" "%ENV_FILE%"') do (

    if "%%a"=="DISTRO_NAME" set "DISTRO_NAME=%%b"
)

:: Get the current directory
set CURRENT_DIR=%cd%

:: Use shared tarball from prod install folder (same Alpine base)
set TAR_FILE=%CURRENT_DIR%\..\install\tars\alpine_edge-080220250902.tar

if not exist "%TAR_FILE%" (
    echo Tarball hittas inte: %TAR_FILE%
    echo Kontrollera att install\tars\ finns i parent-mappen.
    pause
    exit /b 1
)

:: Define the custom name for the WSL instance
set CUSTOM_NAME=%DISTRO_NAME%

:: Import Alpine Linux with a custom name to the current directory in WSL
echo Importerar linux distributionen "Alpine" till %CURRENT_DIR% med namnet "%CUSTOM_NAME%"...
wsl --import %CUSTOM_NAME% "%CURRENT_DIR%\wsl_%CUSTOM_NAME%" "%TAR_FILE%"

echo Installerar nodvandiga filer i %CUSTOM_NAME%
wsl -d %CUSTOM_NAME% --exec ash -c "apk update && apk add bash"

:: Running setup.sh script inside the WSL instance using bash
echo Running setup.sh script inside the WSL instance...
wsl -d %CUSTOM_NAME% --exec bash -c "chmod +x setup.sh && ./setup.sh"

:: Create .wslconfig to prevent WSL from going idle
set WSLCONFIG=%USERPROFILE%\.wslconfig
if not exist "%WSLCONFIG%" (
    echo Creating .wslconfig to prevent WSL idle timeout...
    echo [wsl2]> "%WSLCONFIG%"
    echo vmIdleTimeout=-1>> "%WSLCONFIG%"
)

:: Finish
echo "%CUSTOM_NAME%" har fardigstallts och finns nu i %CURRENT_DIR%\wsl_%CUSTOM_NAME%.
echo wsl --shutdown
wsl --shutdown
wsl --list -v
call start.bat
endlocal
