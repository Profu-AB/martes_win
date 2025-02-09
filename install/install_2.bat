@echo off
setlocal

:: Get the current directory
set CURRENT_DIR=%cd%

:: Define the Alpine tarball location in the current directory's "tars" folder
set TAR_FILE=%CURRENT_DIR%\tars\alpine_edge-080220250902.tar

:: Define the custom name for the WSL instance
set CUSTOM_NAME=profu-martes

:: Import Alpine Linux with a custom name to the current directory in WSL
echo Importing Alpine to %CURRENT_DIR% with the custom name "%CUSTOM_NAME%"...
wsl --import %CUSTOM_NAME% "%CURRENT_DIR%\wsl_%CUSTOM_NAME%" "%TAR_FILE%"

:: Ensure the Alpine instance is initialized by setting up its filesystem and configuring
echo Initializing Alpine instance...
wsl -d %CUSTOM_NAME% --exec ash -c "echo 'Alpine initialized.'"

:: Install bash inside the WSL instance after initialization
echo Installing bash inside the WSL instance...
wsl -d %CUSTOM_NAME% --exec ash -c "apk update && apk add bash"

:: Running setup.sh script inside the WSL instance using bash
echo Running setup.sh script inside the WSL instance...
wsl -d %CUSTOM_NAME% --exec bash -c "chmod +x setup.sh && ./setup.sh"





:: Finish
echo "%CUSTOM_NAME%" has successfully been created  %CURRENT_DIR%\wsl_%CUSTOM_NAME%.
echo wsl --shutodwn
wsl --shutdown
wsl --list -v
endlocal
