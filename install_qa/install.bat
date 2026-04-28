@echo off
setlocal EnableDelayedExpansion

:: Step 1: Copy .env.qa.template to ..\.env.qa
copy ".env.qa.template" "..\.env.qa"
if errorlevel 1 (
    echo Failed to copy .env.qa.template to .env.qa in parent folder.
    exit /b 1
)

:: Step 2: Prompt for license code
set /p LICENSEKEY=Enter your QA license code:

:: Step 3: Replace the value in LICENSE= line
set "inputFile=..\.env.qa"
set "tempFile=..\.env.qa.tmp"

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

echo .env.qa file has been configured successfully.

call install_1.bat
