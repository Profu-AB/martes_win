@echo off
setlocal EnableDelayedExpansion



:: Step 1: Copy ..\.env.template to ..\.env
copy "..\.env.template" "..\.env"
if errorlevel 1 (
    echo Failed to copy .env.template to .env in parent folder.
    exit /b 1
)

:: Step 2: Prompt for license code
set /p LICENSEKEY=Enter your license code: 

:: Step 3: Replace the value in LICENSE= line
set "inputFile=..\.env"
set "tempFile=..\.env.tmp"

if exist "%tempFile%" del "%tempFile%"

for /f "usebackq delims=" %%A in ("%inputFile%") do (
    set "line=%%A"
    echo !line! | findstr /b /c:"LICENSE=" >nul
    if !errorlevel! == 0 (
        echo LICENSE=!LICENSEKEY!>>"%tempFile%"
    ) else (
        echo !line!>>"%tempFile%"
    )
)

move /Y "%tempFile%" "%inputFile%" >nul

echo .env file has been configured successfully.

call install_1.bat
